(function() {

  define(['jquery', 'underscore', 'scrollorama', 'waypoints', 'mixitup'], function($, _) {
    var centerElements, initPostcenter, initPrecenter, intervalWhileVisible, isInViewport, resizeUpdates, screenCalc, setSlide;
    initPrecenter = function() {};
    initPostcenter = function() {
      var controller, navheight, parallaxer, winheight, winwidth;
      controller = $.superscrollorama({
        triggerAtCenter: false,
        playoutAnimations: true
      });
      winheight = $(window).height();
      winwidth = $(window).width();
      navheight = $('#js-nav').height();
      parallaxer = function(element) {
        var h;
        h = $(element).height();
        return controller.addTween(element, (new TimelineLite()).append([
          TweenMax.fromTo($(element), 1, {
            css: {
              'background-position': '0px 0px'
            },
            immediateRender: true
          }, {
            css: {
              'background-position': '0px ' + h * 0.25 + 'px'
            }
          })
        ]), h);
      };
      parallaxer('#hello');
      $('a.scrollto').on('click', function(e) {
        $('body').animate({
          scrollTop: $($(this).attr('href')).offset().top
        }, 1000);
        e.preventDefault();
        return false;
      });
      $('#js-navlist a').each(function() {
        var $elem,
          _this = this;
        $elem = $($(this).attr('href'));
        return $elem.waypoint(function() {
          $('#js-navlist li').removeClass('active');
          return $(_this).parent('li').addClass('active');
        });
      });
      $('#portfolio').waypoint(function() {
        $(this).waypoint('destroy');
        return $('#portfolio .project').each(function() {
          var name;
          name = $(this).attr('data-name');
          $('.thumbnail', this).css('background-image', 'url("img/thumbnails/' + name + '.jpg")');
          return $(this).on('click', function() {
            return require(['text!../items/' + name + '/index.html'], function(data) {
              $('#portview').html(data).slideDown(500);
              screenCalc();
              return $('body').animate({
                scrollTop: $('#portview').offset().top - 80
              }, 500);
            });
          });
        });
      });
      return screenCalc();
    };
    screenCalc = function() {
      var standard;
      standard = {
        x: 960,
        y: 573
      };
      return $('.screened').each(function() {
        var $parent, dims, scale, scr, wrap;
        if ($('.screen', this).length !== 0) {
          return false;
        }
        $parent = $(this).parent();
        dims = {
          px: $parent.width(),
          py: $parent.height(),
          x: $(this).width(),
          y: $(this).height()
        };
        scale = dims.px / standard.x;
        scr = $('<div class="screen" />');
        scr.css({
          width: standard.x * scale,
          height: standard.y * scale
        });
        wrap = $('<div />');
        wrap.css({
          position: 'absolute',
          top: 30 * scale,
          left: 112 * scale,
          overflow: 'hidden',
          width: 735 * scale,
          height: 470 * scale
        });
        $('> *:first-child', this).wrap(wrap);
        return $(this).append(scr).css('height', standard.y * scale);
      });
    };
    isInViewport = function(el) {
      var height, scrolled, top, viewheight;
      top = $(el).offset().top;
      scrolled = $(window).scrollTop();
      viewheight = $(window).height();
      if (scrolled + viewheight < top) {
        return false;
      }
      height = $(el).height();
      if (scrolled > top + height) {
        return false;
      }
      return true;
    };
    intervalWhileVisible = function(interval, element, func) {
      var startInterval, started;
      started = false;
      (startInterval = function() {
        var f, start;
        if (started === true) {
          return false;
        }
        started = true;
        f = function() {
          if (isInViewport(element)) {
            func();
            return start();
          } else {
            return started = false;
          }
        };
        return (start = function() {
          return window.setTimeout(f, interval);
        })();
      })();
      return $(element).waypoint(startInterval);
    };
    centerElements = function() {
      return $('.center').each(function() {
        var cents, height, only, p_height, p_width, padding, width;
        p_width = $(this).parent().width();
        p_height = $(this).parent().height();
        width = $(this).width();
        height = $(this).height();
        cents = {};
        only = $(this).attr('data-only');
        padding = $(this).attr('data-pad') || 40;
        if (only === 'y' || !only) {
          cents.top = Math.max((p_height - height) * 0.5, padding) + 'px';
          $(this).parent().css({
            'min-height': Math.max(height, p_height) + 'px'
          });
        }
        if (only === 'x' || !only) {
          cents.left = Math.max((p_width - width) * 0.5, 0) + 'px';
        }
        return $(this).css(cents);
      });
    };
    setSlide = function() {
      var height;
      height = $(window).height();
      return $('.slide').css({
        'min-height': height + 'px'
      });
    };
    resizeUpdates = _.throttle(function() {
      centerElements();
      return setSlide();
    }, 33);
    return {
      initialize: function() {
        return $(document).ready(function() {
          initPrecenter();
          setSlide();
          centerElements();
          initPostcenter();
          return $(window).on('resize', resizeUpdates);
        });
      }
    };
  });

}).call(this);
