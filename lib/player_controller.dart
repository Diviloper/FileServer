import 'package:home_file_server/home_file_server.dart';
import 'package:home_file_server/utils.dart';

import 'html_renderer.dart';

class PlayerController extends ResourceController {
  final HTMLRenderer renderer = HTMLRenderer();

  @Operation.get()
  Future<Response> getPlayer(@Bind.query('file') String filePath) async {
    final videoFile = File(filePath);
    final String videoType = "video/${videoFile.extension == 'mkv' ? 'mp4' : videoFile.extension}";
    final subtitles = videoFile.fromWithExtension('vtt');
    final subtitlesHTML = subtitles.existsSync()
        ? '<track src="${subtitles.path}" kind="subtitles" srclang="en" label="English">'
        : '';
    return Response.ok(renderer.renderHTML(
        "web/player.html", {'file': filePath, 'type': videoType, 'tracks': subtitlesHTML}))
      ..contentType = ContentType.html;
  }
}
