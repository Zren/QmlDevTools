import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import "util.js" as Util

Item {
	id: breadcrumbView

	implicitHeight: 40

	property var selectedObj: null
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
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.right: parent.right
		height: 1
		color: "#dfdfdf"
	}

	ListView {
		anchors.fill: parent

		model: ListModel {
			id: breadcrumbModel
		}
		delegate: Item {
			width: label.width
			height: label.height

			MouseArea {
				anchors.fill: parent
			}

			Rectangle {
				color: "#fff"
			}

			Text {
				id: label
				text: model.tagName
			}
		}
	}
}
