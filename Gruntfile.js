module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('bower.json'),

    copyrightSince: function(year) {
      var now = new Date().getFullYear();
      return year + (now > year ? '-' + now : '');
    },

    copy: {
      options: {
        processContent: function(content, srcpath) {
          return grunt.template.process(content);
        }
      },
      license: {
        src: 'templates/license.tmpl',
        dest: 'LICENSE.txt'
      },
      images: {
        cwd: 'app/',
        src: ['web/**/*.gif', 'web/**/*.png'],
        dest: 'public/',
        expand: true
      }
    },

    less: {
      dist: {
        files: grunt.file.expandMapping(['app/web/**/*.less'], 'public/web/', {
          rename: function(dest, src) {
            return dest + src.replace(/app\/web\/(.+)\.less$/, '$1.css');
          }
        })
      }
    },

    coffeelint: {
      src: ['app/web/**/*.coffee'],
      options: {
        max_line_length: {level: 'ignore'}
      }
    },

    coffee: {
      build: {
        cwd: 'app/web',
        src: ['**/*.coffee'],
        dest: 'public/web/',
        ext: '.js',
        expand: true
      }
    },

    htmlbuild: {
      dist: {
        cwd: 'app/web',
        src: '**/*.html',
        dest: 'public/web',
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
        files: ['app/web/**/*.less'],
        tasks: ['newer:less']
      },
      scripts: {
        files: ['app/web/**/*.coffee'],
        tasks: ['newer:coffee']
      },
      html: {
        files: ['app/web/**/*.html'],
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
        commitMessage: 'Bump version number to %VERSION%',
        createTag: true,
        tagName: '%VERSION%',
        tagMessage: 'Version %VERSION%',
        push: false
      }
    },

    changelog: {
      options: {}
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
      ['newer:less', 'coffeelint', 'newer:coffee', 'newer:copy:images', 'newer:htmlbuild']);

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
