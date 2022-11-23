import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  if (dir.endsWith('feature_movie')) {
    return File('$dir/test/$name').readAsStringSync();
  }
  return File('$dir/modules/feature_movie/test/$name').readAsStringSync();
}
