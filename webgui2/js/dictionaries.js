const addressLines = {

	mainPage: "http://172.17.204.38:3000/index.html",
	ivCalculationPage: "http://172.17.204.38:3000/ivCalculations.html",
	threeDGraphing: "http://172.17.204.38:3000/3dGraphing.html",
	developersPage: "http://172.17.204.38:3000/developers.html",
	documentationPage: "http://172.17.204.38:3000/documentation.html",
	briefDocumentationPage: "http://172.17.204.38:3000/BriefDoc.html"

}

const typeDict = {
    0: "String", 1: "Array",
    99: "Unknown"
}

const separatorDict = {
    0: ".", 1: ",",
    2: " ", 99: "Unknown"
}

const multDict = {
    0: "*", 1: "e", 99: "Unknown"
}

const commaDict = {
    0: ",", 1: ".", 99: "Unknown"
}

export { addressLines, typeDict, separatorDict, multDict, commaDict };