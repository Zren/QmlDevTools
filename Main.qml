import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Window 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.0
import QtMultimedia 5.6
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Window {
	id: window
	x: 0
	y: 0
	width: 1240
	height: 720

	// MouseArea {
	// 	anchors.fill: parent
	// 	acceptedButtons: Qt.LeftButton
	// 	onClicked: Qt.quit(0)
	// }

	Rectangle {
		id: targetRect

		property int testNum: 0

		function testFn() {}

		Timer {
			running: true
			interval: 1000
			repeat: true
			onTriggered: targetRect.testNum += 1
		}
	}

	Item {
		objectName: "testObj"

		Item {
			Item {
				
			}
		}
		Item {

		}

		Component {
			id: testDynamicComponent
			Item {
				id: testDynamic
				Timer {
					running: true
					interval: 4000
					repeat: true
					onTriggered: Qt.createQmlObject('import QtQuick 2.0; Item {}', testDynamic) // Test Linear
					// onTriggered: testDynamicComponent.createObject(testDynamic) // Test Exponential
				}
			}
		}

		Loader {
			sourceComponent: testDynamicComponent
		}
	}

	DevToolsView {
		id: devToolsView
		anchors.fill: parent
	}

	Component.onCompleted: {
		devToolsView.elementsModel.setTarget(targetRect)
		devToolsView.elementsModel.expandAll()
		devToolsView.elementsView.focus = true
	}
}
