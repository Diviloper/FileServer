import 'dart:io';

extension ExtendedFile on File {
  String get name => path.replaceAll('\\', '/').substring(path.lastIndexOf('/') + 1);

  String get extension => path.replaceAll('\\', '/').substring(path.lastIndexOf('.') + 1);
}