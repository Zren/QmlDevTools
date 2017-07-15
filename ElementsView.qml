import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

ListView {
	id: treeView

	property alias rootObj: elementsModel.rootObj
	property alias selectedObj: elementsModel.selectedObj

	model: ElementsModel {
		id: elementsModel
	}

	delegate: MouseArea {
		width: flow.width
		height: flow.height

		property var elIndex: index
		property var el: model

		property string keyColor: el.selected ? "#a1b3cf" : "#9a6127"
		property string valueColor: el.selected ? "#fff" : "#3879d9"
		property string otherColor: el.selected ? "#a1b3cf" : "#a1b3cf"

		onClicked: elementsModel.selectedObj = el.obj

		Rectangle {
			anchors.fill: flow
			visible: model.selected
			color: "#3879d9"
		}

		Flow {
			id: flow
			anchors.left: parent.left
			// anchors.leftMargin: el.depth * 36
			// anchors.right: parent.right
			leftPadding: el.depth * 36
			width: treeView.width

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
				text: '<font color="' + valueColor + '">' + el.tagName + '</font>'
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
				text: '<font color="' + otherColor + '">&gt;"</font>'
			}
		}
	}

}
