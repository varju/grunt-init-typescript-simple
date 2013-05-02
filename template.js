/*
 * grunt-init-typescript
 * https://gruntjs.com/
 *
 * Copyright (c) 2013. binedisk@github.com
 * Licensed under the MIT license.
 */

'use strict';

// 設定
exports.description = 'Create a TypeScript project including many useful features which integrates libraries such as JsTestDriver, Jasmine, jQuery, LiveReload.';
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
                message: 'Which is this project suitable for the "library" or the "application"?',
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
            var moduleDepth = 0;
            (function () {
                var projectName = '',className='', fullName='', fullPath='', subFullName='', subFullPath='',
                    subPackageName = '', subPackagePath = '', packageName='', packagePath='',
                    relativePathToRoot='', relativePathToSub = '';

                var uc = function (str) { return str.charAt(0).toUpperCase() + str.slice(1); };
                var lc = function (str) { return str.toLowerCase(); };

                var packageNames = props.name.split(/[-.]/);
                className = packageNames.pop();
                className = uc(className);
                if (packageNames.length > 0) {
                    packageName = packageNames.join('.');
                    packagePath = packageNames.join('/');
                    fullName    = packageName + '.' + className;
                    fullPath    = packagePath + '/' + className;
                    subPackageName = lc(fullName);
                    subPackagePath = lc(fullPath);
                    subFullName = subPackageName + '.MockSubClass';
                    subFullPath = subPackagePath + '/MockSubClass';
                    for (var i=0; i<packageNames.length; i++) {
                        relativePathToRoot += '../';
                    }
                }
                else {
                    subPackageName = subPackagePath = lc(className);
                    subFullName = subPackageName + '.MockSubClass';
                    subFullPath = subPackagePath + '/MockSubClass';
                    fullName = fullPath = className;
                    fullName = fullPath = className;
                }
                relativePathToSub = lc(className) + '/';
                moduleDepth = packageNames.length;
                projectName = fullName.replace(/[.]/g, '-').toLowerCase();

                props.is_application   = props.project_type !== 'library';
                props.is_library       = !props.is_application;
                props.project_name     = projectName;
                props.class_name       = className;
                props.name             = fullName;
                props.full_name        = fullName;
                props.full_path        = fullPath;
                props.package_name     = packageName;
                props.package_path     = packagePath;
                props.sub_package_name = subPackageName;
                props.sub_package_path = subPackagePath;
                props.sub_full_name    = subFullName;
                props.sub_full_path    = subFullPath;
                props.path_to_root     = relativePathToRoot;
                props.path_to_sub      = relativePathToSub;
                props.moduleDepth      = moduleDepth;
            })();

            var files = init.filesToCopy(props);
            
            // ライセンスファイルを追加
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
            
            // 削除
            grunt.file.delete('./__delete');
            
            done();
        }
    );
};
