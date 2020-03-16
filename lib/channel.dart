import 'package:home_file_server/file_list_controller.dart';
import 'package:home_file_server/player_controller.dart';
import 'package:home_file_server/video_server.dart';

import 'home_file_server.dart';

class HomeFileServerChannel extends ApplicationChannel {
  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route('/').linkFunction(_registerIP).link(() => FileListController());
    router.route('/player').linkFunction(_registerIP).link(() => PlayerController());
    router.route('/files/*').linkFunction(_registerIP).link(() =>
        FileController('E:/FileServer/')..setContentTypeForExtension('vtt', ContentType('text', 'vtt')));
    router.route('/video/*').linkFunction(_registerIP).link(() => VideoServer());
    router.route('/web/*').linkFunction(_registerIP).link(() => FileController('web/'));
    return router;
  }

  Request _registerIP(Request request) {
    final info = request.raw.connectionInfo;
    logger.info('${info.remoteAddress.type.name} - ${info.remoteAddress.host} '
        '${info.remoteAddress.address}:${info.remotePort}');
    return request;
  }
}
