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


	}
	Timer {
		running: true
		interval: 1000
		repeat: true
		onTriggered: targetRect.testNum += 1
	}

	RowLayout {
		anchors.fill: parent

		ElementsView {
			id: elementsView
			Layout.preferredWidth: 400
			Layout.fillWidth: true
			Layout.fillHeight: true

		}

		// RootTreeView {
		// 	Layout.fillHeight: true
		// 	target: targetRect
		// }

		PropertyTreeView {
			Layout.preferredWidth: 400
			Layout.fillHeight: true
			target: elementsView.selectedObj
		}
	}

	Component.onCompleted: {
		elementsView.model.setTarget(targetRect)
		elementsView.model.expandAll()
		elementsView.focus = true
	}
}