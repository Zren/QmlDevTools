import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

TextArea {
	id: textArea
	Layout.fillWidth: true
	// Layout.preferredHeight: Math.max(4 + 5 + font.pixelSize + 5 + 4, 1 + contentHeight + 1)
	// Layout.preferredHeight: Math.max(4 + 5 + font.pixelSize + 5 + 4, 1 + contentHeight + 1)
	Layout.preferredHeight: contentHeight
	// font.pixelSize: 12

	Keys.onPressed: {
		if (event.key == Qt.Key_Return) {
			if (event.modifiers == Qt.NoModifier) {
				event.accepted = true
				outputView.exec(text)
				text = ''
			} else if (event.modifiers & Qt.ShiftModifier) {
				event.accepted = true
				textArea.insert(cursorPosition, '\n')
			}
		}
	}

	frameVisible: false

	style: TextAreaStyle {
		id: style

		textMargin: 0
		
		frame: Item {
			Rectangle {
				anchors.left: parent.left
				anchors.top: parent.top
				anchors.right: parent.right
				height: 1
				color: "#f0f0f0"
			}

		}
	}
}
