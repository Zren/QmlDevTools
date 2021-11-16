import QtQuick 2.4
import QtQuick.Controls 2.12
import QtQuick.Window 2.2

TabButton {
	id: control
	palette: window.palette
	contentItem: Text {
		color: control.checked ? control.palette.highlightedText : control.palette.text
		text: control.text
		font: control.font
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
	}
	background: Rectangle {
		color: {
			if (control.hovered) {
				return control.palette.midlight
			} else {
				return control.palette.button
			}
		}

		Rectangle {
			id: highlightLine
			anchors.top: parent.top
			height: 3 * Screen.devicePixelRatio
			color: {
				if (control.checked) {
					return control.palette.highlightedText
				} else if (control.hovered) {
					return control.palette.mid
				} else {
					return control.palette.button
				}
			}
			anchors.horizontalCenter: parent.horizontalCenter
			width: control.hovered || control.checked ? parent.width : parent.width * 0.6
			Behavior on width {
				NumberAnimation {
					duration: 100
				}
			}
		}
	}
}
