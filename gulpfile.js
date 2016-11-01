var gulp = require('gulp');
var postcss = require('gulp-postcss');
var cssnext = require('postcss-cssnext');
var cssnano = require('cssnano');

require('es6-promise').polyfill();

gulp.task('css', function () {
    var processors = [
        cssnext(),
        cssnano({autoprefixer: false}),
    ];
    return gulp.src('./_site/css/*.css', {base: './'})
        .pipe(postcss(processors))
        .pipe(gulp.dest('.'));
});
