window.Main = class Main
	constructor: () ->
		# @getUsersDataOnPageLoad()
		@allDataFromCSV =  @getCSVStoredDataArray()

		@spotPredefinedData()

	init: ->
		$("body").on "click", "#submitInput", (e) =>
			inputText = $("#inputTextArea").val()
			inputData = $.csv.toObjects(inputText)
			html = @generateTable(inputData)
			$("#locationTable").html(html);

	getCSVStoredDataArray: ->
		dataArray = []
		$.ajax(
			type: "GET",
			async: false,
			url: "data/sample.csv",
			dataType: "text",
			success: (csvdata) =>
				dataArray = $.csv.toObjects(csvdata)
		)
		dataArray;

	getUsersDataOnPageLoad: ->
		dataArray = @getCSVStoredDataArray()
		html = @generateTable(dataArray)
		$("#locationTable").html(html);

	generateTable: (data) ->
		requiredHtml = "";

		if typeof(data[0]) is 'undefined'
			return null;

		keysAr = Object.keys(data[0])
		requiredHtml += @gettingHeader(keysAr) # getting header
		requiredHtml += @gettingRows(data) # getting rows
		return requiredHtml;

	gettingHeader: (keysAr) ->
		html = ""
		html += "<thead><tr>\r\n";
		for item of keysAr
			html += "<td>" + keysAr[item] + "</td>\r\n";
		html += "<td>Active/Inactive</td>"; 
		html += "</tr></thead>\r\n";
		return html;

	gettingRows: (data) ->
		html = ""
		html += "<tbody>"
		i = 0
		while i <= data.length - 1
			values = Object.values(data[i])
			html = html + '<tr>\u000d\n'
			for val of values
				html += '<td>' + values[val] + '</td>\u000d\n'
			html += '<td><input type=\'checkbox\' id=\'' + values[0] + '\'></td>'
			html += '</tr>\u000d\n'
			i++
		html += "</tbody>"
		return html;

	getGeoLocations: ->
		valuesAr = []
		$.each @allDataFromCSV, (i, row) =>
			values = {
				"lat": row["Garage Latitude"]
				"lng": row["Garage Longitude"]
			}
			valuesAr.push(values)
		valuesAr

	spotPredefinedData: =>
		google.maps.event.addDomListener window, 'load', @initializeMap

	initializeMap: =>
		infoWindow = @getGeoLocations()[0]
		position = new google.maps.LatLng(infoWindow.lat, infoWindow.lng)
		mapProp = 
				center: position
				zoom: 10
				mapTypeId: google.maps.MapTypeId.ROADMAP
		map = new google.maps.Map(document.getElementById("googleMap"), mapProp)

		$.each @getGeoLocations(), (i, location) ->	
			marker = new google.maps.Marker
				position: new google.maps.LatLng(location.lat, location.lng)
			marker.setMap(map);
		return
