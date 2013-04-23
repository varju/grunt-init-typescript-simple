exports.initConfiguration = (grunt) ->
  # 初期設定
  configuration =
    pkg: grunt.file.readJSON('package.json')

    # プロジェクトタイプとライブラリ名
    project:
      type: '{%= project_type %}'
      name: '<%= pkg.name.toLowerCase() %>'
      port: 8000
      logo: '{%= logo %}'
      apiTheme: 'yuidoc-bootstrap-theme'

    # パスの定義
    path:
      # ベースパス
      base       : 'app'
      develop    : '<%= path.base %>/src'
      debug      : '<%= path.base %>/target'
      production : '<%= path.base %>/dist'
      test       : '<%= path.base %>/test'
      apidocs    : './docs/api/docs'
      apiTheme   : './docs/api/theme/<%= project.apiTheme %>'

      # ファイルタイプ別ソースパス
      css      : '<%= path.develop %>/css'
      ts       : '<%= path.develop %>/ts'
      js       : '<%= path.develop %>/js'
      testCase : '<%= path.test %>/specs'

      # ソースファイル
      source:
        cssName   : 'main'
        appName   : 'app.js'
        appNameTs : 'app.ts'
        libName   : '<%= project.name %>.js'
        scss      : '<%= path.css %>/<%= path.source.cssName %>.scss' # SCSSソースパス
        css       : '<%= path.css %>/<%= path.source.cssName %>.css'  # コンパイル後CSSパス
        ts        : '<%= path.ts %>/**/*.ts'                          # TypeScript
        testCase  : '<%= path.testCase %>/**/*.coffee'                # CoffeeScript のテストケース
        app       : '<%= path.js %>/<%= path.source.appName %>'       # JSファイル名(アプリ)
        lib       : '<%= path.js %>/<%= path.source.libName %>'       # JSファイル名(ライブラリ)
        appDir    : '<%= path.js %>/app'

      # ターゲットファイル(圧縮先)
      target:
        cssName : 'main.min.css'
        appName : 'app.min.js'
        libName : '<%= project.name %>.min.js'
        css     : '<%= path.css %>/<%= path.target.cssName %>' # 圧縮CSSファイル名
        app     : '<%= path.js %>/<%= path.target.appName %>'  # 圧縮JSファイル名(アプリ)
        lib     : '<%= path.js %>/<%= path.target.libName %>'  # 圧縮JSファイル名(ライブラリ)
        site    : '<%= path.production %>/site.zip'            # ウェブサイト全体のZIP TODO:日付と時刻の付与

    # sass のコンパイル
    # TODO: デバッグ時にも結合されてしまうのが微妙。全体をコンパイル仕直すので遅い。常駐しないので単体でも速くない。
    sass:
      compile:
        files:
          '<%= path.source.css %>': '<%= path.source.scss %>'

    # CSS の圧縮
    # TODO: ライブラリの時には原則不要。その切り替えが必要。
    cssmin:
      compress:
        files:
          '<%= path.target.css %>': ['<%= path.source.css %>']

    # TypeScript のコンパイル
    typescript:
      # 開発モード(分割コンパイル)
      split:
        src: ['<%= path.ts %>/**/*.ts']
        dest: '<%= path.js %>'
        options:
          base_path   : '<%= path.ts %>'
          module      : 'amd'
          target      : 'ES3'
          sourcemap   : false
          declaration : false

      # tsからのみなるライブラリの場合。app.ts は除く
      concat:
        src: [
          '<%= path.ts %>/**/*.ts'
          '!<%= path.ts %>/<%= path.source.appNameTs %>'
        ],
        dest: '<%= path.source.lib %>',
        options:
          base_path   : '<%= path.ts %>'
          module      : 'amd'
          target      : 'ES3'
          sourcemap   : false
          declaration : false

    # CoffeeScript のコンパイル
    coffee:
      testcase:
        options:
          bare: true
        files: [
          expand  : true
          flatten : false
          cwd     : '<%= path.testCase %>'
          src     : ['**/*.coffee']
          dest    : '<%= path.testCase %>'
          ext     : '.js'
        ]

    # JS の圧縮
    uglify:
      lib:
        files:
          '<%= path.target.lib %>': ['<%= path.source.lib %>']

    # ビルド(アプリの場合のみ。ライブラリプロジェクトではビルドは不要)
    requirejs:
      app:
        options:
          baseUrl        : '<%= path.js %>'
          name           : 'app'
          mainConfigFile : '<%= path.source.app %>'
          optimize       : 'none'
          out            : '<%= path.source.app %>'
          include        : 'requireLib'
          paths:
            'requireLib': './vendor/require'
      appmin:
        options:
          baseUrl        : '<%= path.js %>'
          name           : 'app'
          mainConfigFile : '<%= path.source.app %>'
          optimize       : 'uglify2'
          out            : '<%= path.js %>/<%= path.target.appName %>'
          include        : 'requireLib'
          paths:
            'requireLib': './vendor/require'

    # ファイルの監視とコンパイル
    # TODO: このままだと1ファイル変更されるたびに全ファイルがコンパイルされて非効率だし、コンパイラが常駐してくれない
    regarde:
      sass:
        files: '**/*.scss'
        tasks: ['sass:compile']
      css:
        files: '**/*.css'
        tasks: ['livereload']
      html:
        files: '**/*.html'
        tasks: ['livereload']

    # 静的リソース配信サーバ
    connect:
      server:
        options:
          port: '<%= project.port %>'
          base: '<%= path.develop %>'
          keepalive: true
      livereload:
        options:
          port: '<%= project.port %>'
          base: '<%= path.develop %>'
          keepalive: false

    # 不要ファイルの削除
    clean:
      doc: [
        '<%= path.apidocs %>'
      ]
      srcjs: [
        '<%= path.js %>/*.js'
        '<%= path.source.appDir %>/**/*.js'
      ]
      tsjs: [
        '<%= path.ts %>/**/*.js'
      ]
      target: [
        '<%= path.debug %>/**'
        '<%= path.source.css %>'
        '<%= path.source.app %>'
        '<%= path.source.lib %>'
      ]
      dist: [
        '<%= path.production %>/**'
        '<%= path.target.css %>'
        '<%= path.target.app %>'
        '<%= path.target.lib %>'
      ]

    # ファイルコピー
    copy:
      'dist-app':
        options:
          processContentExclude: false
        files: [
          expand : true
          cwd    : '<%= path.develop %>/'
          src    : [
            'css/**'
            'image/**'
            'js/*.js'
            '*.*'
          ]
          dest: '<%= path.production %>/'
        ]
      'target-app':
        options:
          processContentExclude: false
        files: [
          expand : true
          cwd    : '<%= path.develop %>/'
          src    : [
            'css/**'
            'image/**'
            'js/*.js'
            '*.*'
          ]
          dest: '<%= path.debug %>/'
        ]
      'dist-lib':
        files: [
          expand : true
          cwd    : '<%= path.js %>'
          src    : ['<%= path.target.libName %>']
          dest   : '<%= path.production %>/'
        ]
      'target-lib':
        files: [
          expand : true
          cwd    : '<%= path.js %>'
          src    : ['<%= path.source.libName %>']
          dest   : '<%= path.debug %>'
        ]
      'src-jsonly':
        files: [
          expand : true
          cwd    : '<%= path.ts %>'
          src    : ['**/*.js']
          dest   : '<%= path.js %>'
        ]

    # JsTestDriverによるテスト実行
    jstd:
      options:
        jar      : '<%= path.test %>/lib/JsTestDriver.jar'
        config   : '<%= path.test %>/jsTestDriver.conf'
        basePath : '<%= path.test %>'

    # APIドキュメント作成
    yuidoc:
      compile:
        name        : '<%= pkg.name %>'
        description : '<%= pkg.description %>'
        version     : '<%= pkg.version %>'
        url         : '<%= pkg.homepage %>'
        logo        : '<%= project.logo %>'
        options     :
          paths     : '<%= path.ts %>'
          extension : '.ts'
          outdir    : '<%= path.apidocs %>'
          themedir  : '<%= path.apiTheme %>'



  # grunt-contrib-copy のカスタマイズ
  createProcessContent = (targetEnviroment) ->
    isProduction = targetEnviroment is 'production'

    (contents, srcpath) ->
      # パスの取得
      config            = grunt.config.get
      appPath           = if isProduction then config('path.target.app') else config('path.source.app')
      sourceCssName     = config('path.source.cssName')
      targetCssName     = config('path.target.cssName')
      sourceCssPath     = config('path.source.css')
      targetCssPath     = config('path.target.css')
      destinationJsFile = if isProduction then config('path.target.appName') else config('path.source.appName')

      m = (pattern) ->
        grunt.file.minimatch(srcpath, pattern)

      # styl、sccs、sass、hb、ts の除外
      isExclude =
        m('**/*.styl') ||
        m('**/*.scss') ||
        m('**/*.sass') ||
        m('**/*.hb')   ||
        m('**/*.ts')

      if isExclude
        grunt.log.writeln('exclude: ' + srcpath)
        return false

      # production環境ならば main.css はコピーしない
      if isProduction && m(sourceCssPath)
        return false

      # debug環境ならば main.min.css はコピーしない
      if !isProduction && m(targetCssPath)
        return false

      # app.js 以外の js の除外
      isAppJs = m(appPath)
      isJs = m('**/*.js')
      grunt.log.writeln(appPath)
      if isJs && !isAppJs
        return false

      # メインのスクリプト読み込みを置換
      if m('**/*.html')
        script = '<script src="js/vendor/require.js" data-main="js/app"></script>'
        scriptRe = new RegExp(script, 'm')
        contents = contents.replace(scriptRe, '<script src="js/' + destinationJsFile + '"></script>')

        if isProduction
          cssLink = '<link rel="stylesheet" href="css/' + sourceCssName + '.css"/>'
          grunt.log.writeln(cssLink)
          cssLinkRe = new RegExp(cssLink, 'm')
          contents = contents.replace(cssLinkRe, '<link rel="stylesheet" href="css/' + targetCssName + '"/>')

      contents

  createLiveReloadMiddleware = () ->
    path = require('path')
    lrSnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet

    folderMount = (connect, point) ->
      connect.static(path.resolve(point))

    (connect, options) ->
      [lrSnippet, folderMount(connect, options.base)]

  configuration.connect.livereload.options.middleware = createLiveReloadMiddleware()

  configuration.copy['dist-app'].options.processContent = createProcessContent('production')
  configuration.copy['target-app'].options.processContent = createProcessContent('debug')

  configuration

