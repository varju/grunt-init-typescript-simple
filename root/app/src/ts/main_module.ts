/// <reference path="{%= path_to_root %}d/underscore-typed.d.ts"/>
/// <reference path="{%= path_to_root %}d/underscore-merge.d.ts"/>
/// <reference path="{%= path_to_sub %}MockSubClass.ts"/>

/**
 * {%= package_name %}
 *
 * @module {%= package_name %}
 */
module {%= package_name %} {
    /**
     * {%= class_name %}
     *
     * @class {%= class_name %}
     */
    export class {%= class_name %} {
        constructor(message:string = 'hello') {
            console.log('[mainclass]: ' + message);
        }
    }
}
