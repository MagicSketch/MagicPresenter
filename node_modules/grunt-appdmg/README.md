# grunt-appdmg
> Grunt plugin for generating Mac OS X DMG-images.

[![NPM Version][npm-image]][npm-url]
[![Build Status][travis-image]][travis-url]
[![Dependency Status][deps-image]][deps-url]

## Overview
**[node-appdmg](https://github.com/LinusU/node-appdmg)** is an awesome command line tool that can generate beautiful disk images (.dmg) for your OS X applications.
This Grunt plugin executes it using Gruntfile.

You can use [Grunt template strings](http://gruntjs.com/api/grunt.template) in the appdmg config, like: `title: '<%= pkg.name %>'`.

**Note:**  
Currently grunt-appdmg works on **Mac OS X only** due to the [node-appdmg limitation](https://github.com/LinusU/node-appdmg/issues/14).

## Getting started

This plugin requires [Grunt](http://gruntjs.com/) `>=0.4.0`.  
If you haven't used Grunt before, be sure to check out the [Getting started](http://gruntjs.com/getting-started) guide.

### Install
```shell
$ npm install grunt-appdmg --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-appdmg');
```

**For cross platform projects:**  
If you want to include this plugin in a cross platform project, install grunt-appdmg with `--save-optional` flag instead of `--save-dev`.
This will prevent npm-install error on Windows/Linux.

## The "appdmg" task

### Options
See the **[JSON Specification](https://github.com/LinusU/node-appdmg#json-specification)** of node-appdmg.  
Additionally `basepath` option is available in this plugin.

#### basepath
Type: `String`  
Default: `process.cwd()` - directory that contains Gruntfile.js

Optional. Base path to look for asset files: `icon`, `background` and `contents.path`.

### Example
In your project's Gruntfile, add a section named `appdmg` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  appdmg: {
    options: {
      basepath: 'path/to/assets',
      title: 'Title of DMG',
      icon: 'icon.icns',
      background: 'background.png',
      'icon-size': 80,
      contents: [
        {x: 448, y: 344, type: 'link', path: '/Applications'},
        {x: 192, y: 344, type: 'file', path: 'your-app.app'},
        {x: 512, y: 128, type: 'file', path: 'extra-file.txt'}
      ]
    },
    target: {
      dest: 'path/to/your-app.dmg'
    }
  }
});
```

## License
Copyright (c) 2014-2016 Rakuten, Inc.
Licensed under the [MIT License](LICENSE).

[npm-image]: https://img.shields.io/npm/v/grunt-appdmg.svg
[npm-url]: https://www.npmjs.com/package/grunt-appdmg
[travis-image]: https://travis-ci.org/rakuten-frontend/grunt-appdmg.svg?branch=master
[travis-url]: https://travis-ci.org/rakuten-frontend/grunt-appdmg
[deps-image]: https://david-dm.org/rakuten-frontend/grunt-appdmg.svg
[deps-url]: https://david-dm.org/rakuten-frontend/grunt-appdmg
