import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import "util.js" as Util

ListModel {
	id: elementsModel

	property var lastRootObj: null
	property var rootObj: null

	signal updated()
	signal elementAdded(var element)

	onRootObjChanged: update()

	// function appendItem(item) {
	// 	var valueString = Util.valueToString(item)
	// 	append({
	// 		"val": valueString,
	// 	})
	// }

	function update() {
		if (rootObj === lastRootObj) {
			
		} else {
			clear()
			lastRootObj = rootObj
			parseRootObj()
		}
		updated()
	}

	function updateProperty(key) {
		for (var i = 0; i < count; i++) {
			var row = get(i)
			if (row.name == key) {
				var value = target[key]
				var valueString = Util.valueToString(value)
				if (row.val !== valueString) {
					console.log(i, key, row.val, valueString)
					setProperty(i, "val", valueString)
				}
				break;
			}
		}
	}
	function updateAllProperties() {
		if (Util.isNull(target)) {
			return
		}
		var keys = Util.getObjectKeys(target)
		for (var i in keys) {
			var key = keys[i]
			updateProperty(key)
		}
	}

	property var ignoredTags: [
		'ContextMenu', // ContextMenu QWindow::transientParent can cause SegFault
	]

	property var ignoredProperties: [
		'parent',
		'data',
		'resources',
		'children',
		'visibleChildren',
		'states',
		'transitions',
		'containmentMask',
		'transform',
		'transformOriginPoint',
		'layer',

		'childrenRect',
		'x',
		'y',
		'width',
		'height',
		'implicitWidth',
		'implicitHeight',

		'visualParent',
		'contentData', // Control
		'flickableData',
		'flickableChildren',
		'gradient', // Rectangle
		'_icon', // QQuickAction1

		// 'ignoreUnknownSignals', // Connections Non-NOTIFYable

		//--- anchors group
		// http://doc.qt.io/qt-5/qml-qtquick-item.html#anchors-prop
		'anchors',
		'top',
		'bottom',
		'left',
		'right',
		'horizontalCenter',
		'verticalCenter',
		'baseline',
		// 'fill',
		// 'centerIn',
		// 'margins',
		// 'topMargin',
		// 'bottomMargin',
		// 'leftMargin',
		// 'rightMargin',
		// 'horizontalCenterOffset',
		// 'verticalCenterOffset',
		'baselineOffset',
		// 'alignWhenCentered',
		'margins',
		'inset',
	]

	property var ignoredDefaults: {
		"transformOrigin": 4,
		"scale": 1,
		"opacity": 1,
		"smooth": true,
		"width": 0,
		"height": 0,
		"implicitWidth": 0,
		"implicitHeight": 0,
		"x": 0,
		"y": 0,
		"z": 0,
		"enabled": true,
		"objectName": "",
		"clip": false,
		"focus": false,
		"activeFocus": false,
		"activeFocusOnTab": false,
		"rotation": 0,
		"visible": true,
		"state": "",
		"childrenRect": Qt.rect(0,0,0,0),
		"antialiasing": false,
		"layoutDirection": 0,
		"spacing": 5,
		"ignoreUnknownSignals": false,
		"usingRenderingCache": true,
		"multipleImages": false,
	}

	function parseObj(obj) {
		var el = {
			tagId: Util.valueToString(obj),
			tagName: Util.getTagName(obj),
			depth: 0,
			expanded: false,
			attributes: [],
			attributeKeys: [],
			obj: obj,
		}
		// console.log('parseObj', el.tagName)

		if (!ignoredTags.includes(el.tagName)) {
			var keys = Util.getObjectKeys(obj)
			for (var i in keys) {
				var key = keys[i]
				var value = obj[key]
				if (Util.isChangedSignal(obj, key)) {
				} else if (typeof(value) === "function") {
				} else if (ignoredProperties.includes(key)) {
					continue
				} else if (typeof ignoredDefaults[key] !== 'undefined' && ignoredDefaults[key] == value) {
					continue
				} else {
					// if (el.attributes.length >= 5) {
					// 	continue
					// }
					el.attributes.push({
						key: key,
						value: Util.valueToString(value),
					})
				}
			}
		}
		
		return el
	}

	function parseRootObj() {
		var el = parseObj(rootObj)
		append(el)
		elementAdded(el)
		// expandObj(rootObj)
	}

	function findObj(obj) {
		// console.log("findObj", count)
		for (var i = 0; i < count; i++) {
			var el = get(i)
			// console.log("el.obj", el.obj, obj, el.obj == obj)
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
		if (parentEl.expanded) {
			return 0
		} else if (devToolsView.contains(parentEl.obj)) {
			return 0
		} else if (typeof parentEl.obj.data === "undefined") {
			return 0
		}

		var childIndex = parentIndex
		var inserted = 0
		if (parentEl.obj.data.length > 0) {
			for (var i = 0; i < parentEl.obj.data.length; i++) {
				var obj = parentEl.obj.data[i]
				var el = parseObj(obj)
				el.depth = parentEl.depth + 1
				insert(++childIndex, el)
				elementAdded(el)
				// logDepth(parentEl.depth, 'expandIndex', parentIndex, 'inserted at', childIndex)
				inserted += 1
			}
			setProperty(parentIndex, 'expanded', true)
		}
		// parentEl.obj.connect('destruction', removeElement.bind(elementsModel, parentEl.obj))
		return inserted
	}

	function collapseIndex(parentIndex) {
		console.log("collapseIndex", parentIndex, 'count', count)
		var parentEl = get(parentIndex)
		if (!parentEl.expanded) {
			return 0
		} else if (typeof parentEl.obj.data === "undefined") {
			return 0
		}

		var removed = 0
		for (var i = 0; i < parentEl.obj.data.length; i++) {
			var obj = parentEl.obj.data[i]
			var childIndex = findObj(obj)
			if (childIndex >= 0) {
				removed += collapseIndex(childIndex)
				remove(childIndex)
				// logDepth(parentEl.depth, 'collapseIndex', parentIndex, 'removed', childIndex)
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

		// logDepth(parentEl.depth, 'for', parentIndex + inserted, '..', parentIndex)
		for (var i = parentIndex + inserted; i > parentIndex; i--) {
			// logDepth(parentEl.depth, 'expandAll child', i)
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
	// 		"val": Util.valueToString(item),
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
		if (Util.isNull(target)) {
			console.log('target.isNull', target)
			return
		}
		rootObj = target
	}

	function getRootOf(target) {
		var curItem = target
		for (var i = 0; i < 1000; i++) { // Hard limit
			if (!curItem.parent) {
				break;
			}
			curItem = curItem.parent
		}
		return curItem
	}

	function setRootTarget(target) {
		if (Util.isNull(target)) {
			console.log('target.isNull', target)
			return
		}
		rootObj = getRootOf(target)
	}
}
