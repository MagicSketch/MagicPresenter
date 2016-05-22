module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    home: process.env.HOME,
    xcode: {
      options: {
        project: 'MagicPresenter.xcodeproj',
        scheme: 'Release'
      }
    },
    shell: {
      kill: {
        command: [
          'killall Sketch > /dev/null 2>&1',
          'killall Sketch\ Beta > /dev/null 2>&1',
        ].join(' && ')
      },
      test: {
        command: [
          './coscript RunTests.js'
        ].join(' && ')
      },
      install: {
        command: [
          'rm -rf "<%= home %>/Library/Application Support/com.bohemiancoding.sketch3/Plugins/MagicPresenter.sketchplugin"',
          'cp -r MagicPresenter.sketchplugin "<%= home %>/Library/Application Support/com.bohemiancoding.sketch3/Plugins/"'
        ].join(' && ')
      },
      build: {
        command: [
          'mkdir -p Logs',
          'echo "Building Release Version of MagicPresenter"',
          'xctool -scheme MagicPresenter -configuration Release',
        ].join(' && ')
      },
      archive: {
        command: [
          'echo "Creating MagicPresenter.dmg"',
          'rm -rf MagicPresenter.dmg',
          'appdmg release.json MagicPresenter.dmg'
        ].join(' && ')
      },
    },
  });

  grunt.loadNpmTasks('grunt-shell');

  grunt.registerTask('kill', ['shell:kill']);
  grunt.registerTask('test', ['shell:test']);
  grunt.registerTask('install', ['shell:install']);
  grunt.registerTask('build', ['shell:build']);
  grunt.registerTask('archive', ['shell:archive']);
  grunt.registerTask('default', ['shell:build', 'shell:install', 'shell:archive']);

};
