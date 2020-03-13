import 'package:home_file_server/file_list_controller.dart';
import 'package:home_file_server/player_controller.dart';

import 'home_file_server.dart';

class HomeFileServerChannel extends ApplicationChannel {
  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route("/").link(() => FileListController());
    router.route("/player").link(() => PlayerController());
    router.route("/files/*").link(() =>
        FileController("/files/")..setContentTypeForExtension('vtt', ContentType('text', 'vtt')));
    router.route("/web/*").link(() => FileController("web/"));

    return router;
  }
}
