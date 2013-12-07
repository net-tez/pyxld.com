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
			h = $(this).height()
			controller.addTween(
				element,
				(new TimelineLite()).append([
					TweenMax.fromTo($(element + ' .center'), 1, 
						{css:{'padding-top': 0}, immediateRender:true}, 
						{css:{'padding-top': h  * 0.25}}
					),
				]),
				h
			)
        
		$('a.scrollto').on 'click', (e) ->
			$('body').animate({
					scrollTop: $( $(this).attr('href') ).offset().top
				}, 500)
			
			e.preventDefault()
			return false

		$('#js-navlist a').each ->
			$elem = $( $(this).attr('href'))

			$elem.waypoint =>
				$('#js-navlist li').removeClass 'active'
				$(this).parent('li').addClass 'active'
        

		$('#portfolio').waypoint ->
			$(@).waypoint('destroy')
			$('#portfolio .project').each ->
				name = $(this).attr('data-name')
				$('.thumbnail', this).css 'background-image', 'url("img/thumbnails/' + name + '.jpg")'

				$(this).on 'click', ->
					require ['text!../items/' + name + '/index.html'], (data) ->
						$('#portview').html(data).slideDown(500);
						screenCalc()
						$('body').animate({
								scrollTop: $('#portview').offset().top - 80
						}, 500)

		$('html').on 'click', ->
			if testimonialbox is on
				$('#clientlist li').removeClass('active')
				testimonialbox = false

	screenCalc = () ->
		standard = { x: 960, y: 573 }

		$('.screened').each ->

			if $('.screen', this).length isnt 0 then return false

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
			p_width  = $(this).parent().width();
			p_height = $(this).parent().height();

			width  = $(this).width();
			height = $(this).height();

			$(this).css
				top : Math.max((p_height - height) * 0.5, 40) + 'px'
				left: Math.max((p_width  - width ) * 0.5, 0 ) + 'px'

			$(this).parent().css
				'min-height': Math.max(height, p_height) + 'px'

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