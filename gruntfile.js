module.exports = function (grunt) {
  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON("package.json"),
    sass: {
      // Task
      dist: {
        // Target
        options: {
          // Target options
          style: "expanded",
          "no-source-map": true,
        },
        files: {
          // Dictionary of files
          "inst/app/CSS/dest/sass.css": "inst/app/CSS/src/sass.scss", // 'destination': 'source'
        },
      },
    },
    concat: {
      combine: {
        src: ["inst/app/CSS/dest/tw.css", "inst/app/CSS/dest/sass.css"],
        dest: "inst/app/www/style.css",
        options: {
          banner:
            '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd HH:MM:ss") %> */\n',
        },
      },
    },
    cssmin: {
      target: {
        files: [
          {
            expand: true,
            cwd: "inst/app/CSS/dest",
            src: ["style.css"],
            dest: "inst/app/www",
            ext: ".min.css",
          },
        ],
      },
    },
    clean: {
      combine: {
        src: ["inst/app/CSS/dest/*"],
      },
    },

    // Watch for changes and run Tasks

    watch: {
      scripts: {
        files: ["inst/app/CSS/src/sass.scss", "inst/app/CSS/src/tailwind.scss"],
        tasks: ["sass", "concat", "clean"],
        options: {
          spawn: false,
        },
      },
    },
  });

  // npm install grunt --save-dev
  // npm install grunt-contrib-watch --save-dev
  grunt.loadNpmTasks("grunt-contrib-watch");
  // npm install grunt-contrib-jshint --save-dev
  // grunt.loadNpmTasks("grunt-contrib-jshint");
  // npm install grunt-contrib-concat --save-dev
  grunt.loadNpmTasks("grunt-contrib-concat");
  // npm install grunt-contrib-uglify --save-dev
  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks("grunt-contrib-uglify");
  // Plugin for compiling Sass
  grunt.loadNpmTasks("grunt-contrib-sass");
  // npm install grunt-contrib-clean --save-dev
  // Load the plugin that provides cleaning.
  grunt.loadNpmTasks("grunt-contrib-clean");

  grunt.loadNpmTasks("grunt-contrib-cssmin");

  grunt.registerTask("css", ["concat", "cssmin", "clean"]);
  // Default task(s).
  grunt.registerTask("default", ["sass", "concat", "clean"]);
};
