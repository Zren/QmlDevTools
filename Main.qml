import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Window 2.1
import QtQuick.Controls 2.12

ApplicationWindow {
	id: window
	x: 0
	y: 0
	width: 1240
	height: 720
	palette.alternateBase: "#ffffff"
	palette.base: "#ffffff"
	palette.window: "#ffffff"
	palette.text: "#000000"
	palette.buttonText: "#000000"

	palette.highlight: "#d0d0d0"
	palette.highlightedText: "#3879d9"

	// qqc2-breeze-style variables
	palette.mid: "#c0c0c0" // SplitView pressed
	palette.midlight: "#e0e0e0"// SplitView hovered
	palette.button: "#f0f0f0" // SplitView normal

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

		// Loader {
		// 	sourceComponent: testDynamicComponent
		// }
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
