module.exports = function (grunt) {
  'use strict';

  var copies = grunt.file.readJSON('copies.json'),
      defaultTasks = ['clean', 'copy'];

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    watch: {
      main: {
        files: ['tasks/<%= pkg.name.replace(/^grunt-/, "").replace(/-/g, "_") %>.js'],
        tasks: defaultTasks
      }
    },
    clean: {
      options: {
        force: true
      },
      main: (function () {
        return copies.map(function (path) {
          return path + '<%= pkg.name %>/'
        });
      })()
    },
    copy: {
      main: {
        files: (function () {
          return copies.map(function (path) {
            return {
              src: ['**'],
              dest: path + '<%= pkg.name %>/'
            }
          });
        })()
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-shell');

  grunt.registerTask('default', defaultTasks);
  grunt.registerTask('look', (defaultTasks.join(' ') + ' watch').split(' '));
};