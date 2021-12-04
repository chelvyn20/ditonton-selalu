import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  if (dir.endsWith('core')) {
    var dire = '$dir/test/$name';
    print(dire);
    return File('$dir/test/$name').readAsStringSync();
  }
  var dire = '$dir/core/test/$name';
  print(dire);
  return File('$dir/core/test/$name').readAsStringSync();
}
