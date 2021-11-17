# QML Dev Tools

An inspector of the QML Item tree.

A quick demo of the inspector can be tested with:

```
qmlscene Main.qml
```

A more useful demo is to lazy load the Inspector window, then set the root target of the inspector.

```qml
Button {
	id: inspectButton
	icon.name: "konsole"
	text: "Inspect"
	onClicked: {
		var rootItem = getRootItem()
		devToolsWindowLoader.active = true
	}

	Loader {
		id: devToolsWindowLoader
		active: false
		visible: active
		source: "/home/chris/Code/QmlDevTools/DevToolsWindow.qml"
		onItemChanged: {
			if (item) {
				item.setTarget(inspectButton)
				item.visible = true
				item.visibleChanged.connect(function(){
					devToolsWindowLoader.active = false
				})
			}
		}
	}
}
```

![](https://i.imgur.com/2rXaXob.png)
