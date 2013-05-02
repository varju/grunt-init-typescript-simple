/// <reference path="{%= path_to_root %}d/underscore-typed.d.ts"/>
/// <reference path="{%= path_to_root %}d/underscore-merge.d.ts"/>
/// <reference path="{%= path_to_sub %}MockSubClass.ts"/>

/**
 * {%= class_name %}
 *
 * @class {%= class_name %}
 */
class {%= class_name %} {
    constructor(message:string = 'hello') {
        console.log('[mainclass]: ' + message);
    }
}
