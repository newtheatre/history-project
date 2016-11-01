'use strict';

var gulp = require('gulp');
var gutil = require('gulp-util');
var shell = require('gulp-shell')
var concat = require('gulp-concat')
var sass = require('gulp-sass');
var sourcemaps = require('gulp-sourcemaps');
var postcss = require('gulp-postcss');
var cssnext = require('postcss-cssnext');
var cssnano = require('cssnano');
var coffee = require('gulp-coffee');
var uglify = require('gulp-uglify');
var jsonlint = require("gulp-jsonlint");

var watch = require('gulp-watch');
var batch = require('gulp-batch');
var webserver = require('gulp-webserver');

var SHELL_OPTS = { verbose: true };

console.log("     _   _ ______ _  _ ____   ")
console.log("    / | / /_  __/ / / / __ \\ ")
console.log("   /  |/ / / / / /_/ / /_/ /  ")
console.log("  / /|  / / / / __  / ____/   ")
console.log(" /_/ |_/ /_/ /_/ /_/_/        ")
console.log("")

// Jekyll

gulp.task('jekyll', shell.task(
    ['bundle exec jekyll build --trace --profile'], SHELL_OPTS));

gulp.task('jekyll_inc', shell.task(
    ['bundle exec jekyll build --trace --incremental --profile'], SHELL_OPTS));

// Late files

function late_lib() {
  return gulp.src('lib/**')
             .pipe(gulp.dest('_site/lib'));
}

gulp.task('late_lib', late_lib);
gulp.task('S_late_lib', ['jekyll'], late_lib);
gulp.task('S_late_lib_dev', ['jekyll_inc'], late_lib);

var LATE_FILES = [
  'googlee5aee69e17917677.html'
];

function late_files() {
  return gulp.src(LATE_FILES)
             .pipe(gulp.dest('_site'));
}

gulp.task('late_files', late_files);
gulp.task('S_late_files', ['jekyll'], late_files);
gulp.task('S_late_files_dev', ['jekyll_inc'], late_files);

// CSS

function css(opts) {
    if (opts.postprocess) {
        var processors = [
            cssnext(),
            cssnano({autoprefixer: false}),
        ];
    } else { var processors = [] }

    return gulp.src('_sass/main.sass')
        .pipe(sourcemaps.init())
        .pipe(sass().on('error', sass.logError))
        .pipe(postcss(processors))
        .pipe(sourcemaps.write('.'))
        .pipe(gulp.dest('_site/css'));
}

gulp.task('css', function () { return css({postprocess: true}) });
gulp.task('css_dev', function () { return css({postprocess: false}) });
gulp.task('S_css', ['jekyll'], function () { return css({postprocess: true}) });
gulp.task('S_css_dev', ['jekyll_inc'], function () { return css({postprocess: false}) });

// JS

function js_app() {
    return gulp.src('_coffee/app/*.coffee')
               .pipe(sourcemaps.init())
               .pipe(coffee({bare: true}).on('error', gutil.log))
               .pipe(concat('app.js'))
               .pipe(uglify())
               .pipe(sourcemaps.write('.'))
               .pipe(gulp.dest('_site/js'));
}

gulp.task('js_app', js_app);
gulp.task('js_app_dev', js_app);
gulp.task('S_js_app', ['jekyll'], js_app);
gulp.task('S_js_app_dev', ['jekyll_inc'], js_app);

function js_scripts() {
    return gulp.src('_coffee/scripts/*.coffee')
               .pipe(sourcemaps.init())
               .pipe(coffee({bare: true}).on('error', gutil.log))
               .pipe(sourcemaps.write('.'))
               .pipe(gulp.dest('_site/js'));
}

gulp.task('js_scripts', js_scripts);
gulp.task('js_scripts_dev', js_scripts);
gulp.task('S_js_scripts', ['jekyll'], js_scripts);
gulp.task('S_js_scripts_dev', ['jekyll_inc'], js_scripts);

var JS_LIBS = [
    'lib/jquery/dist/jquery.js',
    'lib/underscore/underscore.js',
    'lib/turbolinks/dist/turbolinks.js',
    'lib/letteringjs/jquery.lettering.js',
    'lib/mousetrap/mousetrap.min.js',
    'lib/lunr.js/lunr.min.js',
    'lib/picturefill/dist/picturefill.js',
    'lib/moment/moment.js',
    'lib/raven-js/dist/raven.js'
]

function js_lib() {
    return gulp.src(JS_LIBS)
               .pipe(sourcemaps.init())
               .pipe(concat('lib.js'))
               .pipe(uglify())
               .pipe(sourcemaps.write('.'))
               .pipe(gulp.dest('_site/js'));
}

gulp.task('js_lib', js_lib);
gulp.task('js_lib_dev', js_lib);
gulp.task('S_js_lib', ['jekyll'], js_lib);
gulp.task('S_js_lib_dev', ['jekyll_inc'], js_lib);

// Search indexes

var CMD_INDEX_SEARCH = 'coffee _coffee/index/search_index_generator.coffee';
var CMD_INDEX_PEOPLE = 'coffee _coffee/index/people_index_generator.coffee';

gulp.task('index_search', shell.task([CMD_INDEX_SEARCH]));
gulp.task('S_index_search', ['jekyll'], shell.task([CMD_INDEX_SEARCH]));
gulp.task('S_index_search_dev', ['jekyll_inc'], shell.task([CMD_INDEX_SEARCH]));

gulp.task('index_people', shell.task([CMD_INDEX_PEOPLE]));
gulp.task('S_index_people', ['jekyll'], shell.task([CMD_INDEX_PEOPLE]));
gulp.task('S_index_people_dev', ['jekyll_inc'], shell.task([CMD_INDEX_PEOPLE]));

// Tests

gulp.task('htmlproof', shell.task(['bundle exec rake htmlproof']));
gulp.task('S_htmlproof', ['build', 'S_css', 'S_js_app', 'S_js_scripts'],
    shell.task(['bundle exec rake htmlproof']));

function feedlint() {
    return gulp.src('_site/feeds/*.json')
               .pipe(jsonlint())
               .pipe(jsonlint.reporter())
               .pipe(jsonlint.failAfterError());
}

gulp.task('jsonlint', feedlint);
gulp.task('S_jsonlint', ['S_index_search', 'S_index_people'], feedlint);

// Server

gulp.task('server', function() {
    watch(['_sass', '_coffee'], batch(function(events, done) {
        gulp.start('frontend', done);
    }));
    return gulp.src('_site/')
               .pipe(webserver({
                    host: '0.0.0.0',
                    livereload: true,
                    open: true,
                }));
});

gulp.task('watch', function() {
    watch(['_sass', '_coffee'], batch(function(events, done) {
        gulp.start('frontend', done);
    }));
})

// Master tasks

gulp.task('build', ['jekyll',
                    'S_late_lib',
                    'S_late_files',
                    'S_css',
                    'S_js_app',
                    'S_js_scripts',
                    'S_js_lib',
                    'S_index_search',
                    'S_index_people']);
gulp.task('debug', ['jekyll_inc',
                    'S_late_lib_dev',
                    'S_late_files_dev',
                    'S_css_dev',
                    'S_js_app_dev',
                    'S_js_scripts_dev',
                    'S_js_lib_dev',
                    'S_index_search_dev',
                    'S_index_people_dev']);

gulp.task('frontend', ['css_dev',
                       'js_app_dev',
                       'js_scripts_dev']);


gulp.task('test', ['htmlproof', 'jsonlint']);

