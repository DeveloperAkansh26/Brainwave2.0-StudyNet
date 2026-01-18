import 'dart:io';

class LocalServer {
  HttpServer? _server;

  /// Start a local HTTP server serving HLS files
  Future<void> startServer(String hlsFolderPath, {int port = 8080}) async {
    _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    print("✅ Local server running on http://${_server!.address.address}:$port");

    await for (HttpRequest request in _server!) {
      try {
        // Normalize the requested path
        final relativePath = request.uri.path.replaceFirst('/', '');
        final file = File('$hlsFolderPath/$relativePath');

        if (await file.exists()) {
          // Add CORS headers for cross-device playback
          request.response.headers
              .add('Access-Control-Allow-Origin', '*');
          request.response.headers
              .add('Access-Control-Allow-Methods', 'GET');

          // Set correct MIME types
          if (file.path.endsWith(".m3u8")) {
            request.response.headers.contentType =
                ContentType("application", "vnd.apple.mpegurl");
          } else if (file.path.endsWith(".ts")) {
            request.response.headers.contentType =
                ContentType("video", "mp2t"); // lowercase is safer
          } else if (file.path.endsWith(".json")) {
            request.response.headers.contentType = ContentType.json;
          } else {
            request.response.headers.contentType = ContentType.binary;
          }

          await request.response.addStream(file.openRead());
        } else {
          request.response.statusCode = HttpStatus.notFound;
          request.response.write("File not found: $relativePath");
        }
      } catch (e) {
        request.response.statusCode = HttpStatus.internalServerError;
        request.response.write("Server error: $e");
      } finally {
        await request.response.close();
      }
    }
  }

  /// Stop the server
  void stopServer() {
    _server?.close(force: true);
    _server = null;
    print("Local server stopped");
  }
}
