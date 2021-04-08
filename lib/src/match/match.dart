import 'dart:io';
import 'dart:math';

import 'package:string_similarity/string_similarity.dart';

import '../utils/normalize.dart';
import 'matcher.dart';
import 'models.dart';

const licensePath = 'licenses';

//Returns the final list of source licenses that matched with the target text.
List<Match> match(String targetText, double threshold) {
  var res = <Match>[];

  // length of each gram of token range used for matching
  var q = (threshold.floor() == 1)
      ? 10
      : max(1, ((threshold) / (1.0 - threshold)).floor());

  var l = normalize(targetText);
  var tgt = tokenize(l);
  var tgtSs = generateSearchSet(tgt, l, q);

  var source = getPotentialMatches(generateFreq(tgt), threshold, q);

  source.forEach((element) {
    var matchRange = getMatchRange(element, tgtSs, threshold);

    if (matchRange == null) {
      return;
    }

    var con = element.tokens.join(' ').similarityTo(tgtSs.tokens
        .sublist(matchRange.target.start, matchRange.target.end)
        .join(' '));
    if (con >= threshold) {
      res.add(Match(element.name, num.parse(con.toStringAsFixed(2))));
    }
  });

  res.sort((k1, k2) => k2.confidence.compareTo(k1.confidence));

  return res;
}

/// Performs preliminary filtering on source license texts and returns list of
/// searchset representing potential licenses that can match with target
/// text.
List<SearchSet> getPotentialMatches(
    Map<String, int> tgt, double threshold, int q) {
  var source = <SearchSet>[];
  final f = Directory(licensePath).listSync().toList();

  f.forEach((element) {
    var l = (element as File).readAsStringSync();
    l = normalize(l);

    var src = tokenize(l);

    var sim = matchFrequency(generateFreq(src), tgt);

    if (sim > threshold) {
      source.add(generateSearchSet(
          src, l, q, element.path.split('\\').last.split('.').first));
    }
  });
  return source;
}
