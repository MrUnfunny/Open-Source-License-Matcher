This file can be used to run this project from command line.

## USAGE

Currently, this only supports two flags --file and --dir to detect License from file and directory paths respectively and only one flag can be used at a time.

To detect License from a file path, use

```dart
dart bin/license_matcher.dart --file <file_path>
```

To detect License from a Directory path, use

```dart
dart bin/license_matcher.dart --dir <dir_path>
```

The confidence value is set to 0.95 and cannot be changed from command line for now.
