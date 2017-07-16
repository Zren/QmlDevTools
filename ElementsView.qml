import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

ListView {
	id: elementsView

	boundsBehavior: Flickable.StopAtBounds
	// highlightMoveVelocity: 0
	highlightMoveDuration: 0

	property var indentWidth: 12

	property alias elementsModel: elementsModel
	property alias rootObj: elementsModel.rootObj
	readonly property var selectedObj: currentItem ? currentItem.el.obj : null
	property var hoveredObj: null

	function setSelectedObj(nextObj) {
		for (var i = 0; i < count; i++) {
			var el = model.get(i)
			if (el.obj == nextObj) {
				currentIndex = i
				return
			}
		}
		currentIndex = -1
	}

	model: ElementsModel {
		id: elementsModel
	}

	Keys.onLeftPressed: {
		if (currentItem.el.expanded) {
			elementsModel.collapseIndex(currentIndex)
		} else {
			decrementCurrentIndex()
		}
	}
	Keys.onRightPressed: {
		if (currentItem.el.expanded) {
			incrementCurrentIndex()
		} else {
			elementsModel.expandIndex(currentIndex)
		}
		
	}

	delegate: MouseArea {
		width: flow.width
		height: flow.height

		property var elIndex: index
		property var el: model
		property bool selected: index == currentIndex
		property bool hovered: el.obj == hoveredObj

		property string expandoColor: selected ? "#fff" : "#6e6e6e"
		property string tagColor: selected ? "#fff" : "#a0439a"
		property string keyColor: selected ? "#a1b3cf" : "#9a6127"
		property string valueColor: selected ? "#fff" : "#3879d9"
		property string otherColor: selected ? "#a1b3cf" : "#a1b3cf"

		hoverEnabled: true

		onContainsMouseChanged: {
			if (containsMouse) {
				elementsView.hoveredObj = el.obj
			} else if (hoveredObj == el.obj) {
				elementsView.hoveredObj = null
			}
		}

		onClicked: select()

		function select() {
			// elementsModel.selectedObj = el.obj
			currentIndex = index
			// focus = true
		}

		Rectangle {
			anchors.fill: flow
			anchors.leftMargin: 3
			anchors.rightMargin: 3
			visible: hovered
			color: "#eaf1fb"
			radius: 4
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
			leftPadding: el.depth * indentWidth
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
					color: expandoColor
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
