import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

import "util.js" as Util

ScrollView {
	id: plasmaShortcutsView

	property var elementsView
	property var elementsModel: elementsView.model
	property var rootObj: elementsModel.rootObj
	onRootObjChanged: {
		checkAll()
	}

	function checkAll() {
		panelsModel.clear()
		checkObj(rootObj)
	}

	function checkObj(obj) {
		var tagId = Util.valueToString(obj)
		var tagName = Util.getTagName(obj)
		if (tagName == 'Panel') {
			addToList(panelsModel, tagId, tagName, 'Panel')
			// for (var i = ) 
		} else if (tagName == 'AppletInterface') {
			addToList(appletsModel, tagId, tagName, obj.pluginName)
		}
		checkChildren(obj)
	}

	function checkChildren(obj) {
		if (typeof obj.children === "undefined") {
			return;
		}
		for (var i = 0; i < obj.children.length; i++) {
			var child = obj.children[i]
			checkObj(child)
		}
	}

	function addToList(list, tagId, tagName, label) {
		list.append({
			tagId: tagId,
			tagName: tagName,
			label: label,
		})
	}

	ColumnLayout {
		Connections {
			target: elementsModel
			onElementAdded: console.log('shortcuts.added', element.tagId)
			onUpdated: console.log('shortcuts.updated')
		}

		Text {
			text: 'Panels'
		}
		Repeater {
			model: ListModel { id: panelsModel }

			Button {
				text: model.label
				onClicked: elementsView.setSelectedTagId(model.tagId)
			}
		}

		Text {
			text: 'Applets'
		}
		Repeater {
			model: ListModel { id: appletsModel }

			Button {
				text: model.label
				onClicked: elementsView.setSelectedTagId(model.tagId)
			}
		}
	}
}
