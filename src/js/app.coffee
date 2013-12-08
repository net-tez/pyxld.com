define [
	'jquery',
	'underscore',
	'scrollorama',
	'waypoints',
	'mixitup'
], ($, _) ->

	initPrecenter = ->

	initPostcenter = ->
		controller = $.superscrollorama
			triggerAtCenter: false,
			playoutAnimations: true

		winheight = $(window).height()
		winwidth = $(window).width()
		navheight = $('#js-nav').height()

		parallaxer = (element) ->
			h = $(element).height()
			controller.addTween(
				element,
				(new TimelineLite()).append([
					TweenMax.fromTo($(element), 1, 
						{css:{'background-position': '0px 0px'}, immediateRender:true}, 
						{css:{'background-position':'0px ' + h  * 0.25 + 'px'}}
					),
				]),
				h
			)

		parallaxer '#hello'

		controller.addTween(
			'#about .screened',
			(new TimelineLite()).append([
				TweenMax.fromTo($('#about .screened'), 1, 
					{css:{'top': 75}, immediateRender:true}, 
					{css:{'top': 0}}
				),
			]),
			winheight * 0.75,
			-winheight
		)
        
		$('a.scrollto').on 'click', (e) ->
			$('body').animate({
					scrollTop: $( $(@).attr('href') ).offset().top
				}, 1000)
			
			e.preventDefault()
			return false

		$('#js-navlist a').each ->
			$elem = $( $(@).attr('href'))

			$elem.waypoint =>
				$('#js-navlist li').removeClass 'active'
				$(@).parent('li').addClass 'active'
        

		$('#portfolio').waypoint ->
			$(@).waypoint('destroy')
			$('#portfolio .project').each ->
				name = $(@).attr('data-name')
				$('.thumbnail', @).css 'background-image', 'url("img/thumbnails/' + name + '.jpg")'

				$(@).on 'click', ->
					require ['text!../items/' + name + '/index.html'], (data) ->
						$('#portview').html(data).slideDown(500);
						screenCalc()
						$('body').animate({
								scrollTop: $('#portview').offset().top - 80
						}, 500)
		screenCalc()

	screenCalc = () ->
		standard = { x: 960, y: 573 }

		$('.screened').each ->

			if $('.screen', @).length isnt 0 then return false

			$parent = $(@).parent()
			dims =
				px: $parent.width()
				py: $parent.height()
				x: $(@).width()
				y: $(@).height()

			scale = dims.px / standard.x

			scr = $('<div class="screen" />')
			scr.css
				width : standard.x * scale
				height: standard.y * scale

			wrap = $('<div />');
			wrap.css
				position : 'absolute'
				top      : 30 * scale
				left     : 112 * scale
				overflow : 'hidden'
				width    : 735 * scale
				height   : 470 * scale

			$('> *:first-child', @).wrap wrap
			$(@).append(scr).css('height', standard.y * scale);

	isInViewport = (el) ->
		top = $(el).offset().top
		scrolled = $(window).scrollTop()
		viewheight = $(window).height()

		if scrolled + viewheight < top then return false

		height = $(el).height()
		if scrolled > top + height then return false

		return true


	intervalWhileVisible = (interval, element, func) ->
		started = false

		do startInterval = ->
			if started is true then return false

			started = true
			f = ->
				if isInViewport element
					func()
					start()
				else
					started = false

			do start = -> window.setTimeout f, interval

		$(element).waypoint startInterval


	centerElements = ->
		$('.center').each ->
			p_width  = $(@).parent().width();
			p_height = $(@).parent().height();

			width  = $(@).width();
			height = $(@).height();

			cents = {}
			only = $(@).attr 'data-only'
			padding = $(@).attr('data-pad') or 40
			if only is 'y' or not only
				cents.top = Math.max((p_height - height) * 0.5, padding) + 'px'

				$(@).parent().css
					'min-height': Math.max(height, p_height, $(@).attr('min-height')) + 'px'

			if only is 'x' or not only
				cents.left = Math.max((p_width  - width ) * 0.5, 0 ) + 'px'

			$(@).css cents

	setSlide = ->
		height = $(window).height()

		$('.slide').css
			'min-height': height + 'px'


	resizeUpdates = _.throttle(
		->
			centerElements()
			setSlide()
		, 33
	)

	return {
		initialize: ->
			$(document).ready ->
				initPrecenter()
				setSlide()
				centerElements()
				initPostcenter()

				$(window).on 'resize', resizeUpdates
	}