import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  if (dir.endsWith('search')) {
    var dire = '$dir/test/$name';
    print(dire);
    return File('$dir/test/$name').readAsStringSync();
  }
  var dire = '$dir/search/test/$name';
    print(dire);
  return File('$dir/search/test/$name').readAsStringSync();
}
