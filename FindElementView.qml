import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.0

import org.kde.plasma.core 2.0 as PlasmaCore

import "util.js" as Util

Rectangle {
	id: findElementView

	height: column.height
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
			elementsView.focus = true
		}
	}

	onQueryChanged: {
		if (query) {
			selectMatch(1)
		} else {
			currentMatch = 0
			totalMatches = 0
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

	ColumnLayout {
		id: column
		anchors.left: parent.left
		anchors.right: parent.right
		spacing: 0
		
		Rectangle {
			Layout.fillWidth: true
			height: 1
			color: "#dfdfdf"
		}

		Item {
			height: 1
		}

		RowLayout {
			id: row
			Layout.fillWidth: true
			spacing: 0

			Rectangle {
				width: 1
				height: 18
				color: "#a3a3a3"
			}

			TextField {
				id: textField
				placeholderText: 'Search by element type'
				Layout.fillWidth: true
				implicitHeight: 20

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

				Keys.onEscapePressed: findElementView.visible = false

				style: TextFieldStyle {
					font.pointSize: -1
					font.pixelSize: 13

					padding.bottom: 0
					background: Rectangle {
						width: parent.width
						height: 20
						color: "#ffffff"
						Rectangle {
							anchors.left: parent.left
							anchors.top: parent.top
							anchors.right: parent.right
							height: 1
							color: "#a3a3a3"
						}
						Rectangle {
							anchors.left: parent.left
							anchors.bottom: parent.bottom
							anchors.right: parent.right
							height: 1
							color: "#a3a3a3"
						}
					}
				}
			}

			Rectangle {
				width: 1
				height: 20
				color: "#c6c6c6"
				Rectangle {
					anchors.left: parent.left
					anchors.top: parent.top
					anchors.right: parent.right
					height: 1
					color: "#a3a3a3"
				}
				Rectangle {
					anchors.left: parent.left
					anchors.bottom: parent.bottom
					anchors.right: parent.right
					height: 1
					color: "#a3a3a3"
				}
			}

			FindButton {
				text: "⬆"
				enabled: totalMatches > 0
				pixelSize: 18
				onClicked: prevMatch()
			}

			Rectangle {
				width: 1
				height: 20
				color: "#d8d8d8"
				Rectangle {
					anchors.left: parent.left
					anchors.top: parent.top
					anchors.right: parent.right
					height: 1
					color: "#a3a3a3"
				}
				Rectangle {
					anchors.left: parent.left
					anchors.bottom: parent.bottom
					anchors.right: parent.right
					height: 1
					color: "#a3a3a3"
				}
			}

			FindButton {
				text: "⬇"
				enabled: totalMatches > 0
				pixelSize: 18
				onClicked: nextMatch()
			}

			Rectangle {
				width: 1
				height: 18
				color: "#a3a3a3"
			}

			Item {
				width: 11
			}

			Rectangle {
				width: 1
				height: 18
				color: "#a3a3a3"
			}

			FindButton {
				text: "Cancel"
				onClicked: findElementView.visible = false
			}

			Rectangle {
				width: 1
				height: 18
				color: "#a3a3a3"
			}

			Item {
				width: 5
			}
		}

		Item {
			height: 1
		}
	}
}

