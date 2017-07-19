.pragma library

function isNull(obj) {
	return obj === null || typeof(obj) === 'undefined'
}

function valueToString(value) {
	if (value === null) {
		return "null"
	} else if (typeof(value) === "undefined") {
		return "undefined"
	} else {
		return value.toString()
	}
}

function getTagName(value) {
	var str = valueToString(value)
	for (var i = 0; i < str.length; i++) {
		if (str.charAt(i) == '_' || str.charAt(i) == '(') {
			return str.substr(0, i)
		}
	}
	return str
}

function endsWith(str, suffix) {
	var index = str.indexOf(suffix)
	return index >= 0 && index == str.length - suffix.length
}

function isChangedSignal(obj, key) {
	return typeof(obj[key]) === "function"
		&& endsWith(key, 'Changed')
		&& obj.hasOwnProperty(key.substr(0, key.length - 'Changed'.length))
}

function getObjectKeys(obj) {
	var tagName = getTagName(obj)
	if (tagName == 'QMenuProxy') {
		// Crashes on Object.keys()
		return []
	} else {
		return Object.keys(obj)
	}
}

function isItem(obj) {
	return !isNull(obj) && typeof obj.parent !== "undefined"
}

function isDescendantOf(obj, parentObj) {
	if (!isItem(obj)) {
		return false // We don't know.
	}
	var curItem = obj
	// while (curItem.parent) {
	for (var i = 0; i < 1000; i++) { // Hard limit
		if (!curItem.parent) {
			return false
		} else if (curItem.parent == parentObj) {
			return true
		}
		curItem = curItem.parent
	}
	return false // Reached hard limit
}
