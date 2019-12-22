import 'package:home_file_server/home_file_server.dart';
import 'package:home_file_server/html_renderer.dart';
import 'package:home_file_server/utils.dart';

class FileListController extends ResourceController {
  final HTMLRenderer renderer = HTMLRenderer();

  @Operation.get()
  Future<Response> getFileList(
      {@Bind.query('dir') String dir = '/files'}) async {
    final Directory fileDir = Directory(dir);
    String fileListHTML = dir == '/files' ||
            RegExp(r'^[A-Z]:$').hasMatch(dir) ||
            !fileDir.parent.existsSync()
        ? ""
        : renderer.renderHTML(
            "web/dirEntry.html",
            {
              'dirName': '..',
              'dirPath': dir.substring(0, dir.lastIndexOf('/'))
            },
          );
    for (final entry in fileDir.listSync(followLinks: false)) {
      final String path = entry.path.replaceAll('\\', '/');
      if (entry is Directory) {
        fileListHTML += renderer.renderHTML(
          "web/dirEntry.html",
          {
            'dirName': path.substring(entry.path.lastIndexOf('/') + 1),
            'dirPath': path,
          },
        );
      } else if (entry is File) {
        final String onClick = "window.location = '${path}'";
        fileListHTML += renderer.renderHTML(
          "web/entry.html",
          {'onClick': onClick, 'fileName': entry.name},
        );
      }
    }
    final String page = renderer.renderHTML(
      "web/menu.html",
      {'fileList': fileListHTML, 'dirName': dir},
    );
    return Response.ok(page)..contentType = ContentType.html;
  }
}
