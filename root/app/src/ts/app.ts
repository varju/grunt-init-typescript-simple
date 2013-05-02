/// <reference path="d/require.d.ts" />
/// <reference path="{%= full_path %}.ts"/>


require.config(<RequireConfig>{
    baseUrl: 'js/',
    paths: {
        '{%= sub_full_name %}' : '{%= sub_full_path %}',
        '{%= full_name %}': '{%= full_path %}'
    },
    shim: {
        '{%= full_name %}': [ '{%= sub_full_name %}' ]
    }
});
require(
    ['{%= full_name %}'],
    () => {
        new {%= full_name %}();
        console.log('done');
    }
);
