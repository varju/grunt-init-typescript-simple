module.exports = (grunt) ->
  # 初期設定
  require('coffee-script')
  configuration = require('./GruntConfig').initConfiguration(grunt)
  grunt.initConfig(configuration)
  projectType = grunt.config.get('project.type')
  isLibraryProject = projectType is 'library'

  # タスク登録
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-yuidoc')
  grunt.loadNpmTasks('grunt-contrib-sass')
  grunt.loadNpmTasks('grunt-contrib-cssmin')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-requirejs')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-livereload')
  grunt.loadNpmTasks('grunt-regarde')
  grunt.loadNpmTasks('grunt-typescript')
  grunt.loadTasks('tasks')

  ###################################
  ############### 共通 ##############
  ###################################
  # コンパイル
  do ->
    tasks = if isLibraryProject
      [
        'typescript:concat'
        'sass:compile'
      ]
    else
      [
        'typescript:split'
        'sass:compile'
      ]
    grunt.registerTask('compile', tasks)

  ###################################
  ########### 開発フェーズ ###########
  ###################################
  # 開発常駐タスク
  grunt.registerTask(
    'dev',
    [
      'clean:srcjs'
      'typescript:split'
      'sass:compile'
      'livereload-start'
      'connect:livereload'
      'regarde'
    ]
  )
  grunt.registerTask('default', ['dev'])

  # tsコンパイル後の後処理
  grunt.registerTask(
    'post-tscompile',
    [
      'copy:src-jsonly'
      'clean:tsjs'
    ]
  )

  # ドキュメント生成
  grunt.registerTask('doc', ['yuidoc:compile'])

  ###################################
  ########## テストフェーズ ##########
  ###################################
  do ->
    tasks = if isLibraryProject
      [
          'clean:srcjs'
          'clean:target'
          'coffee:testcase'
          'compile'
          'copy:target-lib'
      ]
    else
      [
          'clean:srcjs'
          'clean:target'
          'coffee:testcase'
          'compile'
          'requirejs:app'
          'copy:target-app'
      ]
    grunt.registerTask('release:test', tasks)

  grunt.registerTask('rt'  , ['release:test'])
  grunt.registerTask('rat' , ['release:test', 'jstd'])
  grunt.registerTask('test', ['coffee:testcase', 'jstd'])
  grunt.registerTask('t'   , ['test'])

  ###################################
  ######### リリースフェーズ #########
  ###################################
  do ->
    tasks = if isLibraryProject
      [
          'clean'
          'compile'
          'cssmin:compress'
          'uglify:lib'
          'copy:dist-lib'
          'yuidoc:compile'
      ]
    else
      [
          'clean'
          'compile'
          'cssmin:compress'
          'requirejs:appmin'
          'copy:dist-app'
          'yuidoc:compile'
      ]
    grunt.registerTask('release:prod', tasks)
  grunt.registerTask('prod', ['release:prod'])
