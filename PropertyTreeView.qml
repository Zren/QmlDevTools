import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.9

import "util.js" as Util

ScrollView {
	property alias target: targetModel.target
	ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

ListView {
	id: propertyTreeView
	delegate: Flow {
		width: ListView.view.width
		property string expandoColor: "#6e6e6e"
		property string tagColor: "#a0439a"
		property string keyColor: "#9a6127"
		property string valueColor: "#3879d9"
		property string otherColor: "#a1b3cf"
		property string funcColor: otherColor

		readonly property bool isFunction: model.type === 'function'

		Text {
			text: '&nbsp;'
				+ '<font color="' + (isFunction ? funcColor : keyColor) + '">' + model.name + '</font>'
				+ (isFunction
					? '<font color="' + funcColor + '">()</font>'
					: '<font color="' + otherColor + '">:&nbsp;</font>'
				)
			wrapMode: Text.Wrap
		}
		Text {
			id: valueText
			visible: !isFunction
			text: '' + model.val
			color: valueColor
			wrapMode: Text.Wrap
		}
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
			var keys = Util.getObjectKeys(target)
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
			if (devToolsView.isDescendant(target)) {
				console.log('isDescendant of devToolsView, skipping bindings')
				return
			}
			var keys = Util.getObjectKeys(target)
			for (var i in keys) {
				var key = keys[i]
				if (Util.isChangedSignal(target, key)) {
					// console.log('bindAllSignals isChangedSignal', target, key, target[key])
					try {
						if (typeof propListeners[key] === "function") {
							console.log('propListeners[key]', key, 'was not deleted and is probably still connected')
							target[key].disconnect(propListeners[key])
							delete propListeners[key]
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
			var keys = Util.getObjectKeys(lastTarget)
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
			var keys = Util.getObjectKeys(target)
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

	} // ListView
}
