# grunt-init-typescript-simple 0.0.7

> Create a TypeScript project including many useful features which integrates libraries such as JsTestDriver, Jasmine, jQuery, LiveReload.

[grunt-init]: http://gruntjs.com/project-scaffolding

## Installation
If you haven't already done so, install [grunt-init][].

Once grunt-init is installed, place this template in your `~/.grunt-init/` directory. It's recommended that you use git to clone this template into that directory, as follows:

```
git clone git@github.com:binedisk/grunt-init-typescript.git ~/.grunt-init/typescript-simple
```

_(Windows users, see [the documentation][grunt-init] for the correct destination directory path)_

## Usage

1. Create your project directory and cd into the empty directory.  
  ```C:\> mkdir ugo-fuga-hoge```  
  ```C:\> cd ugo-fuga-hoge```  
  ```C:\ugo-fuga-hoge>```  
  _Note that this template will generate files in the current directory, so be sure to change to a new directory first if you don't want to overwrite existing files._

2. Run this command and follow the prompts.  
  ```C:\ugo-fuga-hoge> grunt-init typescript-simple```

3. Install npm modules.  
  ```C:\ugo-fuga-hoge> npm install```

4. Fetch all the dependency libraries which written in "dependencies.json".  
  ```C:\ugo-fuga-hoge> grunt fetch```

5. Start a proxy server, a web server and livereloader.  
  ```C:\ugo-fuga-hoge> grunt dev```  
  Now, you can preview the sample application via "http://localhost:8000".

6. Run the JsTestDriver server and capture PhantomJS.  
  ```C:\ugo-fuga-hoge> java -jar app/test/lib/jsTestDriver.conf --port 9876```  
  or  
  ```C:\ugo-fuga-hoge> bin\jstd.bat```  
  Now, you can access the JsTestDriver server via "http://localhost:9000".  
  _Note that the port number is 9000 not 9876. The port number "9000" is proxied to "9876".

7. Run unit test.  
  ```C\ugo-fuga-hoge> grunt test   (or grunt t)```

8. Release modules into app/target directory and test them.  
  ```C:\ugo-fuga-hoge> grunt release:test   (or grunt rt)```  
  ```C:\ugo-fuga-hoge> grunt linktest       (or grunt lt)```

9. Relase minified production modules into app/dist directory.  
  ```C:\ugo-fuga-hoge> grunt release:production   (or grunt prod)```

10. If you want to add the module to dependencies, modify "denpendencies.json".  
  ```C:\ugo-fuga-hoge> vim dependencies.json```
