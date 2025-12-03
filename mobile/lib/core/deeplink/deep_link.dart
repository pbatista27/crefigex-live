class DeepLink {
  static String initialRoute = '/';
  static Object? initialArgs;

  static void parseFromUri(Uri uri) {
    initialRoute = '/';
    initialArgs = null;
    final segments = uri.pathSegments;
    if (segments.length >= 2 && segments[0].toLowerCase() == 'video') {
      initialRoute = '/video';
      initialArgs = segments[1];
      return;
    }
    // Support query param ?video_id=xyz
    final videoId = uri.queryParameters['video_id'] ?? uri.queryParameters['videoId'];
    if (videoId != null && videoId.isNotEmpty) {
      initialRoute = '/video';
      initialArgs = videoId;
    }
  }
}
