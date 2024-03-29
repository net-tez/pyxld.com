module.exports = function(grunt) {

  grunt.initConfig({
    coffee: {
      dist: {
        expand: true,
        cwd: 'src/js',
        src: ['**/*.coffee'],
        dest: '.tmp/js',
        ext: '.js'
      }
    },
    copy: {
      dist: {
        expand: true,
        cwd: 'src',
        src: ['**/*.jpg'],
        dest: 'dist'
      }
    },
    uglify: {
      options: {
        banner: '/*! Built with Grunt */\n"use strict";',
        mangle: false,
        compress: false,
        beautify: true
      },
      dist: {
        files: [{
          expand: true,
          cwd: '.tmp/js',
          src: ['*.js'],
          dest: 'dist/js',
          ext: '.js'
        }, {
          src: ['bower_components/jquery/jquery.js'],
          dest: 'dist/js/jquery.js'
        }, {
          src: ['bower_components/jquery-waypoints/waypoints.js'],
          dest: 'dist/js/waypoints.js'
        },, {
          src: ['bower_components/mixitup/src/jquery.mixitup.js'],
          dest: 'dist/js/mixitup.js'
        }, {
          src: ['bower_components/SuperScrollorama/js/jquery.superscrollorama.js'],
          dest: 'dist/js/scrollorama.js'
        }, {
          src: ['bower_components/greensock-js/src/uncompressed/TweenMax.js'],
          dest: 'dist/js/tweenmax.js'
        }, {
          src: ['bower_components/underscore/underscore.js'],
          dest: 'dist/js/underscore.js'
        }, {
          src: ['bower_components/requirejs/require.js'],
          dest: 'dist/js/require.js'
        }, {
          src: ['bower_components/requirejs-text/text.js'],
          dest: 'dist/js/text.js'
        }]
      }
    },
    less: {
      dist: {
        options: {
          yuicompress: true,
          concat: false
        },
        files: [{
          expand: true,
          cwd: 'src/css',
          src: ['*.less'],
          dest: 'dist/css',
          ext: '.css'
        }]
      }
    },
    htmlmin: {
      dist: {
        options: {
          removeComments: true,
          collapseWhitespace: true
        },
        files: [{
          expand: true,
          cwd: 'src',
          src: ['**/*.html'],
          dest: 'dist',
          ext: '.html'
        }]
      }
    },
    imagemin: {
      dist: {
        options: {
          removeComments: true
        },
        files: [{
          expand: true,
          cwd: 'src',
          src: ['**/*.{png,gif}'],
          dest: 'dist',
        }]
      }
    },
    concurrent: {
      build: ['coffee', 'less', 'imagemin', 'htmlmin', 'copy'],
      postbuild: ['uglify'],
      watch: ['watch:coffee', 'watch:less', 'watch:html']
    },
    clean: {
      pre: ['dist/css', 'dist/img', 'dist/js', 'dist/items', 'dist/*.html'],
      post: ['.tmp']
    },
    watch: {
      coffee: {
        files: ['src/js/*.coffee'],
        tasks: ['coffee', 'uglify']
      },
      less: {
        files: ['src/css/*.less'],
        tasks: ['less']
      },
      html: {
        files: ['src/*.html'],
        tasks: ['htmlmin']
      },
    },
  });

  grunt.loadNpmTasks('grunt-concurrent');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-imagemin');
  grunt.loadNpmTasks('grunt-contrib-htmlmin');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.registerTask('default', ['clean:pre', 'concurrent:build', 'concurrent:postbuild', 'clean:post']);
  grunt.registerTask('spy', ['clean:pre', 'concurrent:build', 'concurrent:postbuild', 'clean:post', 'concurrent:watch']);

};