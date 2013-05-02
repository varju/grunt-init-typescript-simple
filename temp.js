// 例1 ugo.fuga.hoge
//   project_name     : ugo-fuga-hoge
//   class_name       : Hoge
//   package_name     : ugo.fuga
//   package_path     : ugo/fuga
//   full_name        : ugo.fuga.Hoge
//   full_path        : ugo/fuga/Hoge
//   sub_package_name : ugo.fuga.hoge
//   sub_package_path : ugo/fuga/hoge
//   sub_full_name    : ugo.fuga.hoge.MockSubClass
//   sub_full_path    : ugo/fuga/hoge/MockSubClass
//   path_to_root     : ../../
//   path_to_sub      : hoge/
//   親モジュール     : module ugo.fuga { class Hoge {} }
//   子モジュール     : module ugo.fuga.hoge { class MockSubClass {} }

// 例2 ugo.fuga.hoge
//   project_name     : fuga-hoge
//   class_name       : Hoge
//   package_name     : fuga
//   package_path     : fuga
//   full_name        : fuga.Hoge
//   full_path        : fuga/Hoge
//   sub_package_name : fuga.hoge
//   sub_package_path : fuga/hoge
//   sub_full_name    : fuga.hoge.MockSubClass
//   sub_full_path    : fuga/hoge/MockSubClass
//   path_to_root     : ../
//   path_to_sub      : hoge/
//   親モジュール     : module fuga { class Hoge {} }
//   子モジュール     : module fuga.hoge { class MockSubClass {} }

// 例3 hoge
//   project_name     : hoge
//   class_name       : Hoge
//   package_name     : -
//   package_path     : -
//   full_name        : Hoge
//   full_path        : Hoge
//   sub_package_name : hoge
//   sub_package_path : hoge
//   sub_full_name    : hoge.MockSubClass
//   sub_full_path    : hoge/MockSubClass
//   path_to_root     : -
//   path_to_sub      : hoge/
//   親モジュール     : class Hoge {}
//   子モジュール     : module hoge { class MockSubClass {} }

var props = { name: 'ugo.fuga.hoge' };
props = { name: 'fuga.hoge' };
props = { name: 'hoge' };

(function () {
    var projectName = '',className='', fullName='', fullPath='', subFullName='', subFullPath='',
        subPackageName = '', subPackagePath = '', packageName='', packagePath='',
        relativePathToRoot='', relativePathToSub = '';

    var uc = function (str) { return str.charAt(0).toUpperCase() + str.slice(1); };
    var lc = function (str) { return str.toLowerCase(); };

    var packageNames = props.name.split('.');
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
    }
    relativePathToSub = lc(className) + '/';
    
    projectName = fullName.replace(/[.]/g, '-').toLowerCase();
    
    // 親モジュールから見た、サブモジュールへの相対パス
    // モジュールがない場合の対応
    
    console.log('projectName    : ' + projectName);
    console.log('className      : ' + className);
    console.log('packageName    : ' + packageName);
    console.log('packagePath    : ' + packagePath);
    console.log('fullName       : ' + fullName);
    console.log('fullPath       : ' + fullPath);
    console.log('subPackageName : ' + subPackageName);
    console.log('subPackagePath : ' + subPackagePath);
    console.log('subFullName    : ' + subFullName);
    console.log('subFullPath    : ' + subFullPath);
    console.log('pathToRoot     : ' + relativePathToRoot);
    console.log('pathToSub      : ' + relativePathToSub);
    
    
    var test = {
        'a': 'A',
        'b': 'B',
        'c': 'C'
    };
    delete test['b'];
    console.log(test);
    
})();
