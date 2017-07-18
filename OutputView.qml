import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

import "SvgIconPaths.js" as SvgIconPaths

ListView {
	id: outputView

	interactive: false

	function exec(str) {
		if (str.trim().length == 0) {
			return
		}
		outputView.input(str)
		var comp = 'import QtQuick 2.0; QtObject {\n'
		comp += 'Component.onCompleted: {\n'
		comp += 'try {\n'
		var parsedStr = str.trim()
		parsedStr = parsedStr.replace('console.log(', 'outputView.log(')
		parsedStr = parsedStr.replace('$0', 'elementsView.selectedObj')
		var str1 = parsedStr.substr(0, parsedStr.lastIndexOf('\n') - 1)
		var str2 = parsedStr.substr(parsedStr.lastIndexOf('\n') + 1)
		comp += str1
		comp += 'var _result = ('
		comp += str2
		comp += ')\n'
		comp += 'outputView.output(_result)\n'
		comp += '} catch (e) {\n'
		comp += 'outputView.error(e)\n'
		comp += '}\n'
		comp += 'destroy()\n'
		comp += '}\n'
		comp += '}\n'
		try {
			Qt.createQmlObject(comp, outputView)
		} catch (e) {
			outputView.error(e)
		}
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

		Rectangle {
			anchors.left: parent.left
			anchors.bottom: parent.bottom
			anchors.right: parent.right
			visible: type == 'output'
			height: 1
			color: "#f0f0f0"
		}

		RowLayout {
			id: row
			spacing: 0

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
							return SvgIconPaths.arrowLeft
						} else if (type == 'output') {
							return SvgIconPaths.arrowRight
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
