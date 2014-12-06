module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('bower.json'),

    copyrightSince: function(year) {
      var now = new Date().getFullYear();
      return year + (now > year ? '-' + now : '');
    },

    copy: {
      options: {
        processContent: function (content, srcpath) {
          return grunt.template.process(content);
        }
      },
      license: {
        src: 'templates/license.tmpl',
        dest: 'LICENSE.txt'
      }
    },

    less: {
      dist: {
        files: grunt.file.expandMapping(['app/components/**/*.less'], 'public/components/', {
          rename: function(dest, src) {
            return dest + src.replace(/app\/components\/(.+)\.less$/, '$1.css');
          }
        })
      }
    },

    coffeelint: {
      src: ['app/components/**/*.coffee'],
      options: {
        max_line_length: { level: 'ignore' }
      }
    },

    coffee: {
      build: {
        cwd: 'app/components',
        src: ['**/*.coffee'],
        dest: 'public/components/',
        ext: '.js',
        expand: true
      }
    },

    htmlbuild: {
      dist: {
        cwd: 'app/components',
        src: '**/*.html',
        dest: 'public/components',
        expand: true,
        options: {
          data: {
            copyright: grunt.file.read('templates/copyright.tmpl')
          }
        }
      }
    },

    connect: {
      server: {
        options: {
          port: 8080,
          base: '.',
          middleware: function(connect, options, middlewares) {
            middlewares.unshift(mapDotDotUrlToLib);
            return middlewares;
          }
        }
      }
    },

    watch: {
      stylesheets: {
        files: ['app/components/**/*.less'],
        tasks: ['newer:less']
      },
      scripts: {
        files: ['app/components/**/*.coffee'],
        tasks: ['newer:coffee']
      },
      html: {
        files: ['app/components/**/*.html'],
        tasks: ['newer:htmlbuild']
      },
      tests: {
        files: 'test/*.html',
        tasks: []
      },
      options: {
        livereload: false
      }
    },

    bumpversion: {
      options: {
        files: ['bower.json'],
        updateConfigs: ['pkg'],
        commit: true,
        commitFiles: ['-a'],
        commitMessage:'Bump version number to %VERSION%',
        createTag: true,
        tagName: '%VERSION%',
        tagMessage:'Version %VERSION%',
        push: false
      }
    },

    changelog: {
      options: {
      }
    }
  });

  grunt.loadNpmTasks('grunt-bump');
  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-conventional-changelog');
  grunt.loadNpmTasks('grunt-html-build');
  grunt.loadNpmTasks('grunt-newer');

  grunt.registerTask('build', 'Compile all assets and create the distribution files',
    ['less', 'coffeelint', 'coffee', 'htmlbuild']);

  grunt.task.renameTask('bump', 'bumpversion');

  grunt.registerTask('bump', '', function(versionType) {
    versionType = versionType ? versionType : 'patch';
    grunt.task.run(['bumpversion:' + versionType + ':bump-only',
      'build', 'copy:license', 'changelog', 'bumpversion::commit-only']);
  });

  grunt.registerTask('default', 'Build the software, start a web server and watch for changes',
    ['build', 'watch']
  );
};
