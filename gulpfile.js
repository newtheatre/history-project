'use strict';

var gulp = require('gulp');
var sass = require('gulp-sass');
var sourcemaps = require('gulp-sourcemaps');
var postcss = require('gulp-postcss');
var cssnext = require('postcss-cssnext');
var cssnano = require('cssnano');

gulp.task('css', function () {
    var processors = [
        cssnext(),
        cssnano({autoprefixer: false}),
    ];
    return gulp.src('_sass/main.sass')
        .pipe(sourcemaps.init())
        .pipe(sass().on('error', sass.logError))
        // .pipe(postcss(processors))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest('_site/css'));
});
