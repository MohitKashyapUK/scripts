# YT-DLP Usage Examples

### Options
- `--cookies <file_path>`: Use cookies if YT DLP can't fetch videos.
- `--no-playlist`: If there is a video and a playlist, then only the video is going to be selected.
- `-F`, `--list-formats`: List all formats.
- `-o, --output "%(title)s.%(ext)s"`: Use template to give the name that you want.
- `-I, --playlist-items "[START]:[STOP][:STEP]"`: Download specific items.
- `--print <template or keyword>`: Print the details that you want before downloading or doing something.
- `--skip-download`: Not going to download any video.
- `-f`, `--format`: Choose resolution

### Playlist
```bash
yt-dlp --embed-chapters --output "%(playlist_title)s/%(title)s.%(ext)s" --format "bv[height=720]+ba" --cookies-from-browser firefox <Playlist_URL>
```

### Playlist with subtitle
```bash
yt-dlp --embed-chapters --output "%(playlist_title)s/%(title)s.%(ext)s" --format "bv[height=720]+ba" --write-auto-subs --embed-subs --sub-langs en --cookies-from-browser firefox <Playlist_URL>
```

### Video
```bash
yt-dlp --embed-chapters --no-playlist --output "%(title)s.%(ext)s" --format "bv[height=720]+ba" --cookies-from-browser firefox <Video_URL>
```

### Video with subtitles
```bash
yt-dlp --embed-chapters --no-playlist --output "%(title)s.%(ext)s" --format "bv[height=720]+ba" --write-auto-subs --embed-subs --sub-langs en --cookies-from-browser firefox <Video_URL>
```

### Print title
```bash
yt-dlp --skip-download --print title <Video_URL>
```


*Use this option to get FHD video. Make sure you choose the right codec, otherwise the video will lag.*
```bash
... --format "b[height<=1080][vcodec!=vp9]" ...
... --format "bv[height<=1080][vcodec!=vp9]+ba" ...
```
