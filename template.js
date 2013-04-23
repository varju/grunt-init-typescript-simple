/*
 * grunt-init-typescript
 * https://gruntjs.com/
 *
 * Copyright (c) 2013. binedisk@github.com
 * Licensed under the MIT license.
 */

'use strict';

// 設定
exports.description = 'Create a TypeScript project, including many other features.';
exports.notes = '';
exports.after =
    'You should now install project dependencies with _npm ' +
    'install_. After that, you may execute project tasks with _grunt_. For ' +
    'more information about installing and configuring Grunt, please see ' +
    'the Getting Started guide:' +
    '\n\n' +
    'http://gruntjs.com/getting-started';
exports.warnOn = '*';

// テンプレートコピー
exports.template = function (grunt, init, done) {
    init.process(
        {},
        [
            init.prompt('name'),
            init.prompt('title'),
            {
                name: 'project_type',
                message: 'project type library or application',
                default: 'library'
            },
            {
                name: 'logo',
                message: 'logo url',
                default: 'http://example.com/logo.jpg'
            },
            init.prompt('description'),
            init.prompt('version', '0.0.1'),
            init.prompt('repository'),
            init.prompt('homepage'),
            init.prompt('bugs'),
            init.prompt('licenses', 'MIT'),
            init.prompt('author_name'),
            init.prompt('author_email'),
            init.prompt('author_url')
        ],
        function (err, props) {
            // パッケージ名とクラス名を設定する
            // ugo.fuga.hoge
            //  class_name   : Hoge
            //  package_name : ugo.fuga
            //  package_path : ugo/fuga
            //  full_name    : ugo.fuga.Hoge
            //  full_path    : ugo/fuga/Hoge
            var className, fullName, fullPath, packageName, packagePath, relativePathToRoot;
            var packageNames = props.name.split('.');
            className = packageNames.pop();
            className = className.charAt(0).toUpperCase() + className.slice(1);
            if (packageNames.length > 1) {
                packageName = packageNames.join('.');
                packagePath = packageNames.join('/');
                fullName    = packageName + '.' + className;
                fullPath    = packagePath + '/' + className;
            }
            else {
                fullName = fullPath = className;
            }
            relativePathToRoot = '';
            for (var i=0; i<packageNames.length; i++) {
                relativePathToRoot += '../';
            }
            props.class_name   = className;
            props.name         = fullName;
            props.full_name    = fullName;
            props.full_path    = fullPath;
            props.package_name = packageName;
            props.package_path = packagePath;
            props.path_to_root = relativePathToRoot;
            
            // ライセンスファイルを追加
            var files = init.filesToCopy(props);
            init.addLicenseFiles(files, props.licenses);

            // 全てコピーするが libs 以下は置換対象にしない
            init.copyAndProcess(files, props, {
                noProcess: [
                    'app/src/css/**',
                    'app/src/js/**',
                    'app/src/ts/d/**',
                    'app/test/lib/**',
                    'app/test/specs/**',
                    'app/test/static/**',
                    'app/test/vendor/**',
                    'bin/**',
                    'docs/**',
                    'tasks/**'
                ]
            });
            done();
        }
    );
};
