import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import "util.js" as Util

Rectangle {
	id: breadcrumbView

	height: 19
	color: "#fff"

	property var elementsView: null
	readonly property var hoveredObj: elementsView ? elementsView.hoveredObj : null
	readonly property var selectedObj: elementsView ? elementsView.selectedObj : null
	property var deepestChild: null

	onSelectedObjChanged: {
		deepestChild = selectedObj
		breadcrumbModel.clear()
		
		if (Util.isNull(deepestChild))
			return
		
		var curItem = deepestChild
		for (var i = 0; i < 1000; i++) { // Hard limit
			breadcrumbModel.insert(0, {
				tagId: Util.valueToString(curItem),
				tagName: Util.getTagName(curItem),
				obj: curItem,
			})

			if (!curItem.parent) {
				break;
			}
			curItem = curItem.parent
		}
	}

	Rectangle {
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		height: 1
		color: "#dfdfdf"
	}

	ListView {
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		height: 18
		orientation: ListView.Horizontal

		model: ListModel {
			id: breadcrumbModel
		}
		delegate: MouseArea {
			property int padding: 8
			width: padding + label.width + padding
			height: label.height

			hoverEnabled: true

			onContainsMouseChanged: {
				if (containsMouse) {
					elementsView.hoveredObj = model.obj
				} else if (hoveredObj == model.obj) {
					elementsView.hoveredObj = null
				}
			}

			onClicked: {
				elementsView.setSelectedObj(model.obj)
			}

			Rectangle {
				anchors.fill: parent
				color: {
					if (model.obj == selectedObj) {
						return "#3879d9"
					} else if (model.obj == hoveredObj) {
						return "#dfdfdf"
					} else {
						return "#fff"
					}
				}
			}

			Text {
				id: label
				anchors.centerIn: parent
				text: model.tagName
			}
		}
	}
}
