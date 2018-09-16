'use strict';

var gulp = require('gulp');
var gutil = require('gulp-util');
var gulpif = require('gulp-if');
var shell = require('gulp-shell');
var concat = require('gulp-concat');
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

var SHELL_OPTS = {verbose: true};

console.log("     _   _ ______ _  _ ____   ");
console.log("    / | / /_  __/ / / / __ \\ ");
console.log("   /  |/ / / / / /_/ / /_/ /  ");
console.log("  / /|  / / / / __  / ____/   ");
console.log(" /_/ |_/ /_/ /_/ /_/_/        ");
console.log("");

// Late files, (actually now early)

// Prevents need for processing lib directory.
// Prevents both items from presence on sitemap.

const LATE_FILES_ROOT = [
    'googlee5aee69e17917677.html',
    'manifest.json'
];

const LATE_FILES_LIB_SINGLES = [
    'node_modules/mapbox-gl/dist/mapbox-gl.css'
];

gulp.task('late_files_lib', function () {
    // Copies contents of lib/ into site
    return gulp.src('lib/**')
        .pipe(gulp.dest('_site/lib'));
});

gulp.task('late_files_lib_singles', function () {
    // Copies single files into lib/ in site
    return gulp.src(LATE_FILES_LIB_SINGLES)
        .pipe(gulp.dest('_site/lib'));
});

gulp.task('late_files_images', function () {
    // Copies contents of images/ into site
    return gulp.src('images/**')
        .pipe(gulp.dest('_site/images'));
});

gulp.task('late_files', ['late_files_lib', 'late_files_lib_singles', 'late_files_images'], function () {
    // Depends on the above tasks and copies the root late files
    return gulp.src(LATE_FILES_ROOT)
        .pipe(gulp.dest('_site'));
});

// CSS

function css(opts) {
    var processors = [];
    if (opts.postprocess) {
        processors = [
            cssnext(),
            cssnano({autoprefixer: false})
        ];
    }

    return gulp.src('_sass/main.sass')
        .pipe(sourcemaps.init())
        .pipe(sass().on('error', sass.logError))
        .pipe(postcss(processors))
        .pipe(sourcemaps.write('.'))
        .pipe(gulp.dest('_site/css'));
}

gulp.task('css', function () {
    return css({postprocess: true})
});
gulp.task('css_dev', function () {
    return css({postprocess: false})
});

// JS

function js_app(opts) {
    return gulp.src('_coffee/app/*.coffee')
        .pipe(sourcemaps.init())
        .pipe(coffee({bare: true}).on('error', gutil.log))
        .pipe(concat('app.js'))
        .pipe(gulpif(opts.postprocess, uglify()))
        .pipe(sourcemaps.write('.'))
        .pipe(gulp.dest('_site/js'));
}

gulp.task('js_app', function () {
    return js_app({postprocess: true})
});
gulp.task('js_app_dev', function () {
    return js_app({postprocess: false})
});

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
    'node_modules/mapbox-gl/dist/mapbox-gl.js',
    'lib/raven-js/dist/raven.js'
];

function js_lib(opts) {
    return gulp.src(JS_LIBS)
        .pipe(sourcemaps.init())
        .pipe(concat('lib.js'))
        .pipe(gulpif(opts.postprocess, uglify()))
        .pipe(sourcemaps.write('.'))
        .pipe(gulp.dest('_site/js'));
}

gulp.task('js_lib', function () {
    return js_lib({postprocess: true})
});
gulp.task('js_lib_dev', function () {
    return js_lib({postprocess: false})
});


// Frontend tasks

gulp.task('frontend', ['css',
    'js_app',
    'js_scripts',
    'js_lib']);

gulp.task('frontend_dev', ['css_dev',
    'js_app_dev',
    'js_scripts_dev',
    'js_lib_dev']);


// Jekyll

gulp.task('jekyll', ['late_files', 'frontend'], shell.task(
    ['bundle exec jekyll build --trace --profile'], SHELL_OPTS));

