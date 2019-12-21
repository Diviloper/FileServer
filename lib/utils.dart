import 'dart:io';

extension ExtendedFile on File {
  String get name => path.substring(path.lastIndexOf('/') + 1);

  String get extension => path.substring(path.lastIndexOf('.') + 1);
}