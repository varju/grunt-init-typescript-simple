module.exports = (grunt) ->
  # 初期設定
  require('coffee-script')
  configuration = require('./.grunt/config').initConfiguration(grunt)
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
  grunt.loadNpmTasks('grunt-proxy')
  grunt.loadNpmTasks('grunt-exec')
  grunt.loadNpmTasks('grunt-regarde')
  grunt.loadTasks('tasks')
  grunt.loadNpmTasks('grunt-curl')

  ###################################
  ############### 共通 ##############
  ###################################
  # コンパイル
  do ->
    tasks = if isLibraryProject
      [
        'exec:typescript_concat_lib'
        'sass:compile'
      ]
    else
      [
        'exec:typescript_concat_app'
        'sass:compile'
      ]
    grunt.registerTask('compile', tasks)

  ###################################
  ########### 開発フェーズ ##########
  ###################################
  # 開発常駐タスク
  grunt.registerTask(
    'dev',
    [
      'clean:srcjs'
      'exec:typescript_split'
      'sass:compile'
      'coffee:testcase'
      'livereload-start'
      'connect:testFixtures'
      'connect:livereload'
      'proxy:server'
      'regarde'
    ]
  )
  grunt.registerTask('default', ['dev'])
  
  # ベンダーライブラリの取得
  grunt.registerTask('fetch', ['curl']);
  
  # コンパイル
  grunt.registerTask('c', ['exec:typescript_split']);
  
  # テスト
  grunt.registerTask('test', ['coffee:testcase', 'jstd:dev'])
  grunt.registerTask('t', ['test'])

  # ドキュメント生成
  grunt.registerTask('doc', ['yuidoc:compile'])

  ###################################
  ########## テストフェーズ #########
  ###################################
  do ->
    tasks = if isLibraryProject
      [
          'clean:srcjs'
          'clean:target'
          'coffee:testcase'
          'compile'
      ]
    else
      [
          'clean:srcjs'
          'clean:target'
          'coffee:testcase'
          'sass:compile'
          'copy:target-app'
          'exec:typescript_split'
          'requirejs:app'
      ]
    grunt.registerTask('release:test', tasks)

  grunt.registerTask('rt'      , ['release:test'])
  grunt.registerTask('rat'     , ['release:test', 'jstd:link'])
  grunt.registerTask('linktest', ['coffee:testcase', 'jstd:link'])
  grunt.registerTask('lt'      , ['linktest'])

  ###################################
  ######### リリースフェーズ #########
  ###################################
  do ->
    tasks = if isLibraryProject
      [
          'clean'
          'compile'
          'uglify:lib'
          'yuidoc:compile'
      ]
    else
      [
          'clean'
          'sass:compile'
          'cssmin:compress'
          'copy:dist-app'
          'exec:typescript_split'
          'requirejs:appmin'
          'yuidoc:compile'
      ]
    grunt.registerTask('release:prod', tasks)
  grunt.registerTask('prod', ['release:prod'])
