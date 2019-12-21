import 'package:home_file_server/file_list_controller.dart';

import 'home_file_server.dart';

class HomeFileServerChannel extends ApplicationChannel {
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route("/").link(() => FileListController());
    router.route("/files/*").link(() => FileController("/files/"));
    router.route("/web/*").link(() => FileController("web/"));

    return router;
  }
}
