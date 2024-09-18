from urllib.parse import urlparse

def get_id(url):
    path = urlparse(url).path
    arr = path.split('/')
    id = None

    if path.startswith('/shorts'): id = arr[2]
    elif path.startswith('/live'): id = arr[2]
    else: id = arr[1]

    if id.startswith('@') or id == 'channel': return 'Please give video URL. Not channel URL.'

    return id
