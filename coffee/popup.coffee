window.Popup = class Popup
	constructor: (userDetailsSection, userDetailsGetInput) ->
		$("#openUserScreen").click (e) ->
			popup = $(".Popup")
			popup.find(".TransparentBg").fadeIn(200, ->
				complete: popup.find(".Popup_container").addClass("Show").removeClass("jsRemoveShow")
				)
			$(userDetailsSection).removeClass("active")
			$(userDetailsGetInput).addClass("active")
			Utils.disableScroll()

		$(".PanelCloseBtn").click =>
			@closePopup()

		$(document).on "keydown", (e) =>
			@closePopup() if(e.keyCode is 27)

		@setPopupDimensions()
		$(window).on "resize", =>
			@setPopupDimensions()

		$(document).click (e) =>
			if $(".Popup").find(".Popup_container").hasClass("Show")
				el = $(e.target)
				unless el.hasClass("Popup_container") or el.parents(".Popup_container").length or el.hasClass("ShowPopup")
					@closePopup()

	setPopupDimensions: ->
		screenHeight = $(window).height()
		screenWidth = $(window).width()

		if $(window).width < 600
			$(".Popup_content").css("max-height", screenHeight - 140)
		else
			$(".Popup_content").css("max-height", screenHeight - 160)

	closePopup: =>
		$(".Popup").find(".TransparentBg").fadeOut(200, ->
			complete: $(".Popup").find(".Popup_container").removeClass("Show").addClass("jsRemoveShow")
			)
		Utils.enableScroll()