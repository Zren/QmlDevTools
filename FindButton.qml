import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.0

Button {
	id: control
	
	implicitHeight: 20
	
	property int pixelSize: 12

	style: ButtonStyle {
		label: Item {
			implicitWidth: Math.max(18, labelText.implicitWidth)
			implicitHeight: 20
			Text {
				id: labelText
				anchors.centerIn: parent
				text: control.text
				font.pointSize: -1
				font.pixelSize: control.pixelSize
				color: control.enabled ? "#222222" : "#a0a0a0"
			}
		}
		background: Rectangle {
			anchors.fill: parent
			color: "#cecece"

			Gradient {
				id: pressedGradient
				GradientStop { position: 0.0; color: "#a7a7a7" }
				GradientStop { position: 1.0; color: "#757575" }
			}
			Gradient {
				id: enabledGradient
				GradientStop { position: 0.0; color: "#e3e3e3" }
				GradientStop { position: 1.0; color: "#cecece" }
			}
			gradient: {
				if (control.enabled) {
					if (control.pressed) {
						return pressedGradient
					} else {
						return enabledGradient
					}
				} else {
					return null
				}
			}

			Rectangle {
				anchors.left: parent.left
				anchors.top: parent.top
				anchors.right: parent.right
				height: 1
				color: "#a3a3a3"
			}
			Rectangle {
				anchors.left: parent.left
				anchors.bottom: parent.bottom
				anchors.right: parent.right
				height: 1
				color: "#a3a3a3"
			}
		}
	}
}
