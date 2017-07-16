import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import "util.js" as Util

Rectangle {
	id: findElementView

	height: 1 + row.height
	color: "#eeeeee"

	property var elementsView: null
	property int totalMatches: 0
	property int currentMatch: 0
	property alias query: textField.text

	onVisibleChanged: {
		if (visible) {
			textField.focus = true
		} else {
			query = ''
		}
	}

	function selectMatch(m) { // starts at 1
		var n = 0
		var mIndex = -1
		var lowerQuery = query.toLowerCase()
		for (var i = 0; i < elementsView.elementsModel.count; i++) {
			var el = elementsView.elementsModel.get(i)
			var lowerTag = el.tagName.toLowerCase()
			if (lowerTag.indexOf(lowerQuery) >= 0) {
				n += 1
				if (m == n) {
					mIndex = i
				}
			}
		}

		if (mIndex >= 0) {
			elementsView.currentIndex = mIndex
			currentMatch = m
		} else {
			elementsView.currentIndex = -1
			currentMatch = 0
		}
		totalMatches = n
	}

	function deltaMatch(delta) {
		var m = (((currentMatch + delta) - 1) % totalMatches) + 1 // increment, make 0 first index, modulo, make 1 first index
		selectMatch(m)
	}

	function nextMatch() {
		deltaMatch(1)
	}

	function prevMatch() {
		deltaMatch(-1)
	}

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
				selectMatch(1)
			}

			onAccepted: {
				nextMatch()
			}

			Text {
				anchors.verticalCenter: parent.verticalCenter
				anchors.right: parent.right
				anchors.rightMargin: units.smallSpacing
				color: "#888"
				visible: query
				text: "" + currentMatch + " of " + totalMatches
			}
		}

		Button {
			iconName: "arrow-up"
			onClicked: prevMatch()
		}

		Button {
			iconName: "arrow-down"
			onClicked: nextMatch()
		}


		Button {
			text: "Cancel"
			onClicked: findElementView.visible = false
		}
	}
}

