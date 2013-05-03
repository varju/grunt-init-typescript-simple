@echo off 
start javaw -jar ./app/test/lib/JsTestDriver.jar --port 9876
phantomjs app\test\lib\phantomjs-jstd.js
