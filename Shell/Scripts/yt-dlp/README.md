# YT-DLP Usage Examples

### Options
- `--cookies <file_path>`: Use cookies if YT DLP can't fetch videos.
- `--no-playlist`: If there is a video and a playlist, then only video is going to be selected.
- `--list-formats`: List all formats.
- `-o, --output "%(title)s.%(ext)s"`: Use template to give the name that you want.
- `-I, --playlist-items "[START]:[STOP][:STEP]"`: Download specific items.
- `--print <template or keyword>`: Print the details that you want before downloading or doing something.
- `--skip-download`: Not going to download any video.

### Playlist
```bash
yt-dlp --output "%(playlist_title)s/%(title)s.%(ext)s" -f "bv[height<=1080]+ba" --cookies-from-browser firefox <Playlist_URL>
```

### Video
```bash
yt-dlp --no-playlist --output "%(title)s.%(ext)s" -f "bv[height<=1080]+ba" --cookies-from-browser firefox <Video_URL>
```

### Video with subtitles
```bash
yt-dlp --no-playlist --write-auto-subs --sub-langs en --embed-subs --output "%(title)s.%(ext)s" -f "bv[height<=1080]+ba" --cookies-from-browser firefox <Video_URL>
```

### Print title
```bash
yt-dlp --skip-download --print title <Video_URL>
```
