import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

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

			Column {
				width: scrollView.viewport ? scrollView.viewport.width : scrollView.width
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
						anchors.top: parent.top
						anchors.topMargin: 3
						Layout.preferredWidth: 20
						height: 12

						SvgIcon {
							anchors.fill: parent
							iconSize: 16
							path: 'm12 8l-6.251-6-.749.719 4.298 4.125 1.237 1.156-1.237 1.156-4.298 4.125.749.719 4.298-4.125z'
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
