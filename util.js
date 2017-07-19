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
