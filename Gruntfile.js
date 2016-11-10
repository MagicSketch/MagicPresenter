module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    home: process.env.HOME,
    version: "v0.3",
    appdmg: {
      options: {
        "title": "Magic Presenter",
        "icon": "installer-mp-mounted.icns",
        "background": "installer-mp-background.png",
        "icon-size": 100,
        "window": {
          "size": { "width": 500, "height": 320 }
        },
        "contents": [
          { "x": 375, "y": 115, "type": "file", "path": "MagicPresenter.sketchplugin" }
        ]
      },
      target: {
        dest: 'MagicPresenter.dmg'
      }
    },
    shell: {
      kill: {
        command: [
          'pkill Sketch || true',
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
      beforeappdmg: {
        command: [
          'rm -rf MagicPresenter.dmg',
        ].join(' && ')
      },
      commit: {
        command: [
          'git add .',
          'git commit -m "Update binary"'
        ].join(' && ')
      },
      tag: {
        command: [
          'git tag -a <%= version %> -m "<%= version %>"',
          'git push origin <%= version %>',
        ].join(' && ')
      },
    },
    gh_release: {
      options: {
        // Credentials, required
        token: process.env.GITHUB_TOKEN,
        owner: 'MagicSketch',
        repo: 'MagicPresenter'
      },
      release: {
        // Release input
        // All options are optional, details: http://developer.github.com/v3/repos/releases/#input-1
        tag_name: '<%= version %>',
        // target_commitish: 'master',
        name: '<%= version %>',
        body: 'Description of the release.',
        draft: false,
        prerelease: true,
        asset: {
          // Upload a release asset if needed
          name: 'MagicPresenter.dmg',
          file: 'MagicPresenter.dmg',
          'Content-Type': 'application/x-apple-diskimage' // Common media types: http://en.wikipedia.org/wiki/Internet_media_type#List_of_common_media_types
        }
      }
    },
  });

  grunt.loadNpmTasks('grunt-shell');
  grunt.loadNpmTasks('grunt-gh-release');
  grunt.loadNpmTasks('grunt-appdmg');

  grunt.registerTask('kill', ['shell:kill']);
  grunt.registerTask('test', ['shell:test']);
  grunt.registerTask('install', ['shell:install']);
  grunt.registerTask('build', ['shell:build']);
  grunt.registerTask('archive', ['shell:beforeappdmg', 'appdmg']);
  grunt.registerTask('default', ['build', 'install', 'archive']);
  grunt.registerTask('tag', ['shell:tag']);
  grunt.registerTask('upload', ['tag', 'gh_release']);
  grunt.registerTask('release', ['build', 'archive', 'shell:commit', 'upload']);


};
