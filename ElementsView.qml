import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

ScrollingListView {
	id: elementsView
	property alias rootObj: elementsModel.rootObj
	readonly property var selectedObj: listView.currentItem ? listView.currentItem.el.obj : null
	property var hoveredObj: null

	property var indentWidth: 12
	readonly property int maxVisibleAttributes: 8

	function setSelectedObj(nextObj) {
		for (var i = 0; i < listView.count; i++) {
			var el = model.get(i)
			if (el.obj == nextObj) {
				listView.currentIndex = i
				return
			}
		}
		listView.currentIndex = -1
	}

	function setSelectedTagId(tagId) {
		for (var i = 0; i < listView.count; i++) {
			var el = model.get(i)
			if (el.tagId == tagId) {
				listView.currentIndex = i
				return
			}
		}
		listView.currentIndex = -1
	}

	// onFocusChanged: {
	// 	console.log('ScrollView.focus', focus)
	// 	if (focus) {
	// 		// listView.focus = true
	// 		listView.forceActiveFocus()
	// 	}
	// }
	
	// highlightMoveVelocity: 0
	highlightMoveDuration: 0

	model: ElementsModel {
		id: elementsModel
	}

	Keys.onLeftPressed: {
		if (currentItem.el.expanded) {
			elementsModel.collapseIndex(currentIndex)
		} else {
			listView.decrementCurrentIndex()
		}
	}
	Keys.onRightPressed: {
		if (currentItem.el.expanded) {
			listView.incrementCurrentIndex()
		} else {
			elementsModel.expandIndex(currentIndex)
		}
	}

	delegate: MouseArea {
		id: mouseArea
		width: listView.width
		height: flow.height

		property var elIndex: index
		property var el: model
		property bool selected: index == listView.currentIndex
		property bool hovered: el.obj == hoveredObj

		// Note: el.obj.resources and el.obj.data is non-NOTIFYable.
		property int numDescendents: typeof el.obj.children !== "undefined" ? el.obj.children.length : 0
		readonly property bool hasDescendents: numDescendents > 0
		Connections {
			target: el.obj
			function childrenChanged() {
				mouseArea.numDescendents = typeof el.obj.data !== "undefined" ? el.obj.data.length : 0
			}
		}
		
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
			listView.currentIndex = index
			elementsView.focus = true
		}

		Rectangle {
			anchors.fill: mouseArea
			anchors.leftMargin: 3
			anchors.rightMargin: 3
			visible: hovered
			color: "#eaf1fb"
			radius: 4
		}

		Rectangle {
			anchors.fill: mouseArea
			visible: selected
			color: "#3879d9"
		}

		MouseArea {
			id: expandButton
			anchors.left: parent.left
			anchors.leftMargin: el.depth * indentWidth

			enabled: mouseArea.hasDescendents

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

		Flow {
			id: flow
			anchors.left: expandButton.right
			anchors.leftMargin: 4
			anchors.right: parent.right

			Text {
				id: tagName
				text: '<font color="' + tagColor + '">' + el.tagName + '</font>'
			}

			Text {
				id: openTag
				text: '<font color="' + otherColor + '">&nbsp;{</font>'
			}

			Repeater {
				id: attrRepeater
				model: el.attributes
				property bool allAttrVisible: count <= elementsView.maxVisibleAttributes // || el.expanded

				// Text {
				// 	property var key: el.attributes.get(index).key
				// 	property var value: el.obj[key]

				// 	text: '&nbsp;'
				// 		+ '<font color="' + keyColor + '">' + key + '</font>'
				// 		+ '<font color="' + otherColor + '">="</font>'
				// 		+ '<font color="' + valueColor + '">' + value + '</font>'
				// 		+ '<font color="' + otherColor + '">"</font>'

				// 	Rectangle {
				// 		anchors.fill: parent
				// 		color: "transparent"
				// 		border.color: "#cec"
				// 		border.width: 1
				// 	}
				// }
				Row {
					width: childrenRect.width
					height: childrenRect.height
					visible: attrRepeater.allAttrVisible || index < elementsView.maxVisibleAttributes

					property var key: el.attributes.get(index).key
					property var value: el.attributes.get(index).value

					property bool animationsConnected: false
					property bool showUpdates: true
					onShowUpdatesChanged: {
						if (showUpdates) {
							connectAnimations()
						} else {
							disconnectAnimations()
						}
					}

					function connectAnimations() {
						if (!animationsConnected) {
							value = Qt.binding(function() { return el.obj[key] })
							valueChanged.connect(valueChangedAnimation.start)
							animationsConnected = true
						}
					}
					function disconnectAnimations() {
						if (animationsConnected) {
							valueChanged.disconnect(valueChangedAnimation.start)
							if (el && el.attributes) { // Destroyed
								value = Qt.binding(function() { return el.attributes.get(index).value })
							}
							animationsConnected = false
						}
					}


					Component.onCompleted: {
						connectAnimations()
					}
					Component.onDestruction: {
						// console.log('element onDestruction', index)
						disconnectAnimations()
					}

					Text {
						text: '&nbsp;'
							+ '<font color="' + keyColor + '">' + key + '</font>'
							+ '<font color="' + otherColor + '">="</font>'
					}
					Rectangle {
						id: valueRect
						width: valueText.width
						height: valueText.height
						color: "transparent"
						radius: 4

						Text {
							id: valueText
							text: '' + value
							color: valueColor
						}

						SequentialAnimation {
							id: valueChangedAnimation
							// running: false
							ParallelAnimation {
								ColorAnimation { target: valueRect; property: "color"; to: "#a0439a"; duration: 100 }
								ColorAnimation { target: valueText; property: "color"; to: "#fff"; duration: 100 }
							}
							ParallelAnimation {
								ColorAnimation { target: valueRect; property: "color"; to: "transparent"; duration: 600 }
								ColorAnimation { target: valueText; property: "color"; to: valueColor; duration: 600 }
							}
							ScriptAction {
								script: {
									valueText.color = Qt.binding(function(){ return valueColor })
								}
							}
						}
					}
					Text {
						text: '<font color="' + otherColor + '">"</font>'
					}
				}
			}

			Text {
				id: truncatedIndicator
				visible: !attrRepeater.allAttrVisible
				text: '<font color="' + otherColor + '">&nbsp;...&nbsp;</font>'
			}

			Text {
				id: endTag
				text: '<font color="' + otherColor + '">&nbsp;}</font>'
			}
		}
	}

}
