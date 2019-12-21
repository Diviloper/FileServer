import 'package:home_file_server/home_file_server.dart';
import 'package:home_file_server/html_renderer.dart';

class FileListController extends Controller {
  final HTMLRenderer renderer = HTMLRenderer();

  @override
  Future<RequestOrResponse> handle(Request request) async {
    final String dir = request.raw.uri.queryParameters['dir'] ?? '/files';
    final Directory fileDir = Directory(dir);
    String fileListHTML = dir == '/files'
        ? ""
        : renderer.renderHTML(
            "web/dirEntry.html",
            {
              'dirName': '..',
              'dirPath': dir.substring(0, dir.lastIndexOf('/'))
            },
          );
    for (final entry in fileDir.listSync(followLinks: false)) {
      if (entry is Directory) {
        fileListHTML += renderer.renderHTML(
          "web/dirEntry.html",
          {
            'dirName': entry.path.substring(entry.path.lastIndexOf('/') + 1),
            'dirPath': entry.path,
          },
        );
      } else if (entry is File) {
        fileListHTML += renderer.renderHTML(
          "web/entry.html",
          {'filePath': entry.path,
            'fileName': entry.path.substring(entry.path.lastIndexOf('/') + 1)},
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
