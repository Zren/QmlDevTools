import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.0 as QQC1
import QtQuick.Controls 2.13 // SplitView requires Qt 5.13
import QtQuick.Window 2.0

import "util.js" as Util

FocusScope {
	id: devToolsView

	clip: true
	focus: true

	property bool ready: false
	Connections {
		target: elementsModel
		onUpdated: devToolsView.ready = true
	}

	Keys.onPressed: {
		if (event.matches(StandardKey.Find)) {
			event.accepted = true
			findElementView.visible = true
		}
	}

	property alias elementsView: elementsView
	property alias elementsListView: elementsView.listView
	property alias elementsModel: elementsView.model

	Rectangle {
		anchors.fill: parent
		color: "#fff"
	}

	SplitView {
		anchors.fill: parent
		orientation: Qt.Vertical

		SplitView {
			SplitView.fillWidth: true
			SplitView.fillHeight: true

			ColumnLayout {
				SplitView.fillWidth: true
				SplitView.fillHeight: true
				spacing: 0

				ElementsView {
					id: elementsView
					Layout.fillWidth: true
					Layout.fillHeight: true
				}

				BreadcrumbView {
					id: breadcrumbView
					Layout.fillWidth: true
					elementsView: elementsView
				}

				FindElementView {
					id: findElementView
					visible: false
					Layout.fillWidth: true
					elementsView: elementsView
				}
			}

			ColumnLayout {
				SplitView.preferredWidth: devToolsView.width * 0.3
				SplitView.fillHeight: true
				spacing: 0

				TabBar {
					id: sidebarTabBar
					Layout.fillWidth: true
					background: Rectangle {
						color: palette.button
					}

					SidebarTabButton {
						text: "Properties"
						// palette: window.palette
					}
					SidebarTabButton {
						text: "Plasma"
						// palette: window.palette
					}
				}

				StackLayout {
					Layout.fillWidth: true
					currentIndex: sidebarTabBar.currentIndex

					PropertyTreeView {
						id: propertyTreeView
						target: elementsView.selectedObj
					}

					PlasmaShortcutsView {
						id: plasmaShortcutsView
						elementsView: devToolsView.elementsView
					}
				}
			}
		}

		DockView {
			id: dockView
			SplitView.fillWidth: true
			SplitView.preferredHeight: 200 * Screen.devicePixelRatio
		}
	}

	function isDescendant(obj) {
		return Util.isDescendantOf(obj, devToolsView)
	}

	function contains(obj) {
		return obj == devToolsView || isDescendant(obj)
	}
}
