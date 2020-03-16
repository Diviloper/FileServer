import 'package:home_file_server/home_file_server.dart';

Future main() async {
  final app = Application<HomeFileServerChannel>()
      ..options.configurationFilePath = './config.yaml';

  await app.start(numberOfInstances: 4);

  print('Application started on port: ${app.options.port}.');
  print('Use Ctrl-C (SIGINT) to stop running the application.');
}
