module.exports = function (grunt) {

    var fs = require('fs');

    grunt.registerMultiTask(
        'addbom',
        'Add byte-order-mark to TypeScript files.',
        function () {
            var files = [];
            if (this.args.length > 0) {
                files = this.args;
            }
            else {
                files = [].concat.apply([],
                    this.files.map(function (file) { return file.src; }));
            }
            
            files.filter(function (filepath) {
                if (/d[.]ts$/.test(filepath) || !grunt.file.exists(filepath) ) {
                    return false;
                }
                return true;
            }).forEach(function (filepath) {
                // grunt.file.read は BOM を削除してしまうため使えない。
                var contents = fs.readFileSync(filepath);
                if (!/^\ufeff/.test(contents)) {
                    fs.writeFileSync(filepath, '\ufeff' + contents);
                    grunt.log.writeln('add bom to ' + filepath + '.');
                }
            });
        }
    );
};
