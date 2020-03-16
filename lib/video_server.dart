import 'dart:math';
import 'dart:typed_data';

import 'package:home_file_server/home_file_server.dart';
import 'package:home_file_server/utils.dart';

class VideoServer extends ResourceController {
  static final _rangeHeaderRegExp = RegExp(r'([a-zA-Z]*)=(\d*)-(\d*)');
  static final _loadedVideos = <String, Uint8List>{};
  static final _loadedVideosTimes = <String, Timer>{};

  @Operation.get()
  Future<Response> getVideo({@Bind.header('Range') String rangeHeader}) async {
    final fileName = request.path.remainingPath;
    final videoBytes = _getOrLoadVideo(fileName);
    final videoLength = videoBytes.lengthInBytes;
    if (rangeHeader == null) {
      return Response.ok(
        videoBytes,
        headers: <String, dynamic>{
          'Accept-Ranges': 'bytes',
          'Content-Length': videoLength,
        },
      );
    }
    final matches = _rangeHeaderRegExp.allMatches(rangeHeader);
    final unit = matches.single.group(1);
    int start = int.tryParse(matches.single.group(2));
    int end = int.tryParse(matches.single.group(3));
    if (start == null && end != null) {
      start = videoLength - end;
      end = videoLength;
    } else if (start != null && end == null) {
      end = min(start + 4194304, videoLength);
    }
    _checkValues(unit, start, end, videoLength);
    final videoFragment = videoBytes.sublist(start, end);
    return Response(
        206,
        <String, dynamic>{
          'Content-Range': 'bytes $start-${end - 1}/$videoLength',
          'Content-Length': videoFragment.lengthInBytes,
          'Accept-Ranges': 'bytes',
          'Cache-Control': 'no-cache',
        },
        videoFragment)
      ..contentType = ContentType('video', fileName.substring(fileName.lastIndexOf('.') + 1));
  }

  static void _removeVideoData(String videoName) {
    _loadedVideos.remove(videoName);
    _loadedVideosTimes.remove(videoName);
  }

  static void _updateTimer(String fileName) {
    _loadedVideosTimes[fileName]?.cancel();
    _loadedVideosTimes[fileName] = Timer(
      const Duration(minutes: 30),
      () => _removeVideoData(fileName),
    );
  }

  static Uint8List _getOrLoadVideo(String fileName) {
    if (_loadedVideos.containsKey(fileName)) {
      _updateTimer(fileName);
      return _loadedVideos[fileName];
    } else {
      final videoFile = File(fileName);
      if (!videoFile.existsSync()) {
        throw Response.notFound();
      } else if (!['mp4', 'webm', 'ogg'].contains(videoFile.extension)) {
        throw Response.badRequest(body: 'File is not a video or it is an unsupported video');
      }
      final videoBytes = videoFile.readAsBytesSync();
      _loadedVideos[fileName] = videoBytes;
      _updateTimer(fileName);
      return videoBytes;
    }
  }

  void _checkValues(String unit, int start, int end, int videoLength) {
    if (unit != 'bytes' ||
        (start == null && end == null) ||
        start > videoLength ||
        end > videoLength) {
      throw Response(
          416,
          <String, dynamic>{
            'Accept-Ranges': 'bytes',
            'Content-Range': 'bytes */$videoLength',
          },
          null);
    }
  }
}
