module.exports = function (grunt) {
    grunt.registerTask(
        "jstd",
        "task for running tests with JsTestDriver",
        function () {
            var options = grunt.config.get('jstd.options');
            var done = this.async();
            grunt.util.spawn(
                {
                    cmd: "java",
                    args: [
                        "-jar",       options.jar,
                        "--config",   options.config,
                        "--basePath", options.basePath,
                        "--tests",    "all",
                        "--reset"
                    ]
                },
                function (err, res) {
                    grunt.log.writeln(res);
                    done(!+(/Fails: ([0-9]+);/.exec(res)[1]));
                }
            );
       }
    );
};
