import QtQuick 2.0

QtObject {
	id: elementSelector
	property Rectangle rect: undefined

	property Connections conn: Connections {
		target: elementsModel
		onRootObjChanged: {
			var rectParent = elementsModel.getRootOf(elementsModel.rootObj)
			elementSelector.rect = Qt.createQmlObject('import QtQuick 2.0; Rectangle { color: "transparent"; border.color: "#ff0000"; z: 10000001 }', rectParent)
		}
	}

	signal itemSelected(var item)
	onItemSelected: {
		if (item instanceof Item && rect && elementsModel.rootObj) {
			// console.log('itemSelected', item)
			var globalPos = item.mapToItem(rect.parent, 0, 0, item.width, item.height)
			rect.x = globalPos.x
			rect.y = globalPos.y
			rect.width = globalPos.width
			rect.height = globalPos.height
		}
	}
}
