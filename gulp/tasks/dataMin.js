var gulp       = require('gulp');
var prettyData = require('gulp-pretty-data');
var pkg        = require('../../package.json');

gulp.task('dataMin', function() {
  gulp.src(pkg.folders.src+'/data/**/*.*')
    // .pipe(prettyData({type: 'minify', preserveComments: false}))
    .pipe(gulp.dest(pkg.folders.dest+'/static/data'))
});
