import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/playlist_rewriter..dart';

class HlsDownloader {
  final supabase = Supabase.instance.client;

  /// Download all files in the HLS folder from Supabase to local storage
  Future<String> downloadHlsFolder(String bucket, String folder) async {
    // 1. Pick local cache directory
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String localPath = "${appDir.path}/hls_cache";
    final Directory cacheDir = Directory(localPath);

    if (!cacheDir.existsSync()) {
      cacheDir.createSync(recursive: true);
    }

    // 2. List files in Supabase folder
    final files = await supabase.storage.from(bucket).list(path: folder);

    for (final file in files) {
      final String filePath = "$folder/${file.name}";
      final String localFilePath = "$localPath/${file.name}";

      final File localFile = File(localFilePath);
      if (localFile.existsSync()) {
        print("Skipping ${file.name}, already downloaded.");
        continue;
      }

      print("Downloading ${file.name}...");
      final response = await supabase.storage.from(bucket).download(filePath);
      await localFile.writeAsBytes(response);
    }

    print("✅ All files downloaded to $localPath");
    // get helper IP
final helperIp = await Supabase.instance.client.auth.currentUser?.id ?? "127.0.0.1";

// Rewrite all playlists
for (final file in files) {
  if (file.name.endsWith(".m3u8")) {
    await PlaylistRewriter.rewritePlaylist("$localPath/${file.name}", helperIp, 8080);
  }
}

    return localPath;
  }
}
