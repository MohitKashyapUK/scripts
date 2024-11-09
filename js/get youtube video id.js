function get_video_id(url) {
  const uri = new URL(url);
  const path = uri.pathname;
  const params = uri.searchParams;
  const v = params.get("v");

  if (v) return v;
  else if (path.startsWith("/live")) return path.slice(6);
  else if (path.startsWith("/shorts")) return path.slice(8);
  else return path.slice(1);
}
