# Start gulp
gulp = require 'gulp'
# Load automatically all declared plugin from the package.json
p = require('gulp-load-plugins')
  # The glob(s) for searching plugins
  pattern: ['gulp-*', 'gulp.*']
  # Plugins are extracted from the regular package.json (default)
  #config: 'package.json'
  # Get plugins from all gulp's keys
  scope: ['dependencies', 'devDependencies', 'peerDependencies']
  # Removal pattern for shortening package's name
  replaceString: /^gulp(-|\.)/
  # Transform package's name using a camel case convention
  camelize: true
  # Lazy load packages: they are loaded on demand
  lazy: true
  # Mapping for renaming plugins
  rename: {}
# PNG quantization
pngquant = require 'imagemin-pngquant'

# Distribution folders
videoDist = '../app/public/videos/'
imgDist = '../app/public/img/'
faviconsDist = '../app/public/'

# Video compression
# ffmpeg -y -i $videoIn -vcodec libx264 -preset veryslow -an -f mp4 $videoOut
gulp.task 'video', ->
  gulp.src 'src/l*.mp4'
    .pipe p.fluentFfmpeg (cmd) ->
      cmd
        .videoCodec('libx264')
        .noAudio()
        .format('avi')
        .outputOptions(['-preset', 'veryslow', '-an'])
    .pipe gulp.dest imgDist

# Copy plain images
gulp.task 'copy', ->
  gulp.src 'src/*.jpg'
    .pipe gulp.dest imgDist

# Resize images
gulp.task 'resize-medium', ['copy'], ->
  gulp.src 'src/*.jpg'
    .pipe p.imageResize width: 800
    .pipe p.rename (path) -> path.basename += '-medium'
    .pipe gulp.dest imgDist
gulp.task 'resize-small', ['copy'], ->
  gulp.src 'src/*.jpg'
    .pipe p.imageResize width: 320
    .pipe p.rename (path) -> path.basename += '-small'
    .pipe gulp.dest imgDist

# Optimize images
gulp.task 'imagemin', ['resize-medium', 'resize-small'], ->
  gulp.src "#{imgDist}/*.{jpg,png,gif,svg}"
    .pipe p.imagemin
      progressive: true
      svgoPlugins: [{removeViewBox: false}]
      use: [pngquant()]
    .pipe gulp.dest imgDist

# Create all webp images
gulp.task 'webp', ['imagemin'], ->
  gulp.src "#{imgDist}/*.jpg"
    .pipe p.webp()
    .pipe gulp.dest imgDist

# Default task call every tasks created so far
gulp.task 'default', ['video']