gulp.task('jekyll_dev', ['late_files', 'frontend_dev'], shell.task(
    ['bundle exec jekyll build --trace --profile'], SHELL_OPTS));

gulp.task('jekyll_inc', ['late_files', 'frontend_dev'], shell.task(
    ['bundle exec jekyll build --trace --incremental --profile'], SHELL_OPTS));

// Search indexes

var CMD_INDEX_SEARCH = 'coffee _coffee/index/search_index_generator.coffee';
var CMD_INDEX_PEOPLE = 'coffee _coffee/index/people_index_generator.coffee';

gulp.task('index_search', shell.task([CMD_INDEX_SEARCH]));
gulp.task('S_index_search', ['jekyll'], shell.task([CMD_INDEX_SEARCH]));
gulp.task('S_index_search_dev', ['jekyll_dev'], shell.task([CMD_INDEX_SEARCH]));
gulp.task('S_index_search_inc', ['jekyll_inc'], shell.task([CMD_INDEX_SEARCH]));

gulp.task('index_people', shell.task([CMD_INDEX_PEOPLE]));
gulp.task('S_index_people', ['jekyll'], shell.task([CMD_INDEX_PEOPLE]));
gulp.task('S_index_people_dev', ['jekyll_dev'], shell.task([CMD_INDEX_PEOPLE]));
gulp.task('S_index_people_inc', ['jekyll_inc'], shell.task([CMD_INDEX_PEOPLE]));

gulp.task('index', ['S_index_search', 'S_index_people']);
gulp.task('index_dev', ['S_index_search_dev', 'S_index_people_dev']);
gulp.task('index_inc', ['S_index_search_inc', 'S_index_people_inc']);

// Tests

gulp.task('htmltest', shell.task(['_bin/htmltest']));

gulp.task('yamllint', shell.task(['_bin/yamllint.sh']));

function feedlint() {
    return gulp.src('_site/feeds/*.json')
        .pipe(jsonlint())
        .pipe(jsonlint.reporter())
        .pipe(jsonlint.failAfterError());
}

gulp.task('jsonlint', feedlint);

// Server

gulp.task('server', function () {
    watch(['_sass', '_coffee'], batch(function (events, done) {
        gulp.start('frontend_dev', done);
    }));
    return gulp.src('_site/')
        .pipe(webserver({
            host: 'localhost',
            port: 7000,
            livereload: false,
            open: true
        }));
});

gulp.task('dockerserver', function () {
    return gulp.src('_site/')
        .pipe(webserver({
            host: '0.0.0.0',
            port: 8000,
            livereload: false,
            open: false
        }));
});

gulp.task('watch', function () {
    watch(['_sass', '_coffee'], batch(function (events, done) {
        gulp.start('frontend_dev', done);
    }));
});

// Utility Stuff

const SM_CACHE_URL = 'https://s3-eu-west-1.amazonaws.com/nthp/sm-cache.tar.xz';

gulp.task('mkdir_tmp', shell.task(
    ['mkdir -p tmp']));
gulp.task('download_sm_cache', ['mkdir_tmp'], shell.task(
    ['wget -qO tmp/sm-cache.tar.xz ' + SM_CACHE_URL]));
gulp.task('extract_sm_cache', ['download_sm_cache'], shell.task(
    ['tar xf tmp/sm-cache.tar.xz']));
gulp.task('sm_cache', ['download_sm_cache', 'extract_sm_cache']);

gulp.task('netlify_dev', ['sm_cache', 'build_dev']);

// Master tasks

// Default is build
gulp.task('default', ['build']);
gulp.task('build', ['build_dev']);

// Build site incrementally (debug only), skip some minification
gulp.task('build_inc', [
    'frontend_dev',
    'jekyll_inc',
    'index_inc']);

// Build site, skip some minification
gulp.task('build_dev', [
    'frontend_dev',
    'jekyll_dev',
    'index_dev']);

// Build site, do all minification
gulp.task('build_deploy', [
    'frontend',
    'jekyll',
    'index']);

// Run test suite
gulp.task('test', ['htmltest', 'jsonlint']);

