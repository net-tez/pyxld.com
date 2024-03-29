define [
	'jquery',
	'underscore',
	'scrollorama',
	'waypoints',
	'mixitup'
], ($, _) ->

	class Testimonials

		constructor: ->
			@index = -1
			@testimonials = {}

			_this = @
			$('#clients li').each ->
				_this.testimonials[$(@).attr('data-name')] = $(@).html()
			$('#clients ul').remove()

			@length = _.keys(@testimonials).length

			@$clients = $('#clients')
			@$image = $('img', @$clients)
			@$quote = $('blockquote', @$clients)

			@showNth(0)

			$('.arr-left', @$clients).on 'click', @showPrev
			$('.arr-right', @$clients).on 'click', @showNext

		showNth: (index) ->
			name = _.keys(@testimonials)[index]
			item = @testimonials[name]
			@index = index

			barheight = $('.white', @$clients).height()

			dup = ($elem, cb)->
				start = $elem.css 'top'
				$elem.animate {top: barheight, opacity: 0}, 300, 'linear', ->
					cb()
					$elem.animate
						top: start,
						opacity: 1

			dup @$image, =>
				@$image.attr 'src', 'items/' + name + '/profile.jpg'
			dup @$quote, =>
				@$quote.html item

			@switchBackground name

		switchBackground: (name) ->
			$('.bg', @$clients).fadeOut 500, -> $(@).remove()

			$('<div class="bg" />')
				.css('background-image', 'url(\'items/' + name + '/xlarge.jpg\')')
				#.hide()
				.prependTo(@$clients)
				#.fadeIn 500

		showNext: =>
			goto = @index + 1
			if goto is @length
				goto = 0

			@showNth goto

		showPrev: =>
			goto = @index - 1
			if goto < 0
				goto = @length

			@showNth goto

	initPrecenter = ->

	initPostcenter = ->
		
		new Testimonials()

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

		controller.addTween(
			'#team',
			(new TimelineLite()).append([
				TweenMax.fromTo($('#team h2'), 1, 
					{css:{'top': 75}, immediateRender:true}, 
					{css:{'top': 0}}
				),
			]),
			winheight * 0.75,
			-winheight
		)

		controller.addTween(
			'#services .row',
			(new TimelineLite()).append([
				TweenMax.fromTo($('#services .service:nth-child(odd)'), 1, 
					{css:{'left': -winwidth}, immediateRender:true}, 
					{css:{'left': 0}}
				),
				TweenMax.fromTo($('#services .service:nth-child(even)'), 1, 
					{css:{'left': winwidth}, immediateRender:true}, 
					{css:{'left': 0}}
				),
			]),
			winheight * 0.5,
			-winheight
		)
        
		$('a.scrollto').on 'click', (e) ->
			$('html, body').animate({
					scrollTop: $( $(@).attr('href') ).offset().top
				}, 1000)
			
			e.preventDefault()
			return false

		$('#js-navlist a').each ->
			$elem = $($(@).attr('href'))
			return false if not $elem
			
			$elem.waypoint =>
				$('#js-navlist li').removeClass 'active'
				$(@).parent('li').addClass 'active'
		
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

		$('#portfolio-grid').mixitup()

		screenCalc()

	screenCalc = () ->
		standard = { x: 960, y: 573 }

		$('.screened').each ->
			if $('.screen', @).length isnt 0 then return true

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
				top      : 31 * scale
				left     : 115 * scale
				overflow : 'hidden'
				width    : 731 * scale
				height   : 457 * scale

			$('> *:first-child', @).wrap wrap
			$(@).append(scr).css 'height', standard.y * scale
			return true

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


	centerElements = (parent = 'body')->
		$('.center', parent).each ->
			p_width  = $(@).parent().width();
			p_height = $(@).parent().height();

			width  = $(@).width();
			height = $(@).height();

			cents = {}
			only = $(@).attr 'data-only'
			padding = $(@).attr('data-pad') or 40
			if only is 'y' or not only
				cents.top = Math.max((p_height - height) * 0.5, padding) + 'px'

				_.defer -> $(@).parent().css {'min-height': Math.max(height, p_height, $(@).attr('min-height') or 0) + 'px'}

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

	bindForm = -> $('form').on 'submit', (e) ->
		e.preventDefault()

		$form = $(@)
		data = {}
		for i in $('[name]', $form)
			data[$(i).attr('name')] = $(i).val()
			$(i).attr 'disabled', 'disabled'

		success = '''
			<div class="alert alert-success">
				Your message has been sent. I will get back to you as soon as I am able!
			</div>
		'''

		failure = '''
			<div class="alert alert-danger">
				An error occured! Try contacting me directly by email (connor@peet.io) or Skype (connor4312) instead.
			</div>
		'''

		$.ajax
			url: $form.attr('action')
			type: $form.attr('method')
			data: data
			error: -> $form.prepend failure
			success: (response) ->
				if response is '1'
					$form.prepend success
				else
					$form.prepend failure



	return {
		initialize: ->
			$(document).ready ->
				initPrecenter()
				setSlide()
				centerElements()
				initPostcenter()
				bindForm()

				$(window).on 'resize', resizeUpdates
	}