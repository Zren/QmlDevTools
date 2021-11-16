import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Window 2.1
import QtQuick.Controls 2.12

DevToolsWindow {
	id: window

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
	}

	Component.onCompleted: {
		// setRootTarget(targetRect)
		setTarget(targetRect)
	}
}
