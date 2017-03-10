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

// Late files

// Prevents need for processing lib directory.
// Prevents both items from presence on sitemap.

function late_lib() {
  return gulp.src('lib/**')
             .pipe(gulp.dest('_site/lib'));
}

gulp.task('late_lib', late_lib);

var LATE_FILES = [
  'googlee5aee69e17917677.html'
];

function late_files() {
  return gulp.src(LATE_FILES)
             .pipe(gulp.dest('_site'));
}

gulp.task('late_files', late_files);

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

function js_scripts() {
    return gulp.src('_coffee/scripts/*.coffee')
               .pipe(sourcemaps.init())
               .pipe(coffee({bare: true}).on('error', gutil.log))
               .pipe(sourcemaps.write('.'))
               .pipe(gulp.dest('_site/js'));
}

gulp.task('js_scripts', js_scripts);
gulp.task('js_scripts_dev', js_scripts);

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


// Frontend tasks

gulp.task('frontend', ['late_lib',
                       'late_files',
                       'css',
                       'js_app',
                       'js_scripts',
                       'js_lib'])

gulp.task('frontend_dev', ['css_dev',
                           'js_app_dev',
                           'js_scripts_dev']);


// Jekyll

gulp.task('jekyll', ['frontend'], shell.task(
    ['bundle exec jekyll build --trace --profile'], SHELL_OPTS));

gulp.task('jekyll_inc', ['frontend_dev'], shell.task(
    ['bundle exec jekyll build --trace --incremental --profile'], SHELL_OPTS));

// Search indexes

var CMD_INDEX_SEARCH = 'coffee _coffee/index/search_index_generator.coffee';
var CMD_INDEX_PEOPLE = 'coffee _coffee/index/people_index_generator.coffee';

gulp.task('index_search', shell.task([CMD_INDEX_SEARCH]));
gulp.task('S_index_search', ['jekyll'], shell.task([CMD_INDEX_SEARCH]));
gulp.task('S_index_search_dev', ['jekyll_inc'], shell.task([CMD_INDEX_SEARCH]));

gulp.task('index_people', shell.task([CMD_INDEX_PEOPLE]));
gulp.task('S_index_people', ['jekyll'], shell.task([CMD_INDEX_PEOPLE]));
gulp.task('S_index_people_dev', ['jekyll_inc'], shell.task([CMD_INDEX_PEOPLE]));

gulp.task('index', ['S_index_search', 'S_index_people'])
gulp.task('index_dev', ['S_index_search_dev', 'S_index_people_dev'])

// Tests

gulp.task('htmltest', shell.task(['_bin/htmltest']));

function feedlint() {
    return gulp.src('_site/feeds/*.json')
               .pipe(jsonlint())
               .pipe(jsonlint.reporter())
               .pipe(jsonlint.failAfterError());
}

gulp.task('jsonlint', feedlint);

// Server

gulp.task('server', function() {
    watch(['_sass', '_coffee'], batch(function(events, done) {
        gulp.start('frontend_dev', done);
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
        gulp.start('frontend_dev', done);
    }));
})

// Master tasks

gulp.task('default', ['build'])

gulp.task('build', ['frontend',
                    'jekyll',
                    'index']);

gulp.task('debug', ['frontend_dev',
                    'jekyll_inc',
                    'index_dev']);

gulp.task('test', ['htmltest', 'jsonlint']);

