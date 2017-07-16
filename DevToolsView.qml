import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

RowLayout {
	id: devToolsView
	anchors.fill: parent

	property alias elementsView: elementsView
	property alias elementsModel: elementsView.model
	property alias propertyTreeView: propertyTreeView

	ElementsView {
		id: elementsView
		Layout.preferredWidth: 400
		Layout.fillWidth: true
		Layout.fillHeight: true

	}

	// RootTreeView {
	// 	Layout.fillHeight: true
	// 	target: targetRect
	// }

	PropertyTreeView {
		id: propertyTreeView
		Layout.preferredWidth: 400
		Layout.fillHeight: true
		target: elementsView.selectedObj
	}



	function isDescendantOf(obj, parentObj) {
		var curItem = obj
		// while (curItem.parent) {
		for (var i = 0; i < 1000; i++) { // Hard limit
			if (!curItem.parent) {
				return false
			} else if (curItem.parent == parentObj) {
				return true
			}
		}
		return false // Reached hard limit
	}

	function isDescendant(obj) {
		return isDescendantOf(obj, devToolsView)
	}
}
