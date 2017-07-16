import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

ScrollView {
	id: elementsView
	property alias listView: listView
	property alias model: listView.model
	property alias delegate: listView.delegate
	property alias currentItem: listView.currentItem
	property alias currentIndex: listView.currentIndex
	property alias boundsBehavior: listView.boundsBehavior
	property alias highlightMoveDuration: listView.highlightMoveDuration

	clip: true
	// focus: true
	// flickableItem.interactive: true

	ListView {
		id: listView
		boundsBehavior: Flickable.StopAtBounds
	}

	// Keyboard Navigation is no longer set when wrapped in a ScrollView
	// Bug: https://bugreports.qt.io/browse/QTBUG-31976
	Keys.onUpPressed: {
		listView.decrementCurrentIndex()
	}
	Keys.onDownPressed: {
		listView.incrementCurrentIndex()
	}
}
