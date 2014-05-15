module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      compile:
        files:
          'lib/picklejuice.js': ['lib/picklejuice.coffee']
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.registerTask 'default', ['coffee']
