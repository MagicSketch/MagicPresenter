'use strict';

var path = require('path');
var appdmg = require('appdmg');
var chalk = require('chalk');

module.exports = function (grunt) {
  grunt.registerMultiTask('appdmg', 'Generate DMG-images for Mac OSX', function () {
    var options = this.options();
    var done = this.async();

    if (options.configFile) {
      grunt.log.warn('"configFile" option has been deprecated.');
      delete options.configFile;
    }

    var basepath = options.basepath || process.cwd();
    delete options.basepath;

    // Iterate over all specified file groups.
    this.files.forEach(function (filePair) {
      var dirname = path.dirname(filePair.dest);
      var emitter;

      // Create directory beforehand to prevent error.
      grunt.file.mkdir(dirname);

      // Run appdmg module.
      emitter = appdmg({basepath: basepath, specification: options, target: filePair.dest});

      // Logging.
      // This should be removed when appdmg provides logging method.
      emitter.on('progress', function (info) {
        if (info.type === 'step-begin') {
          var line = '[' + (info.current <= 9 ? ' ' : '') + info.current + '/' + info.total + '] ' + info.title + '...';
          grunt.log.write(line + grunt.util.repeat(45 - line.length, ' '));
        }

        if (info.type === 'step-end') {
          var op = ({
            ok: ['green', ' OK '],
            skip: ['yellow', 'SKIP'],
            error: ['red', 'FAIL']
          }[info.status]);
          grunt.log.write('[' + chalk[op[0]](op[1]) + ']\n');
        }
      });

      emitter.on('finish', function () {
        grunt.log.writeln('\nImage: ' + chalk.cyan(filePair.dest) + ' created');
        done();
      });

      emitter.on('error', function (err) {
        grunt.log.error(err.toString());
        done(false);
      });
    });
  });
};
