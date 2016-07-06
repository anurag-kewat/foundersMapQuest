window.Main = class Main
	constructor: () ->
		@map
		@latColumn = "Garage Latitude"
		@lngColumn = "Garage Longitude"

		@userInputData = ""

		@userDetailsSection = ".UserDetails_section"

		# @getUsersDataOnPageLoad()
		@allData =  @getCSVStoredDataArray()

		@intializeDefaultMap()

	init: ->
		$("body").on "click", "#submitInput", (e) =>
			inputText = $("#inputTextArea").val()
			unless inputText is ""
				@userInputData = $.csv.toObjects(inputText)
				@getHtmlForSelectingLatLng()
				$(@userDetailsSection).removeClass("active")
				$(".UserDetails_configDetails").addClass("active")

		$("body").on "click", "#submitConfig", (e) =>
			@latColumn = $("#configTable").find("input[type='radio'][name='latitude']:checked").attr("value")
			@lngColumn = $("#configTable").find("input[type='radio'][name='longitude']:checked").attr("value")
			if @latColumn isnt undefined and @lngColumn isnt undefined
				html = @generateTable(@userInputData)
				$("#locationTable").html(html);
				$(@userDetailsSection).removeClass("active")
				$(".UserDetails_dataTable").addClass("active")

		$("body").on "click", ".UserDetails_prev", (e) =>
			prevSection = $(e.target).parent(@userDetailsSection).prev(@userDetailsSection)
			$(@userDetailsSection).removeClass("active")
			prevSection.addClass("active")

		$("body").on "click", "#submitData", (e) =>
			@allData = @userInputData
			@getMarkersOnMap(@map)
			$(@userDetailsSection).removeClass("active")
			$(".UserDetails_done").addClass("active")


	getHtmlForSelectingLatLng: -> 
		$("#configTable").empty()
		html = ""
		html += "<tr>
					<td></td>
					<td>Latitude</td>
					<td>Longitude</td>
				</tr>";
		keysAr = Object.keys(@userInputData[0])
		for item of keysAr
			html += "<tr><td>" + keysAr[item] + "</td>";
			html += "<td><input type='radio' name='latitude' value='" + keysAr[item] + "' /></td>";
			html += "<td><input type='radio' name='longitude' value='" + keysAr[item] + "' /></td>";
			html += "</tr>\r\n";
		$(html).appendTo("#configTable")

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
		$.each @allData, (i, row) =>
			values = {
				"lat": row[@latColumn]
				"lng": row[@lngColumn]
			}
			valuesAr.push(values)
		valuesAr

	intializeDefaultMap: =>
		google.maps.event.addDomListener window, 'load', @initializeMap

	initializeMap: =>
		infoWindow = @getGeoLocations()[0]
		position = new google.maps.LatLng(infoWindow.lat, infoWindow.lng)
		mapProp = 
				center: position
				zoom: 10
				mapTypeId: google.maps.MapTypeId.ROADMAP
		@map = new google.maps.Map(document.getElementById("googleMap"), mapProp)
		@getMarkersOnMap(@map)

	getMarkersOnMap: (map) ->
		$.each @getGeoLocations(), (i, location) ->	
			marker = new google.maps.Marker
				position: new google.maps.LatLng(location.lat, location.lng)
			marker.setMap(map);
		return
