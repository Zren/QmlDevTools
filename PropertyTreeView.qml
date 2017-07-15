import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

TreeView {
	id: treeView

	property alias target: targetModel.target

	TableViewColumn {
		title: "Name"
		role: "name"
		width: 180
	}

	// TableViewColumn {
	// 	title: "Type"
	// 	role: "type"
	// 	width: 100
	// }
	TableViewColumn {
		title: "Value"
		role: "val"
		width: 180
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
		function appendProperty(key) {
			var value = target[key]
			var valueType = typeof(value)
			var valueString = valueToString(value)
			append({
				"name": key,
				"type": valueType,
				"val": valueString,
			})
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

		function isSignal(key, value) {
			return typeof(value) === "function" && endsWith(key, 'Changed')
		}
		function bindAllSignals() {
			if (isNull(target)) {
				return
			}
			var keys = Object.keys(target)
			for (var i in keys) {
				var key = keys[i]
				var value = lastTarget[key]
				if (isSignal(key, value)) {
					value.connect(update)
				}
			}
		}
		function unbindAllSignals() {
			if (isNull(lastTarget)) {
				return
			}
			var keys = Object.keys(lastTarget)
			for (var i in keys) {
				var key = keys[i]
				var value = lastTarget[key]
				if (isSignal(key, value)) {
					value.disconnect(update)
				}
			}
		}

		function update() {
			if (target === lastTarget) {
				updateAllProperties()
			} else {
				unbindAllSignals()
				clear()
				lastTarget = target
				parseTarget()
				bindAllSignals()
			}
		}

		function parseTarget() {
			if (isNull(target)) {
				console.log('targetIsNull', target)
				return
			}
			var keys = Object.keys(target)
			keys.sort()
			for (var i in keys) {
				var key = keys[i]
				var value = target[key]
				if (isSignal(key, value)) {
					// skip
				} else {
					appendProperty(key)
				}
			}
		}
	} // ListModel

}
