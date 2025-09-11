### '--cookies <file_path>', use cookies if YT DLP can't fetch videos
### '--no-playlist', if there is a video and a playlist, then only video is going to be selected
### '--list-formats', list all formats
### '-o, --output "%(title)s.%(ext)s"', use template to give the name that you want
### '-I, --playlist-items "[START]:[STOP][:STEP]"', download specific items
### '--print <template or keyword>', print the details that you want before downloading or doing something
### '--skip-download', not going to download any video

yt-dlp --console-title --progress --no-warnings --quiet --output "%(title)s.%(ext)s" -f "bv[height<=1080]+ba" --print "%(playlist_index)s. %(title)s" <url>
yt-dlp --skip-download --print title <url>
