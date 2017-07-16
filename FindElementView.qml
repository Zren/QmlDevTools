import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import "util.js" as Util

Rectangle {
	id: findElementView

	height: 1 + row.height
	color: "#eeeeee"

	property var elementsView: null

	Rectangle {
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		height: 1
		color: "#dfdfdf"
	}

	RowLayout {
		id: row
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		// height: 18

		TextField {
			id: textField
			placeholderText: 'Search by element type'
			Layout.fillWidth: true
			Layout.fillHeight: true

			onTextChanged: {
				var lowerText = text.toLowerCase()
				for (var i = 0; i < elementsView.elementsModel.count; i++) {
					var el = elementsView.elementsModel.get(i)
					var lowerTag = el.tagName.toLowerCase()
					if (lowerTag.indexOf(lowerText) >= 0) {
						elementsView.currentIndex = i
						break
					}
				}
			}
		}
	}
}

