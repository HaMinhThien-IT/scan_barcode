class GetIconWeb {
  get(String link) {
    return 'https://t3.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=${link}/&size=24';
  }
}

final getIconWeb = GetIconWeb();
