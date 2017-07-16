import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

Item {
	id: devToolsView

	property alias elementsView: elementsView
	property alias elementsModel: elementsView.model
	property alias propertyTreeView: propertyTreeView

	Rectangle {
		anchors.fill: parent
		color: "#fff"
	}

	RowLayout {
		anchors.fill: parent
		spacing: 0

		ColumnLayout {
			Layout.fillWidth: true
			Layout.fillHeight: true
			spacing: 0

			ElementsView {
				id: elementsView
				Layout.fillWidth: true
				Layout.fillHeight: true
			}

			BreadcrumbView {
				id: breadcrumbView
				Layout.fillWidth: true
				selectedObj: elementsView.selectedObj
			}
		}
		

		// RootTreeView {
		// 	Layout.fillHeight: true
		// 	target: targetRect
		// }

		PropertyTreeView {
			id: propertyTreeView
			Layout.preferredWidth: devToolsView.width * 0.3
			Layout.fillHeight: true
			target: elementsView.selectedObj
		}
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

	function contains(obj) {
		return obj == devToolsView || isDescendant(obj)
	}
}
