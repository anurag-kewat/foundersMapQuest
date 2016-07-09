window.Main = class Main
	constructor: () ->
		@map
		@latColumn = "Garage Latitude"
		@lngColumn = "Garage Longitude"
		@markLabel = "Founder"

		@userInputData = ""
		@userDetailsSection = ".UserDetails_section"

		# @getUsersDataOnPageLoad()
		@allData =  @getCSVStoredDataArray()
		@intializeDefaultMap()

		@excludeParams = ["id", "Display on Map"]

		@popup = new Popup(@userDetailsSection, ".UserDetails_getDetails")

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
			@markLabel = $("#configTable").find("input[type='radio'][name='markerLabel']:checked").attr("value")

			if @latColumn isnt undefined and @lngColumn isnt undefined and @markLabel isnt undefined
				@addPropInObjects()
				html = @generateTable(@userInputData)
				$("#locationTable").html(html);
				$(@userDetailsSection).removeClass("active")
				$(".UserDetails_dataTable").addClass("active")

		$("body").on "click", ".UserDetails_prev", (e) =>
			prevSection = $(e.target).parent(@userDetailsSection).prev(@userDetailsSection)
			$(@userDetailsSection).removeClass("active")
			prevSection.addClass("active")

		$("body").on "click", "#submitData", (e) =>
			@removeItemsWhichNotChecked()
			@allData = @userInputData
			@getMarkersOnMap(@map)
			$(@userDetailsSection).removeClass("active")
			$(".UserDetails_done").addClass("active")
			setTimeout (=>
				@popup.closePopup()
			), 800	


	addPropInObjects: ->
		for item of @userInputData
			@userInputData[item]["id"] = item
			@userInputData[item]["Display on Map"] = "yes"

	removeItemsWhichNotChecked: ->
		$(".DataTable_displayCheck").not(":checked").each (i, check) =>
			disableItem =  $(check).attr("id")
			@userInputData[disableItem]["Display on Map"] = "no"
			return
		return


	getHtmlForSelectingLatLng: -> 
		$("#configTable").empty()
		html = ""
		html += "<tr>
					<td></td>
					<td>Latitude</td>
					<td>Longitude</td>
					<td>Marker Label</td>
				</tr>";
		keysAr = Object.keys(@userInputData[0])
		for item of keysAr
			html += "<tr><td>" + keysAr[item] + "</td>";
			html += "<td><input type='radio' name='latitude' value='" + keysAr[item] + "' /></td>";
			html += "<td><input type='radio' name='longitude' value='" + keysAr[item] + "' /></td>";
			html += "<td><input type='radio' name='markerLabel' value='" + keysAr[item] + "' /></td>";
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
		requiredHtml += @gettingRows(data, keysAr) # getting rows
		return requiredHtml;

	gettingHeader: (keysAr) ->
		html = ""
		html += "<thead><tr>\r\n";
		for item of keysAr
			if $.inArray(keysAr[item], @excludeParams) is -1
				html += "<td>" + keysAr[item] + "</td>\r\n";
		html += "<td>Active/Inactive</td>"; 
		html += "</tr></thead>\r\n";
		return html;

	gettingRows: (data, keysAr) ->
		html = ""
		html += "<tbody>"
		i = 0
		while i <= data.length - 1
			values = Object.values(data[i])
			html = html + '<tr>\u000d\n'
			for val of values
				if $.inArray(keysAr[val], @excludeParams) is -1
					html += '<td>' + values[val] + '</td>\u000d\n'
			# html += '<td><input type=\'checkbox\' id=\'' + $.trim(values[0]+values[1]).replace(/ /g,'') + '\'></td>'
			html += '<td><input class=\'DataTable_displayCheck\' checked type=\'checkbox\' id=\'' + i + '\'></td>'
			html += '</tr>\u000d\n'
			i++
		html += "</tbody>"
		return html;

	getGeoLocations: ->
		valuesAr = []
		$.each @allData, (i, row) =>
			values = {
				"lat":   row[@latColumn]
				"lng":   row[@lngColumn]
				"label": row[@markLabel]
			}
			if row["Display on Map"] is "yes"
				valuesAr.push(values)
		valuesAr

	intializeDefaultMap: =>
		google.maps.event.addDomListener window, 'load', @initializeMap

	initializeMap: =>
		infoWindow = @getGeoLocations()[0]
		position = new google.maps.LatLng(infoWindow.lat, infoWindow.lng)
		mapProp = 
				center: position
				zoom: 5
				mapTypeId: google.maps.MapTypeId.ROADMAP
		@map = new google.maps.Map(document.getElementById("googleMap"), mapProp)
		@getMarkersOnMap(@map)

	getMarkersOnMap: (map) ->
		$.each @getGeoLocations(), (i, location) ->	
			marker = new google.maps.Marker
				position: new google.maps.LatLng(location.lat, location.lng),
				# animation: google.maps.Animation.BOUNCE
			marker.setMap(map);
			infowindow = new google.maps.InfoWindow
				content: location.label
			infowindow.open(map, marker);
		return


window.Utils = class Utils
	constructor: ->

	@disableScroll: ->
		$("body").addClass("disableScroll")

	@enableScroll: ->
		$("body").removeClass("disableScroll")
