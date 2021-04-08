import 'dart:convert';

import 'package:crclib/catalog.dart';

import 'models.dart';

/// Converts text into a List of tokens where each token is a
/// word in the text.
List<String> tokenize(String text) {
  var lines = text.split('\n');
  var token = <String>[];

  for (var line in lines) {
    var words = line.split(' ');
    for (var word in words) {
      token.add(word.trim());
    }
  }

  return token;
}

/// generates SearchSet for a license text or target text and maps hashes from
/// crc32 checksum of tokens in tokenRange to the tokenRange.
SearchSet generateSearchSet(List<String> tokens, String normalizedText, int q,
    [String name]) {
  var res = <int, List<TokenRange>>{};
  var tokenRanges = <Hash>[];

  for (var i = 0; i <= tokens.length - q; i++) {
    var crc = Crc32();

    var str = tokens[i];

    for (var j = 1; j < q; j++) {
      str += ' ' + tokens[i + j];
    }

    var csum = crc.convert(utf8.encode(str)).hashCode;

    if (!res.containsKey(csum)) {
      res[csum] = [];
    }
    var tok = TokenRange(i, i + q);
    tokenRanges.add(Hash(tok, csum));
    res[csum].add(tok);
  }
  return SearchSet(res, tokens, tokenRanges, normalizedText, name ?? 'target');
}

/// returns MatchRange which represents range of Tokens in license source
///  which match the range of Tokens in the target text.
MatchRange getMatchRange(SearchSet source, SearchSet target, double threshold) {
  // classifies list of MatchRanges by difference in indices of tokens in source
  // and target.
  var off = <int, List<MatchRange>>{};
  var list = <MatchRange>[];

  for (var tgt in target.hashList) {
    if (!source.hashes.containsKey(tgt.checksum)) {
      continue;
    }
    for (var src in source.hashes[tgt.checksum]) {
      var offset = src.start - tgt.tok.start;

      if (off.containsKey(offset)) {
        if (off[offset].last.target.end == tgt.tok.end - 1) {
          off[offset].last.source.end = src.end;
          off[offset].last.target.end = tgt.tok.end;
          continue;
        }
      } else {
        off[offset] = [];
      }

      off[offset].add(MatchRange(TokenRange(src.start, src.end),
          TokenRange(tgt.tok.start, tgt.tok.end)));
    }
  }

  // create list of MatchRanges from the map.
  for (var i in off.keys) {
    for (var j in off[i]) {
      list.add(j);
    }
  }

  // sorts the list according to number of matched Tokens in each MatchRange.
  list.sort((k1, k2) => (k1.source.start - k1.source.end)
      .compareTo(k2.source.start - k2.source.end));

  // gets rid of token ranges which are already included in other larger
  // token ranges.
  var newList = <MatchRange>[];
  for (var i in list) {
    if (newList.isEmpty) {
      newList.add(i);
    } else {
      var sub = false;
      for (var j in newList) {
        if (j.source.start <= i.source.start && j.source.end >= i.source.end) {
          sub = true;
          break;
        }
      }
      if (sub) {
        continue;
      } else {
        newList.add(i);
      }
    }
  }

  newList.sort((k1, k2) => k1.source.start.compareTo(k2.source.start));

  // number of erroroneous tokens that can occur in the token range to keep match
  // confidence value within the threshold
  var error =
      ((newList.last.source.end - newList.first.source.start) * (1 - threshold))
          .floor();

  var last = newList.first.source.start;
  var tgtLast = newList.first.target.start;
  var err = 0;

  var matchedTokens = 0;

  // creates range of tokens with possible errors which can be potential
  // match to the target text.
  for (var i in newList) {
    if (i.source.start < last) {
      continue;
    }

    err += i.source.start - last;
    matchedTokens += i.source.end - i.source.start;
    if (err > error) {
      if (matchedTokens >= source.tokens.length * threshold) {
        return MatchRange(TokenRange(newList.first.source.start, last),
            TokenRange(newList.first.target.start, tgtLast));
      } else {
        return null;
      }
    }
    last = i.source.end;
    tgtLast = i.target.end;
  }

  if (matchedTokens > (source.tokens.length * threshold).floor() &&
      newList.first.target.start < tgtLast) {
    return MatchRange(TokenRange(newList.first.source.start, last),
        TokenRange(newList.first.target.start, tgtLast));
  } else {
    return null;
  }
}

/// matches Frequencies of two Frequency maps for preliminary filtering. Returned
/// value is meant to be matched with threshold value to filter potential matches
/// for the target text in source texts.
double matchFrequency(Map<String, int> src, Map<String, int> tgt) {
  var sim = 0;

  for (var i in src.keys) {
    if (tgt[i] != null && tgt[i] >= src[i]) {
      sim++;
    }
  }

  return sim / src.keys.length;
}

/// generates frequency map for tokenized text.
Map<String, int> generateFreq(List<String> token) {
  var fMap = <String, int>{};
  for (var i in token) {
    fMap.update(i, (value) => ++value, ifAbsent: () => 1);
  }
  return fMap;
}
