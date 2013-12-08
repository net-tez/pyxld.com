(function() {

  require.config({
    paths: {
      jquery: ['//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min', 'jquery'],
      tweenmax: ['//cdnjs.cloudflare.com/ajax/libs/gsap/latest/TweenMax.min', 'tweenmax'],
      underscore: ['//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.5.2/underscore-min', 'underscore'],
      scrollorama: ['scrollorama'],
      waypoints: ['waypoints'],
      mixitup: ['mixitup']
    },
    shim: {
      scrollorama: ['jquery', 'tweenmax'],
      mixitup: ['jquery'],
      waypoints: ['jquery'],
      underscore: {
        exports: '_'
      }
    }
  });

  require(['app'], function(App) {
    return App.initialize();
  });

}).call(this);
