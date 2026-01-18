import 'dart:io';

class PlaylistRewriter {
  /// Rewrite a playlist file to use helper IP + port for `.ts` chunks
  static Future<void> rewritePlaylist(String playlistPath, String helperIp, int port) async {
    final file = File(playlistPath);
    if (!await file.exists()) return;

    final lines = await file.readAsLines();
    final rewritten = lines.map((line) {
      if (line.trim().endsWith(".ts")) {
        return "http://$helperIp:$port/$line";
      }
      return line;
    }).toList();

    await file.writeAsString(rewritten.join("\n"));
  }
}
