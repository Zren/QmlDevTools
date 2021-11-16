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

	property alias devToolsView: devToolsView
	DevToolsView {
		id: devToolsView
		anchors.fill: parent
	}

	function setTarget(targetRect) {
		devToolsView.elementsModel.setTarget(targetRect)
		devToolsView.elementsModel.expandAll()
		devToolsView.elementsView.focus = true
	}
}
