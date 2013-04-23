/// <reference path="d/require.d.ts" />
/// <reference path="{%= full_path %}.ts"/>


require.config(<RequireConfig>{
    baseUrl: 'js/',
    paths: {
        'underscore': 'vendor/underscore-1.4.4.min',
        'deepextend': 'vendor/underscoreDeepextend',
        'jquery': 'vendor/jquery-1.8.3.min',
        'json2': 'vendor/json2',
        '{%= full_name %}': '{%= full_path %}'
    },
    shim: {
        'deepextend': [ 'underscore' ],
        '{%= full_name %}': [ 'json2', 'jquery', 'deepextend' ]
    }
});
require(
    ['{%= full_name %}'],
    () => {
        new {%= full_name %}();
        console.log('done');
    }
);
