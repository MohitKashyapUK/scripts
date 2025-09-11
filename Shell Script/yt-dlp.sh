### '--cookies <file_path>', use cookies if YT DLP can't fetch videos
### '--no-playlist', if there is a video and a playlist, then only video is going to be selected
### '--list-formats', list all formats
### '-o, --output "%(title)s.%(ext)s"', use template to give the name that you want
### '-I, --playlist-items "[START]:[STOP][:STEP]"', download specific items
### '--print <template or keyword>', print the details that you want before downloading or doing something
### '--skip-download', not going to download any video

yt-dlp --quiet --console-title --progress --no-warnings --output "%(playlist_title)s/%(title)s.%(ext)s" -f "bv[height<=1080]+ba" --print "%(playlist_index)s. %(title)s" "https://www.youtube.com/playlist?list=PLYdSUCkqdg67qnz3MEo0NsaM65HjAKsIm"
yt-dlp --quiet --console-title --progress --no-warnings --no-playlist --output "%(title)s.%(ext)s" -f "bv[height<=1080]+ba" --print "%(playlist_index)s. %(title)s" "https://www.youtube.com/watch?v=eYctE_enPkk&list=PLYdSUCkqdg67qnz3MEo0NsaM65HjAKsIm"
yt-dlp --skip-download --print title "https://www.youtube.com/watch?v=xXHc_lH8-yU"
