import 'package:sample_license_matcher/sample_license_matcher.dart';
import 'package:test/test.dart';

const LicenseData = {
  'test/test_data/flutter_license': 'BSD-3-Clause',
  'test/test_data/afl': 'AFL-3',
  'test/test_data/mit': 'MIT',
};

void main() {
  group('Group of License Detection tests', () {
    for (var testData in LicenseData.keys) {
      test(
          '${testData.split('/').last} must be equal to ${LicenseData[testData]}',
          () {
        expect(
          detectFromFile(testData).first.name,
          equals(LicenseData[testData]),
        );
      });
    }
  });
}
