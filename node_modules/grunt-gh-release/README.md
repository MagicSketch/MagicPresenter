# grunt-gh-release

Create relases on GitHub from Grunt task.

## Getting Started
This plugin requires Grunt `~0.4.1`

If you havent used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you’re familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-gh-release --save-dev
```

After that it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-gh-release');
```

## The “gh_release” task

In your project’s `Gruntfile.js`, add a section named `gh_release` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  gh_release: {
    options: {
      // Credentials, required
      token: '...',
      owner: 'owner',
      repo: 'repo'
    },
    release: {
      // Release input
      // All options are optional, details: http://developer.github.com/v3/repos/releases/#input-1
      tag_name: '0.0.1',
      target_commitish: 'master',
      name: 'Initial release',
      body: 'Description of the release.',
      draft: false,
      prerelease: false,
      asset: {
        // Upload a release asset if needed
        name: 'plugin-0.0.1.zip',
        file: 'product/plugin-0.0.1.zip',
        'Content-Type': 'application/zip' // Common media types: http://en.wikipedia.org/wiki/Internet_media_type#List_of_common_media_types
      }
    }
  }
});
```

### API token

Create [your own personal API token](https://github.com/settings/applications) for use in the `options.token`. Be careful, token are like password so you should guard it carefully.

The best practice is to store token in separate gitignored-file, `secret.json` for example:

```json
{
  "gh_token": "f682bb3c305f65d8f6cfffea29f2a7e2b8b0c11a"
}
```

…and then to read it in `Gruntfile.js` like so:

```js
grunt.initConfig({
  gh_release: {
    options: {
      token: grunt.file.readJSON('secret.json').gh_token,
      owner: 'owner',
      repo: 'repo'
    },
    release: { /**/ }
  }
})
```

## Release History
### 0.0.1, Oct 8 2013
Initial commit.
