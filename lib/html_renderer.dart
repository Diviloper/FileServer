import 'dart:io';

class HTMLRenderer {
  String renderHTML(
    String path,
    Map<String, String> templateVariables,
  ) {
    final template = _loadHTMLTemplate(path);
    return template.replaceAllMapped(RegExp('{{([a-zA-Z_]+)}}'), (match) {
      final key = match.group(1);
      return templateVariables[key] ?? 'null';
    });
  }

  String _loadHTMLTemplate(String path) {
    return File(path).readAsStringSync();
  }
}
