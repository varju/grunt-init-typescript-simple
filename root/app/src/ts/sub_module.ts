/**
 * {%= sub_package_name %}
 *
 * @module {%= sub_package_name %}
 */
module {%= sub_package_name %} {
    /**
     * MockSubClass
     *
     * @class MockSubClass
     */
    export class MockSubClass {
        constructor(message:string = 'hello') {
            console.log('[subclass]: ' + message);
        }
    }
}
