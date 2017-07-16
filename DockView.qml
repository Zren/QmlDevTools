import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

FocusScope {
	id: dockView

	ColumnLayout {
		id: column
		anchors.fill: parent
		spacing: 0

		Rectangle {
			Layout.fillWidth: true
			Layout.preferredHeight: 1
			color: "#a3a3a3"
		}

		Rectangle {
			Layout.fillWidth: true
			Layout.preferredHeight: 26
			color: "#f3f3f3"


		}

		Rectangle {
			Layout.fillWidth: true
			Layout.preferredHeight: 1
			color: "#cccccc"
		}

		ListView {
			id: outputView
			Layout.fillWidth: true
			Layout.fillHeight: true

			function exec(str) {
				input(str)
				var comp = 'import QtQuick 2.0; QtObject {\n'
				comp += 'Component.onCompleted: {\n'
				comp += 'try {\n'
				comp += 'var _result = ('
				comp += str.replace('console.log(', 'outputView.log(')
				comp += ')\n'
				comp += 'outputView.log(_result)\n'
				comp += '} catch (e) {\n'
				comp += 'outputView.error(e)\n'
				comp += '}\n'
				comp += '\ndestroy()'
				comp += '\n}'
				comp += '\n}'
				Qt.createQmlObject(comp, outputView)
			}

			model: ListModel {
				id: outputModel
			}

			function addMessage(messageType, str) {
				outputModel.append({
					type: messageType,
					message: '' + str,
				})
				outputView.positionViewAtEnd()
			}

			function input(str) {
				addMessage('input', str)
			}

			function log(str) {
				addMessage('log', str)
			}

			function error(str) {
				addMessage('error', str)
			}

			delegate: Rectangle {
				height: row.height

				RowLayout {
					id: row
					Text {
						Layout.preferredWidth: 20
					}
					Text {
						Layout.fillWidth: true
						text: model.message
					}
				}
			}
		}
		TextField {
			Layout.fillWidth: true
			Layout.preferredHeight: 30

			onAccepted: {
				outputView.exec(text)
				text = ''
			}
		}
	}
}
