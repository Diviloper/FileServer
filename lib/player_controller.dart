import 'package:home_file_server/home_file_server.dart';
import 'package:home_file_server/utils.dart';

import 'html_renderer.dart';

class PlayerController extends ResourceController {
  final HTMLRenderer renderer = HTMLRenderer();

  @Operation.get()
  Future<Response> getPlayer(
      @Bind.query('file') String filePath) async {
    final File videoFile = File(filePath);
    final String videoType =
        "video/${videoFile.extension == 'mkv' ? 'mp4' : videoFile.extension}";
    return Response.ok(renderer
        .renderHTML("web/player.html", {'file': filePath, 'type': videoType}))
      ..contentType = ContentType.html;
  }
}
