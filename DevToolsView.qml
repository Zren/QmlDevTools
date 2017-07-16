import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1

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

	ColumnLayout {
		anchors.fill: parent
		spacing: 0

		RowLayout {
			spacing: 0

			ColumnLayout {
				Layout.fillWidth: true
				Layout.fillHeight: true
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

			TabView {
				Layout.preferredWidth: devToolsView.width * 0.3
				Layout.fillHeight: true

				Tab {
					title: "Plasma"
					PlasmaShortcutsView {
						id: plasmaShortcutsView
						elementsView: devToolsView.elementsView
					}
				}
				
				Tab {
					title: "Properties"

					PropertyTreeView {
						id: propertyTreeView
						target: elementsView.selectedObj
					}
				}

				style: TabViewStyle {}
			}
		}

		DockView {
			id: dockView
			Layout.fillWidth: true
			Layout.preferredHeight: devToolsView.height * 0.3
		}
	}

	function isDescendantOf(obj, parentObj) {
		var curItem = obj
		// while (curItem.parent) {
		for (var i = 0; i < 1000; i++) { // Hard limit
			if (!curItem.parent) {
				return false
			} else if (curItem.parent == parentObj) {
				return true
			}
		}
		return false // Reached hard limit
	}

	function isDescendant(obj) {
		return isDescendantOf(obj, devToolsView)
	}

	function contains(obj) {
		return obj == devToolsView || isDescendant(obj)
	}
}
