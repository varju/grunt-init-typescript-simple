@echo off 
start javaw -jar ./app/test/lib/JsTestDriver.jar --port 9876 --config ./app/test/jsTestDriver.conf --basePath ./app/test
REM start java -jar ./app/test/lib/JsTestDriver.jar --port 9876 --config ./app/test/jsTestDriver.conf --basePath ./app/test
phantomjs app\test\lib\phantomjs-jstd.js
