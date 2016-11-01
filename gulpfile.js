'use strict';

var gulp = require('gulp');
var shell = require('gulp-shell')
var concat = require('gulp-concat')
var sass = require('gulp-sass');
var sourcemaps = require('gulp-sourcemaps');
var postcss = require('gulp-postcss');
var cssnext = require('postcss-cssnext');
var cssnano = require('cssnano');
var coffee = require('gulp-coffee');
var uglify = require('gulp-uglify');

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
        .pipe(sourcemaps.write())
        .pipe(gulp.dest('_site/css'));
}

gulp.task('css', function () { return css({postprocess: true}) });
gulp.task('css_dev', function () { return css({postprocess: false}) });
gulp.task('S_css', ['jekyll'], function () { return css({postprocess: true}) });
gulp.task('S_css_dev', ['jekyll_inc'], function () { return css({postprocess: false}) });

// JS

function js_app() {
    gulp.src('_coffee/app/*.coffee')
        .pipe(sourcemaps.init())
        .pipe(coffee({bare: true}))
        .pipe(concat('app.js'))
        .pipe(uglify())
        .pipe(sourcemaps.write())
        .pipe(gulp.dest('_site/js'));
}

gulp.task('js_app', js_app);
gulp.task('js_app_dev', js_app);
gulp.task('S_js_app', ['jekyll'], js_app);
gulp.task('S_js_app_dev', ['jekyll_inc'], js_app);

function js_scripts() {
    gulp.src('_coffee/scripts/*.coffee')
        .pipe(sourcemaps.init())
        .pipe(coffee({bare: true}))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest('_site/js'));
}

gulp.task('js_scripts', js_scripts);
gulp.task('js_scripts_dev', js_scripts);
gulp.task('S_js_scripts', ['jekyll'], js_scripts);
gulp.task('S_js_scripts_dev', ['jekyll_inc'], js_scripts);

// Search indexes

var CMD_INDEX_SEARCH = 'coffee _coffee/index/search_index_generator.coffee';
var CMD_INDEX_PEOPLE = 'coffee _coffee/index/people_index_generator.coffee';

gulp.task('index_search', shell.task([CMD_INDEX_SEARCH]))
gulp.task('S_index_search', ['jekyll'], shell.task([CMD_INDEX_SEARCH]))
gulp.task('S_index_search_dev', ['jekyll_inc'], shell.task([CMD_INDEX_SEARCH]))

gulp.task('index_people', shell.task([CMD_INDEX_PEOPLE]))
gulp.task('S_index_people', ['jekyll'], shell.task([CMD_INDEX_PEOPLE]))
gulp.task('S_index_people_dev', ['jekyll_inc'], shell.task([CMD_INDEX_PEOPLE]))

// Master tasks

gulp.task('build', ['jekyll',
                     'S_css',
                     'S_js_app',
                     'S_js_scripts',
                     'S_index_search',
                     'S_index_people'])
gulp.task('debug', ['jekyll_inc',
                    'S_css_dev',
                    'S_js_app_dev',
                    'S_js_scripts_dev',
                    'S_index_search_dev',
                    'S_index_people_dev'])

gulp.task('frontend', ['css_dev',
                       'js_app_dev',
                       'js_scripts_dev',
                       'index_search',
                       'index_people'])
