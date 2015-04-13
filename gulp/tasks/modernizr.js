var gulp      = require('gulp');
var modernizr = require('gulp-modernizr');
var pkg       = require('../../package.json');

gulp.task("modernizr", function() {
    return gulp.src(pkg.folders.src + "/vendor/modernizr.js")
        .pipe(modernizr(['touch']))
        .pipe(gulp.dest(pkg.folders.dest+'/js/vendor/'));
});
