### '--cookies <file_path>', use cookies if YT DLP can't fetch videos
### '--no-playlist', if there is a video and a playlist, then only video is going to be selected
### '--list-formats', list all formats
### '-o, --output "%(title)s.%(ext)s"', use template to give the name that you want
### '-I, --playlist-items "[START]:[STOP][:STEP]"', download specific items
### '--print <template or keyword>', print the details that you want before downloading or doing something
### '--skip-download', not going to download any video

### Playlist ###
yt-dlp --output "%(playlist_title)s/%(title)s.%(ext)s" -f "bv[height<=1080]+ba" --cookies-from-browser firefox "https://www.youtube.com/playlist?list=PLYdSUCkqdg67qnz3MEo0NsaM65HjAKsIm"

### Video ###
yt-dlp --no-playlist --output "%(title)s.%(ext)s" -f "bv[height<=1080]+ba" --cookies-from-browser firefox "https://www.youtube.com/watch?v=eYctE_enPkk&list=PLYdSUCkqdg67qnz3MEo0NsaM65HjAKsIm"

### Video with subtitles ###
yt-dlp --no-playlist --write-auto-subs --sub-langs en --embed-subs --output "%(title)s.%(ext)s" -f "bv[height<=1080]+ba" --cookies-from-browser firefox <Video_URL>

### Print title ###
yt-dlp --skip-download --print title "https://www.youtube.com/watch?v=xXHc_lH8-yU"
