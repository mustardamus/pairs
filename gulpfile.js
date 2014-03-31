var gulp       = require('gulp');
var stylus     = require('gulp-stylus');
var connect    = require('gulp-connect');
var coffee     = require('gulp-coffee');
var browserify = require('gulp-browserify');
var concat     = require('gulp-concat');
var include    = require('gulp-include');
var uglify     = require('gulp-uglify');
var csso       = require('gulp-csso');
var imagemin   = require('gulp-imagemin');

gulp.task('stylus', function() {
  gulp
    .src('./app/styles/**/*.styl')
    .pipe(stylus())
    .pipe(csso())
    .pipe(gulp.dest('./public/styles/'))
    .pipe(connect.reload());
});

gulp.task('vendor-css', function() {
  gulp
    .src(['./app/styles/*.css', './app/styles/**/*.css'])
    .pipe(include())
    .pipe(csso())
    .pipe(gulp.dest('./public/styles/'))
    .pipe(connect.reload());
});

gulp.task('coffee', function() {
  gulp
    .src('./app/scripts/desktop/desktop.coffee', { read: false })
    .pipe(browserify({
      transform: ['coffeeify'],
      extensions: ['.coffee']
    }))
    .pipe(concat('desktop.js'))
    //.pipe(uglify())
    .pipe(gulp.dest('./public/scripts/'))
    .pipe(connect.reload());

  gulp
    .src('./app/scripts/remote/remote.coffee', { read: false })
    .pipe(browserify({
      transform: ['coffeeify'],
      extensions: ['.coffee']
    }))
    .pipe(concat('remote.js'))
    .pipe(uglify())
    .pipe(gulp.dest('./public/scripts/'))
    .pipe(connect.reload());
});

gulp.task('vendor-js', function() {
  gulp
    .src(['./app/scripts/*.js', './app/scripts/**/*.js'])
    .pipe(include())
    .pipe(uglify())
    .pipe(gulp.dest('./public/scripts/'));
});

gulp.task('copy-html', function() {
  gulp
    .src('./app/*.html')
    .pipe(gulp.dest('./public/'))
    .pipe(connect.reload());
});

gulp.task('copy-fonts', function() {
  gulp
    .src('./app/bower_components/font-awesome/fonts/*')
    .pipe(gulp.dest('./public/fonts/'));

  gulp
    .src('./app/bower_components/semantic/build/uncompressed/fonts/*')
    .pipe(gulp.dest('./public/fonts/'));
});

gulp.task('copy-images', function() {
  gulp
    .src('./app/images/*')
    .pipe(imagemin())
    .pipe(gulp.dest('./public/images/'));

  gulp
    .src('./app/bower_components/supersized/core/img/*')
    .pipe(imagemin())
    .pipe(gulp.dest('./public/img/'));
});

gulp.task('build',
  ['copy-html', 'stylus', 'coffee', 'vendor-js', 'vendor-css', 'copy-fonts', 'copy-images']
);

gulp.task('watch', function() {
  gulp.watch('./app/*.html', ['copy-html']);
  gulp.watch(['./app/styles/desktop/*.styl', './app/styles/remote/*.styl'], ['stylus']);
  gulp.watch('./app/styles/vendor.css', ['vendor-css']);
  gulp.watch('./app/scripts/**/*', ['coffee']);
  gulp.watch('./app/scripts/vendor.js', ['vendor-js']);
  gulp.watch('./app/images/*', ['copy-images']);
});

gulp.task('server', ['build', 'watch'], connect.server({
  root: ['public'],
  port: 9000,
  livereload: {
    port: 31329
  }
}));

gulp.task('test-build', ['build'], function() {
  gulp
    .src('./test/suite/index.html')
    .pipe(gulp.dest('./tmp/test/'));

  gulp
    .src('./public/scripts/vendor.js')
    .pipe(gulp.dest('./tmp/test/'));

  gulp
    .src('./public/styles/vendor.css')
    .pipe(gulp.dest('./tmp/test/'));

  gulp
    .src('./public/scripts/main.js')
    .pipe(gulp.dest('./tmp/test/'));

  gulp
    .src('./public/styles/main.css')
    .pipe(gulp.dest('./tmp/test/'));

  gulp
    .src('./test/suite/test-vendor.css')
    .pipe(include())
    .pipe(gulp.dest('./tmp/test/'));

  gulp
    .src('./test/suite/test-vendor.js')
    .pipe(include())
    .pipe(gulp.dest('./tmp/test/'));

  gulp
    .src('./test/specs.coffee', { read: false })
    .pipe(browserify({
      transform: ['coffeeify'],
      extensions: ['.coffee']
    }))
    .pipe(concat('spec.js'))
    .pipe(gulp.dest('./tmp/test/'))
    .pipe(connect.reload());
});

gulp.task('test-watch', ['watch'], function() {
  gulp.watch('./test/specs/**/*', ['test-build']);
});

gulp.task('test-server', ['test-build', 'test-watch'], connect.server({
  root: ['tmp/test'],
  port: 9001,
  livereload: {
    port: 31630
  }
}));

gulp.task('default', ['server']);