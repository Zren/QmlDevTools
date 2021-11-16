import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2 as QtQuickControls2
import QtQuick.Controls.Styles 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

import "SvgIconPaths.js" as SvgIconPaths

FocusScope {
	id: dockView

	ColumnLayout {
		id: column
		anchors.fill: parent
		spacing: 0

		Rectangle {
			Layout.fillWidth: true
			Layout.preferredHeight: 1
			color: "#a3a3a3"
		}

		Rectangle {
			Layout.fillWidth: true
			Layout.preferredHeight: 26
			color: "#f3f3f3"

			RowLayout {
				anchors.fill: parent
				spacing: 0

				MouseArea {
					id: clearLogButton
					Layout.fillHeight: true
					Layout.preferredWidth: 40
					hoverEnabled: true

					SvgIcon {
						width: 20
						height: 20
						anchors.centerIn: parent
						iconSize: 16
						path: SvgIconPaths.cancel
						fillColor: clearLogButton.containsMouse && !clearLogButton.pressed ? '#333333' : '#6e6e6e'
					}

					onClicked: outputView.model.clear()

					QtQuickControls2.ToolTip.visible: clearLogButton.containsMouse && !clearLogButton.pressed
					QtQuickControls2.ToolTip.text: 'Clear console <font color="#666">Ctrl+L</font>'
				}
			}
		}

		Rectangle {
			Layout.fillWidth: true
			Layout.preferredHeight: 1
			color: "#cccccc"
		}

		ScrollView {
			id: scrollView
			Layout.fillWidth: true
			Layout.fillHeight: true

			property int flickableHeight: flickableItem.contentHeight
			onFlickableHeightChanged: {
				console.log('flickableHeight', flickableHeight)
				positionViewAtEnd()
			}
			function positionViewAtEnd() {
				flickableItem.contentY = flickableItem.contentHeight - Math.min(flickableItem.contentHeight, viewport.height)
				// flickableItem.returnToBounds()
			}

			property int viewportWidth: viewport ? viewport.width : width

			Column {
				width: scrollView.viewportWidth
				height: childrenRect.height

				OutputView {
					id: outputView
					width: parent.width
					height: contentHeight
				}
				RowLayout {
					width: parent.width
					spacing: 0

					Item {
						Layout.alignment: Qt.AlignTop
						Layout.topMargin: 3
						Layout.preferredWidth: 20
						height: 12

						SvgIcon {
							anchors.fill: parent
							iconSize: 16
							path: SvgIconPaths.arrowRight
							fillColor: '#3a7ff1'
						}
					}
					ConsoleInput {
						id: textArea
						Layout.fillWidth: true
					}
				}
			}
		}
	}
}
