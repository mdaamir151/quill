_  = require('lodash')

remoteReporters = ['dots']
remoteReporters.push('saucelabs') if process.env.TRAVIS_BRANCH == 'master'

remoteBrowserGroups =
  'mac'     : ['mac-chrome', 'mac-firefox', 'mac-safari']
  'windows' : ['windows-chrome', 'windows-firefox', 'windows-ie-11']
  'legacy'  : ['windows-ie-10', 'windows-ie-9']
  'linux'   : ['linux-chrome', 'linux-firefox']
  'mobile'  : ['ipad', 'iphone', 'android']

remoteConfigs =
  browserDisconnectTimeout: 10000
  browserDisconnectTolerance: 2
  browserNoActivityTimeout: 60000
  reporters: remoteReporters

remoteKarma = _.reduce(remoteBrowserGroups, (memo, browsers, group) ->
  memo["remote-#{group}"] = _.defaults({ browsers: browsers }, remoteConfigs)
  _.each(browsers, (browser) ->
    memo["remote-#{browser}"] = _.defaults({ browsers: [browser] }, remoteConfigs)
  )
  return memo
, {})

module.exports = (grunt) ->
  grunt.config('karma', _.extend(remoteKarma,
    options:
      configFile: 'config/karma.js'
    coverage:
      browserNoActivityTimeout: 30000
      browsers: ['PhantomJS']
      reporters: ['coverage']
    local:
      browsers: ['Chrome', 'Firefox', 'Safari']
    server:
      autoWatch: true
      browsers: []
      singleRun: false
    test:
      browsers: ['PhantomJS']
  ))