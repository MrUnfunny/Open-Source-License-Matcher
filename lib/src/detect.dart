import 'dart:io';

import 'package:sample_license_matcher/src/match/match.dart';
import 'package:sample_license_matcher/src/match/models.dart';

import 'match/models.dart';

/// Takes directory path and threshold value as input. Threshold value
/// defaults to 0.9 if it's not provided.Threshold must be between 0 and 1.
///  Checks for a file named LICENSE in given root directory.
///  If file is not present, throws an exception.
List<Match> detectFromDirectory(String path, [threshold = 0.9]) {
  try {
    final dir = Directory(path).listSync().toList();

    if (threshold < 0 || threshold > 1) {
      throw Exception('Threshold value must lie between 0 and 1');
    }

    var licFile = dir.firstWhere((element) => element.path.endsWith('LICENSE'),
        orElse: () {
      print('Input project does not contain a file named LICENSE');
      exit(0);
    });
    return detectFromFile(licFile.path, threshold);
  } on FileSystemException {
    print('Given path $path is invalid');
    exit(0);
  }
}

/// Takes file path and threshold value as input. Threshold value
/// defaults to 0.9 if it's not provided. Threshold must be between 0 and 1.
List<Match> detectFromFile(String path, [threshold = 0.9]) {
  try {
    final file = File(path);
    final text = file.readAsStringSync();

    if (threshold < 0 || threshold > 1) {
      print('Threshold value must lie between 0 and 1');
      exit(0);
    }

    return match(text, threshold);
  } on FileSystemException {
    print('Given path "$path" is invalid');
    exit(1);
  }
}

/// Takes target text and threshold value as input. Threshold value
/// defaults to 0.9 if it's not provided. Threshold must be between 0 and 1.
List<Match> detectFromString(String text, [threshold = 0.9]) {
  if (threshold < 0 || threshold > 1) {
    print('Threshold value must lie between 0 and 1');
    exit(0);
  }

  return match(text, threshold);
}
