import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

ListModel {
	id: elementsModel

	property var lastRootObj: null
	property var rootObj: null
	property var selectedObj: null

	onRootObjChanged: update()
	onSelectedObjChanged: {
		for (var i = 0; i < count; i++) {
			var el = get(i)
			setProperty(i, 'selected', el.obj == selectedObj)
		}
	}
	
	function isNull(obj) {
		return obj === null || typeof(obj) === 'undefined'
	}

	function valueToString(value) {
		if (value === null) {
			return "null"
		} else if (typeof(value) === "undefined") {
			return "undefined"
		} else {
			return value.toString()
		}
	}
	function endsWith(str, suffix) {
		var index = str.indexOf(suffix)
		return index >= 0 && index == str.length - suffix.length
	}

	// function appendItem(item) {
	// 	var valueString = valueToString(item)
	// 	append({
	// 		"val": valueString,
	// 	})
	// }

	function isSignal(key, value) {
		return typeof(value) === "function" && endsWith(key, 'Changed')
	}

	function update() {
		if (rootObj === lastRootObj) {
			
		} else {
			clear()
			lastRootObj = rootObj
			parseRootObj()
		}
	}

	function updateProperty(key) {
		for (var i = 0; i < count; i++) {
			var row = get(i)
			if (row.name == key) {
				var value = target[key]
				var valueString = valueToString(value)
				if (row.val !== valueString) {
					console.log(i, key, row.val, valueString)
					setProperty(i, "val", valueString)
				}
				break;
			}
		}
	}
	function updateAllProperties() {
		if (isNull(target)) {
			return
		}
		var keys = Object.keys(target)
		for (var i in keys) {
			var key = keys[i]
			updateProperty(key)
		}
	}

	function parseObj(obj) {
		var el = {
			tagName: valueToString(obj),
			depth: 0,
			selected: selectedObj == obj,
			expanded: false,
			attributes: [],
			attributeKeys: [],
			obj: obj,
		}
		var keys = Object.keys(obj)
		for (var i in keys) {
			var key = keys[i]
			var value = obj[key]
			if (isSignal(key, value)) {

			} else if (typeof(value) === "function") {
			} else {
				console.log('not attribute key', key)
				el.attributes.push({
					key: key,
					value: valueToString(value),
				})
				// el.attributeKeys.push(key)
			}
		}
		return el
	}

	function parseRootObj() {
		selectedObj = rootObj
		var el = parseObj(rootObj)
		// el.selected = true
		append(el)
		for (var i = 0; i < rootObj.children.length; i++) {
			var obj = rootObj.children[i]
			var el = parseObj(obj)
			el.depth = 1
			append(el)
		}
	}

	function findObj(obj) {
		for (var i = 0; i < count; i++) {
			var el = get(i)
			if (el.obj == obj) {
				return i
			}
		}
		return -1
	}

	function expandObj(parentObj) {
		var parentIndex = findObj(parentObj)
		if (parentIndex >= 0) {
			var parentEl = get(parentIndex)
			var childIndex = parentIndex
			for (var i = 0; i < parentObj.children.length; i++) {
				var obj = parentObj.children[i]
				var el = parseObj(obj)
				el.depth = parentEl + 1
				insert(++childIndex, el)
			}
			setProperty(parentIndex, 'expanded', true)
		}

		selectedObj = rootObj
		var el = parseObj(rootObj)
		// el.selected = true
		append(el)
		
	}

	// function getTreeItem(item) {
	// 	return {
	// 		"val": valueToString(item),
	// 		"contents": [],
	// 	}
	// }

	// function unpackParent(item, tree) {
	// 	if (item.parent) {
	// 		var parentTree = getTreeItem(item.parent)
	// 		parentTree.contents.push(tree)
	// 		return parentTree
	// 	} else {
	// 		return tree
	// 	}
	// }

	function setTarget(target) {
		if (isNull(target)) {
			console.log('target.isNull', target)
			return
		}

		var curItem = target
		for (var i = 0; i < 1000; i++) { // Hard limit
			if (!curItem.parent) {
				break;
			}
			curItem = curItem.parent
		}
		rootObj = curItem
	}
}
