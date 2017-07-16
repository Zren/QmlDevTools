import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import org.kde.plasma.core 2.0 as PlasmaCore

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
				if (str.trim().length == 0) {
					return
				}
				input(str)
				var comp = 'import QtQuick 2.0; QtObject {\n'
				comp += 'Component.onCompleted: {\n'
				comp += 'try {\n'
				comp += 'var _result = ('
				comp += str.replace('console.log(', 'outputView.log(')
				comp += ')\n'
				comp += 'outputView.output(_result)\n'
				comp += '} catch (e) {\n'
				comp += 'outputView.error(e)\n'
				comp += '}\n'
				comp += 'destroy()\n'
				comp += '}\n'
				comp += '}\n'
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

			function output(str) {
				addMessage('output', str)
			}

			function log(str) {
				addMessage('log', str)
			}

			function error(str) {
				addMessage('error', str)
			}

			delegate: Item {
				width: parent.width
				height: row.height

				Rectangle {
					anchors.fill: parent
					visible: type == 'error'
					color: "#fff0f0"

					Rectangle {
						anchors.left: parent.left
						anchors.bottom: parent.top
						anchors.right: parent.right
						height: 1
						color: "#ffd7d7"
					}

					Rectangle {
						anchors.left: parent.left
						anchors.bottom: parent.bottom
						anchors.right: parent.right
						height: 1
						color: "#ffd7d7"
					}
				}

				RowLayout {
					id: row

					Item {
						anchors.top: parent.top
						anchors.topMargin: 3
						Layout.preferredWidth: 20
						height: 12

						PlasmaCore.IconItem {
							anchors.fill: parent
							visible: type == 'error'
							source: 'emblem-error'
						}
						SvgIcon {
							anchors.fill: parent
							visible: type == 'input' || type == 'output'
							iconSize: 16
							path: {
								if (type == 'input') {
									return 'm5 8l6.251-6 .749.719-4.298 4.125-1.237 1.156 1.237 1.156 4.298 4.125-.749.719-4.298-4.125z'
								} else if (type == 'output') {
									return 'm12 8l-6.251-6-.749.719 4.298 4.125 1.237 1.156-1.237 1.156-4.298 4.125.749.719 4.298-4.125z'
								} else {
									return ''
								}
							}
							fillColor: {
								if (type == 'input') {
									return '#bbbbbb'
								} else if (type == 'output') {
									return '#959595'
								} else {
									return ''
								}
							}
						}
					}
					Text {
						id: messageText
						Layout.fillWidth: true
						text: model.message
						color: {
							if (type == 'error') {
								return '#ff2d2d'
							} else {
								return '#000000'
							}
						}
					}
				}
			}
		}
		TextArea {
			id: textArea
			Layout.fillWidth: true
			Layout.preferredHeight: 30

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
		}
	}
}
