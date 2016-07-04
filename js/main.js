$(document).ready(function() {
	$.ajax({
		type: "GET",
		async: false,
		url: "data/sample.csv",
		dataType: "text",
		success: function(csvdata) {
			data = $.csv.toObjects(csvdata);
			var html = generateTable(data)
			$("#locationData").html(html);
		}
	});

	function generateTable(data) {
		var requiredHtml = "";

		if(typeof(data[0]) === 'undefined') {
			return null;
		}
		keysAr = Object.keys(data[0])

		// getting header
		requiredHtml += "<thead><tr>\r\n";
		for(var item in keysAr) {
			requiredHtml += "<td>" + keysAr[item] + "</td>\r\n";
		}
		requiredHtml += "<td>Active/Inactive</td>"; 
		requiredHtml += "</tr></thead>\r\n";

		// getting rows
		requiredHtml += "<tbody>";
		for (i = 0; i <= data.length - 1; i++) {
			values = Object.values(data[i]);
			// consoleLog(keys);
			requiredHtml += "<tr>\r\n";
			for(var val in values) {
				requiredHtml += "<td>" + values[val]	+ "</td>\r\n";
			}
			requiredHtml += "<td><input type='checkbox' id='"+ values[0] +"'></td>"
			requiredHtml += "</tr>\r\n";
		}
		requiredHtml += "</tbody>";

		return requiredHtml;
	}
});