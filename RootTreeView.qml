import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

TreeView {
	id: treeView

	property alias target: targetModel.target

	TableViewColumn {
		title: "Value"
		role: "val"
	}

	model: ListModel {
		id: targetModel

		property var lastTarget: null
		property var target: null

		onTargetChanged: update()
		
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
		function appendItem(item) {
			var valueString = valueToString(item)
			append({
				"val": valueString,
			})
		}

		function isSignal(key, value) {
			return typeof(value) === "function" && endsWith(key, 'Changed')
		}

		function update() {
			if (target === lastTarget) {
				
			} else {
				clear()
				lastTarget = target
				parseTarget()
			}
		}

		function getTreeItem(item) {
			return {
				"val": valueToString(item),
				"contents": [],
			}
		}

		function unpackParent(item, tree) {
			if (item.parent) {
				var parentTree = getTreeItem(item.parent)
				parentTree.contents.push(tree)
				return parentTree
			} else {
				return tree
			}
		}

		function parseTarget() {
			if (isNull(target)) {
				console.log('targetIsNull', target)
				return
			}

			var curItem = target
			appendItem(curItem)
			var tree = getTreeItem(curItem)

			// while (rootItem.parent) {
			for (var i = 0; i < 1000; i++) { // Hard limit
				if (!curItem.parent) {
					break;
				}
				tree = unpackParent(curItem, tree)
				curItem = curItem.parent
				appendItem(curItem)
			}

			var rootItem = curItem
			append(tree)



		}
	} // ListModel

}
