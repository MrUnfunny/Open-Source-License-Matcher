import 'package:sample_license_matcher/sample_license_matcher.dart';

import 'license.dart';

void main() {
  var multiMatches = detectFromString(MultiLicenseText, 0.94);
  var singleMatches = detectFromString(SingleLicenseText, 0.94);

  print('\n---------SINGLE LICENSE MATCH RESULTS---------\n');
  for (var match in singleMatches) {
    print(match);
  }
  print('\n---------MULTIPLE LICENSE MATCH RESULTS---------\n');
  for (var match in multiMatches) {
    print(match);
  }
}
