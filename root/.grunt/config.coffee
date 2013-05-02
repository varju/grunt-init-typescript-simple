exports.initConfiguration = (grunt) ->
  # 初期設定
  configuration =
    pkg: grunt.file.readJSON('package.json')

    # プロジェクトタイプとライブラリ名
    project:
      type: '{%= project_type %}'
      name: '<%= pkg.name.toLowerCase() %>'
      devPort : 8000
      jstdPort: 9876
      proxyPort: 9000
      fixturesPort: 9001
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
      fixtures   : '<%= path.test %>/static/fixtures'
      apidocs    : './docs/api/docs'
      apiTheme   : './docs/api/theme/<%= project.apiTheme %>'

      # ファイルタイプ別ソースパス
      css      : '<%= path.develop %>/css'
      ts       : '<%= path.develop %>/ts'
      js       : '<%= path.develop %>/js'
      vendor   : '<%= path.js %>/vendor'
      testCase : '<%= path.test %>/specs'

      # ソースファイル
      source:
        cssName   : 'main'
        appName   : 'app.js'
        appNameTs : 'app.ts'
        libName   : '<%= project.name %>.js'
        libNameTs : '<%= project.name %>.ts'
        libPathTs : '{%= full_path %}.ts'
        scss      : '<%= path.css %>/<%= path.source.cssName %>.scss' # SCSSソースパス
        css       : '<%= path.css %>/<%= path.source.cssName %>.css'  # コンパイル後CSSパス
        ts        : '<%= path.ts %>/**/*.ts'                          # TypeScript
        testCase  : '<%= path.testCase %>/**/*.coffee'                # CoffeeScript のテストケース
        app       : '<%= path.js %>/<%= path.source.appName %>'       # JSファイル名(アプリ)
        lib       : '<%= path.js %>/<%= path.source.libName %>'       # JSファイル名(ライブラリ)
        appDir    : '<%= path.js %>/app'

      # ターゲットファイル(圧縮先)
      target:
        cssName   : 'main.min.css'
        appName   : 'app.min.js'
        libName   : '<%= project.name %>.min.js'
        libNameTs : '<%= project.name %>.min.js'
        css       : '<%= path.css %>/<%= path.target.cssName %>' # 圧縮CSSファイル名
        app       : '<%= path.js %>/<%= path.target.appName %>'  # 圧縮JSファイル名(アプリ)
        lib       : '<%= path.js %>/<%= path.target.libName %>'  # 圧縮JSファイル名(ライブラリ)
        site      : '<%= path.production %>/site.zip'            # ウェブサイト全体のZIP TODO:日付と時刻の付与

    # sass のコンパイル
    # TODO: デバッグ時にも結合されてしまうのが微妙。全体をコンパイル仕直すので遅い。常駐しないので単体でも速くない。
    sass:
      compile:
        files:
          '<%= path.source.css %>': '<%= path.source.scss %>'

    # CSS の圧縮
    cssmin:
      compress:
        files:
          '<%= path.target.css %>': ['<%= path.source.css %>']

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

    # 外部コマンド実行
    exec:
      # 分割コンパイル app/lib 共通
      typescript_split:
        cmd: 'tsc --out <%= path.js %> <%= path.ts %>/<%= path.source.appNameTs %>'
        stdout: true
        stderr: true
      # 結合コンパイル app
      typescript_concat_app:
        cmd: 'tsc --out <%= path.debug %>/<%= path.source.appName  %> <%= path.ts %>/<%= path.source.appNameTs %>'
        stdout: true
        stderr: true
      # 結合コンパイル lib
      typescript_concat_lib:
        cmd: 'tsc --out <%= path.debug %>/<%= path.source.libName %> <%= path.ts %>/<%= path.source.libPathTs %>'
        stdout: true
        stderr: true
      # PhantomJS のキャプチャ
      capture_phantomjs:
        cmd: 'phantomjs <%= path.test %>/lib/phantomjs-jstd.js'


    # JS の圧縮
    uglify:
      lib:
        files:
          '<%= path.production %>/<%= path.target.libName %>': ['<%= path.debug %>/<%= path.source.libName %>']

    # ビルド(アプリの場合のみ。ライブラリプロジェクトではビルドは不要)
    requirejs:
      app:
        options:
          baseUrl        : '<%= path.js %>'
          name           : 'app'
          mainConfigFile : '<%= path.source.app %>'
          optimize       : 'none'
          out            : '<%= path.debug %>/js/<%= path.source.appName %>'
          include        : 'requireLib'
          paths:
            'requireLib': './vendor/require'
      appmin:
        options:
          baseUrl        : '<%= path.js %>'
          name           : 'app'
          mainConfigFile : '<%= path.source.app %>'
          optimize       : 'uglify2'
          out            : '<%= path.production %>/js/<%= path.target.appName %>'
          include        : 'requireLib'
          paths:
            'requireLib': './vendor/require'

    # ファイルの監視とコンパイル
    # TODO: このままだと1ファイル変更されるたびに全ファイルがコンパイルされて非効率だし、コンパイラが常駐してくれない
    regarde:
      sass:
        files: '<%= path.css %>/**/*.scss'
        tasks: ['sass:compile']
      css:
        files: '<%= path.css %>/**/*.css'
        tasks: ['livereload']
      html:
        files: '<%= path.develop %>/**/*.html'
        tasks: ['livereload']

    # プロキシサーバ (IDEA、JSTestDriver、web server の統合用)
    proxy:
      server:
        options:
          port: '<%= project.proxyPort %>'
          router:
            '^localhost/$' : 'localhost:<%= project.jstdPort %>'
            '^localhost((?!/spec/javascripts/fixtures).)+': 'localhost:<%= project.jstdPort %>'
            'localhost/spec/javascripts/fixtures': 'localhost:<%= project.fixturesPort %>'

    # 静的リソース配信サーバ
    connect:
      testFixtures:
        options:
          port: '<%= project.fixturesPort %>'
          base: '<%= path.fixtures %>'
          keepalive: false
      livereload:
        options:
          port: '<%= project.devPort %>'
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
            'js/**/*.js'
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
            'js/**/*.js'
            '*.*'
          ]
          dest: '<%= path.debug %>/'
        ]

    # JsTestDriverによるテスト実行
    jstd:
      dev:
        options:
          jar      : '<%= path.test %>/lib/JsTestDriver.jar'
          config   : '<%= path.test %>/jsTestDriverForDev.conf'
          basePath : '<%= path.test %>'
      link:
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

    addbom:
      add:
        files:
          src: ['app/src/ts/**/*.ts']

  # grunt-contrib-copy のカスタマイズ
  createProcessContent = (targetEnviroment) ->
    isProduction = targetEnviroment is 'production'

    (contents, srcpath) ->
      grunt.log.writeln('[src]: ' + srcpath)
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
      isVendorJs = m('app/src/js/vendor/**/*.js')
      #grunt.log.writeln(appPath)
      if isJs && !isAppJs && !isVendorJs
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

  # LiveReload
  createLiveReloadMiddleware = () ->
    path = require('path')
    lrSnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet

    folderMount = (connect, point) ->
      connect.static(path.resolve(point))

    (connect, options) ->
      [lrSnippet, folderMount(connect, options.base)]

  configuration.connect.livereload.options.middleware = createLiveReloadMiddleware()

  # copy settings
  configuration.copy['dist-app'].options.processContent = createProcessContent('production')
  configuration.copy['target-app'].options.processContent = createProcessContent('debug')
  
  # vendor package settings
  configuration.curl = do ->
    dependencies = grunt.file.readJSON('dependencies.json')
    dependencies.reduce(
      (memo, depend) ->
        memo[depend.name] = {
          src: depend.url
          dest: '<%= path.vendor %>/' + depend.name + '.js'
        }
        memo
      ,
      {}
    )

  configuration

