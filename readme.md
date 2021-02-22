# Install ffmpeg

Make sure ffmpeg is installed

## On Mac OS

`brew install ffmpeg`

# Usage

Script will take a few inputs

- `srcExt` is the source extension of files you are looking for in `srcDir`
- `destExt` is the destination of the final video you are creating
- `srcDir` is the source directory where to look for the original video files
- `destDir` is the destination directory where the output files will be
- `fadeIn` is the fade in effect in seconds
- `fadeOut` is the fade out effect in seconds
- `blackScreen` is the number of seconds of of black between 2 videos

Here is an example command :

`bash ffmpeg.sh mp4 mp4 ./src ./output 2 3 1`

This will concatenate all files in the `./src` folder, *fade in* audio and video for 2 seconds, *fade out* audio and video for 3 seconds, add a black screen between each videos for 1 second. Output will be located in a new directory inside `./output/X-fi_Y-fo_Z-black` where `X = fadeIn`, `Y = fadeOut`, and `Z = blackScreen`.

If you run the command multiple times, the existing files will not be re-encoded.

If you want to re-encode different files, please use another directory or remove existing files.
