import 'dart:io';
import 'package:sample_license_matcher/sample_license_matcher.dart';
import 'package:sample_license_matcher/src/match/models.dart';

/// text colors for coloredPrint
enum TextColor { red, blue, green, white }

extension on TextColor {
  /// returns ansi code for Text Color in coloredPrint
  String get code {
    switch (this) {
      case (TextColor.red):
        return '\x1B[31m';

      case (TextColor.blue):
        return '\x1B[34m';

      case (TextColor.green):
        return '\x1B[32m';
      default:
        return '';
    }
  }
}

/// prints colored string in Console
void coloredPrint(String text, TextColor color, [bool lineBreak = false]) {
  lineBreak
      ? print(color.code + text + '\x1B[0m')
      : stdout.write(color.code + text + '\x1B[0m');
}

void main(List<String> args) {
  if (args.isEmpty) {
    coloredPrint(
        'no inputs found \nuse --file followed by file path or --dir followed by directory path to get matched license.',
        TextColor.red,
        true);
    exit(0);
  }
  if (args.length != 2) {
    coloredPrint(
        'Invalid input \nPlease use exactly 1 flag', TextColor.red, true);
    exit(1);
  }

  var res = <Match>[];
  if (args.first == '--file') {
    coloredPrint('fetching license', TextColor.green, true);
    res = detectFromFile(args.last, 0.95);
  } else if (args.first == '--dir') {
    coloredPrint('fetching license', TextColor.green, true);
    res = detectFromDirectory(args.last, 0.95);
  } else {
    coloredPrint(
        'Invalid flags\nPlease use --file followed by file path or --dir followed by directory path to get matched license.',
        TextColor.red,
        true);
    exit(2);
  }

  if (res.isEmpty) {
    coloredPrint('No match found', TextColor.red, true);
    exit(3);
  } else {
    res.forEach((match) {
      print(match);
    });
  }
}
