import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import "util.js" as Util

TreeView {
	id: propertyTreeView

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
		property var propMapping: { return {} }
		property var propListeners: { return {} }

		onTargetChanged: update()
		
		function appendProperty(key) {
			var value = target[key]
			var valueType = typeof(value)
			var valueString = Util.valueToString(value)
			append({
				"name": key,
				"type": valueType,
				"val": valueString,
			})
		}
		function getIndexByKey(key) {
			var i = propMapping[key]
			if (typeof i === "undefined") {
				for (var i = 0; i < count; i++) {
					var row = get(i)
					if (row.name == key) {
						propMapping[key] = i
						return i
					}
				}
			} else {
				return i
			}
		}
		function updateProperty(key) {
			console.log('propTree.updateProperty', key)
			var i = getIndexByKey(key)
			var row = get(i)
			var value = target[key]
			var valueString = Util.valueToString(value)
			if (row.val !== valueString) {
				console.log(i, key, row.val, valueString)
				setProperty(i, "val", valueString)
			}
		}
		function updateAllProperties() {
			if (Util.isNull(target)) {
				return
			}
			var keys = Object.keys(target)
			for (var i in keys) {
				var key = keys[i]
				updateProperty(key)
			}
		}

		function bindAllSignals() {
			if (Util.isNull(target)) {
				return
			}
			if (devToolsView.isDescendant(target)) {
				console.log('isDescendant of devToolsView, skipping bindings')
				return
			}
			var keys = Object.keys(target)
			for (var i in keys) {
				var key = keys[i]
				if (Util.isChangedSignal(target, key)) {
					// console.log('bindAllSignals isChangedSignal', target, key, target[key])
					try {
						if (typeof propListeners[key] === "function") {
							console.log('propListeners[key]', key, 'was not deleted and is probably still connected')
						}
						var propKey = key.substr(0, key.length - 'Changed'.length)
						propListeners[key] = updateProperty.bind(targetModel, propKey)
						target[key].connect(propListeners[key])
					} catch (e) {
						console.log('err', e)
						console.log('bindAllSignals isChangedSignal', target, key, target[key])

					}
				}
			}
		}
		function unbindAllSignals() {
			if (Util.isNull(lastTarget)) {
				return
			}
			var keys = Object.keys(lastTarget)
			for (var i in keys) {
				var key = keys[i]
				if (Util.isChangedSignal(lastTarget, key)) {
					try {
						lastTarget[key].disconnect(propListeners[key])
						delete propListeners[key]
					} catch (e) {
						console.log('err', e)
						console.log('unbindAllSignals isChangedSignal', lastTarget, key, lastTarget[key])
					}
				}
			}
		}

		function update() {
			if (target === lastTarget) {
				updateAllProperties()
			} else {
				unbindAllSignals()
				clear()
				propMapping = {}
				propListeners = {}
				lastTarget = target
				parseTarget()
				bindAllSignals()
			}
		}

		function parseTarget() {
			if (Util.isNull(target)) {
				console.log('targetIsNull', target)
				return
			}
			var keys = Object.keys(target)
			keys.sort()
			for (var i in keys) {
				var key = keys[i]
				if (Util.isChangedSignal(target, key)) {
					// skip
				} else {
					appendProperty(key)
				}
			}
		}
	} // ListModel

}
