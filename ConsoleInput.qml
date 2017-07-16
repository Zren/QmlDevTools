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

	property var history: ['']
	property var historyIndex: 0

	onTextChanged: {
		history[historyIndex] = text
	}

	Keys.onPressed: {
		if (event.key == Qt.Key_Return) {
			if (event.modifiers == Qt.NoModifier) {
				event.accepted = true
				if (historyIndex < history.length - 1) {
					history[history.length - 1] = text
				}
				history.push('')
				historyIndex = history.length - 1
				console.log('history insert', historyIndex)
				outputView.exec(text)
				text = ''
			} else if (event.modifiers & Qt.ShiftModifier) {
				event.accepted = true
				textArea.insert(cursorPosition, '\n')
			}
		} else if (event.key == Qt.Key_Up) {
			event.accepted = true
			if (historyIndex > 0) {
				historyIndex -= 1
				text = history[historyIndex]
				cursorPosition = text.length
				console.log('history up', historyIndex)
			}
		} else if (event.key == Qt.Key_Down) {
			event.accepted = true
			if (historyIndex < history.length - 1) {
				historyIndex += 1
				text = history[historyIndex]
				cursorPosition = text.length
				console.log('history down', historyIndex)
			}
		}
	}

	frameVisible: false

	style: TextAreaStyle {
		id: style

		textMargin: 0
	}
}
