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
		console.log('parseObj', obj, obj.children.length)
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
				el.attributes.push({
					key: key,
					value: valueToString(value),
				})
			}
		}
		return el
	}

	function parseRootObj() {
		var el = parseObj(rootObj)
		append(el)
		// expandObj(rootObj)
		selectedObj = rootObj
	}

	function findObj(obj) {
		console.log("findObj", count)
		for (var i = 0; i < count; i++) {
			var el = get(i)
			console.log("el.obj", el.obj, obj, el.obj == obj)
			if (el.obj == obj) {
				return i
			}
		}
		return -1
	}

	function toggleIndex(parentIndex) {
		var parentEl = get(parentIndex)
		if (parentEl.expanded) {
			collapseIndex(parentIndex)
		} else {
			expandIndex(parentIndex)
		}
	}

	function expandIndex(parentIndex) {
		var parentEl = get(parentIndex)
		var childIndex = parentIndex

		var inserted = 0
		for (var i = 0; i < parentEl.obj.children.length; i++) {
			var obj = parentEl.obj.children[i]
			var el = parseObj(obj)
			el.depth = parentEl.depth + 1
			insert(++childIndex, el)
			logDepth(parentEl.depth, 'expandIndex', parentIndex, 'inserted at', childIndex)
			inserted += 1
		}
		setProperty(parentIndex, 'expanded', true)
		return inserted
	}

	function collapseIndex(parentIndex) {
		var parentEl = get(parentIndex)

		var removed = 0
		for (var i = 0; i < parentEl.obj.children.length; i++) {
			var obj = parentEl.obj.children[i]
			var childIndex = findObj(obj)
			if (childIndex >= 0) {
				removed += collapseIndex(childIndex)
				remove(childIndex)
				logDepth(parentEl.depth, 'collapseIndex', parentIndex, 'removed', childIndex)
				removed += 1
			}
		}
		setProperty(parentIndex, 'expanded', false)
		return removed
	}

	function expandObj(parentObj) {
		var parentIndex = findObj(parentObj)
		if (parentIndex >= 0) {
			return expandIndex(parentIndex)
		} else {
			return 0
		}
	}

	function expandAll(parentIndex, maxDepth) {
		// console.log('expandAll', parentIndex, maxDepth)
		if (typeof parentIndex === "undefined") {
			parentIndex = 0
		}

		if (parentIndex < 0 || parentIndex >= count)
			return;
		// console.log('expandAll in range')

		var parentEl = get(parentIndex)

		if (typeof maxDepth === "number" && parentEl.depth >= maxDepth)
			return;
		// console.log('depth below maxDepth', parentEl.depth)

		if (parentEl.expanded)
			return;
		// console.log('not already expanded', parentEl.expanded)

		var inserted = expandIndex(parentIndex)

		logDepth(parentEl.depth, 'for', parentIndex + inserted, '..', parentIndex)
		for (var i = parentIndex + inserted; i > parentIndex; i--) {
			logDepth(parentEl.depth, 'expandAll child', i)
			expandAll(i, maxDepth)
		}
	}

	function logDepth(depth, a, b, c, d, e) {
		var depthStr = ''
		for (var i = 0; i < depth; i++) {
			depthStr += '\t'
		}
		console.log.apply(console, [depthStr].concat(Array.prototype.slice.call(arguments, 1)))
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
