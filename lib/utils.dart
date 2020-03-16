import 'dart:io';

extension ExtendedFile on File {
  String get name {
    final replaced = path.replaceAll(r'\', '/');
    return replaced.substring(replaced.lastIndexOf('/') + 1);
  }

  String get extension => path.substring(path.lastIndexOf('.') + 1);

  File fromWithExtension(String extension) =>
      File('${path.substring(0, path.lastIndexOf('.'))}.$extension');
}
