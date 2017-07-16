import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

ListView {
	id: elementsView

	boundsBehavior: Flickable.StopAtBounds
	// highlightMoveVelocity: 0
	highlightMoveDuration: 0

	property alias rootObj: elementsModel.rootObj
	readonly property var selectedObj: currentItem ? currentItem.el.obj : null

	model: ElementsModel {
		id: elementsModel
	}

	Keys.onLeftPressed: {
		elementsModel.collapseIndex(currentIndex)
	}
	Keys.onRightPressed: {
		elementsModel.expandIndex(currentIndex)
	}

	delegate: MouseArea {
		width: flow.width
		height: flow.height

		property var elIndex: index
		property var el: model
		property bool selected: index == currentIndex

		property string tagColor: selected ? "#fff" : "#a0439a"
		property string keyColor: selected ? "#a1b3cf" : "#9a6127"
		property string valueColor: selected ? "#fff" : "#3879d9"
		property string otherColor: selected ? "#a1b3cf" : "#a1b3cf"

		onClicked: select()

		function select() {
			// elementsModel.selectedObj = el.obj
			currentIndex = index
			// focus = true
		}


		Rectangle {
			anchors.fill: flow
			visible: selected
			color: "#3879d9"
		}

		Flow {
			id: flow
			anchors.left: parent.left
			// anchors.leftMargin: el.depth * 36
			// anchors.right: parent.right
			leftPadding: el.depth * 36
			width: elementsView.width

			MouseArea {
				id: expandButton

				enabled: el.obj.children.length > 0

				width: expandText.width
				height: expandText.height

				onClicked: elementsModel.toggleIndex(elIndex)

				Text {
					id: expandText
					visible: parent.enabled
					// text: (el.expanded ? '▼' : '▶') + ' '
					// text: '▶'
					// rotation: el.expanded ? 90 : 0
					text: '▼'
					rotation: el.expanded ? 0 : -90
				}
			}

			Text {
				id: openTag
				text: '<font color="' + otherColor + '">&lt;</font>'
			}

			Text {
				id: tagName
				text: '<font color="' + tagColor + '">' + el.tagName + '</font>'
			}

			Repeater {
				id: repeater
				model: el.attributes

				Text {
					property var key: el.attributes.get(index).key
					property var value: el.attributes.get(index).value

					text: '&nbsp;'
						+ '<font color="' + keyColor + '">' + key + '</font>'
						+ '<font color="' + otherColor + '">="</font>'
						+ '<font color="' + valueColor + '">' + value + '</font>'
						+ '<font color="' + otherColor + '">"</font>'

				}
			}

			Text {
				id: endTag
				text: '<font color="' + otherColor + '">&gt;</font>'
			}
		}
	}

}
