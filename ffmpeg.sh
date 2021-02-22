srcExt=$1
destExt=$2
srcDir=$3
destDir=$4
fadeIn=$5
fadeOut=$6
blackScreen=$7

newfile="$fadeIn-fi_$fadeOut-fo_$blackScreen-black"
mkdir -p "$destDir/$newfile"

for filename in "$srcDir"/*.$srcExt; do
  echo "Fading in/out $filename"
  basePath=${filename%.*}
  baseName=${basePath##*/}
  videoLength=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $filename)
  fadeOutFrom=$(echo "$videoLength - $fadeOut" | bc)
  ffmpeg -n -i "$filename" -vf "fade=t=in:st=0:d=$fadeIn,fade=t=out:st=$fadeOutFrom:d=$fadeOut" -af "afade=t=in:st=0:d=$fadeIn,afade=t=out:st=$fadeOutFrom:d=$fadeOut" -video_track_timescale 24000 "$destDir/$newfile/$baseName.$destExt"
done

echo "Now creating a black screen"
mkdir -p "$destDir/$newfile/tmp"
ffmpeg -n -f lavfi -i color=black:s=1920x1080:r=24000/1001 -f lavfi -i anullsrc -ar 48000 -t $blackScreen "$destDir/$newfile/tmp/black.$destExt"

echo "Starting concatenation of the files in $destDir/$newfile"
absolutePath=$(pwd $PATH)
find "$absolutePath/output/$newfile" -name "*.$srcExt" -maxdepth 1 -print0 | xargs -0 stat -f "file '%N'" | sort | while read line; do
  echo "$line" >> "$destDir/$newfile/files.txt"
  echo "file '$absolutePath/output/$newfile/tmp/black.$destExt'" >> "$destDir/$newfile/files.txt"
done
ffmpeg -y -f concat -safe 0 -i "$destDir/$newfile/files.txt" -c copy "$destDir/$newfile/$newfile.$destExt"
rm "$destDir/$newfile/files.txt"

echo "Done!"
