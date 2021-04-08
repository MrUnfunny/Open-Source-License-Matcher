/// This represents a matched instance of target text with a source license
class Match {
  String name;
  double confidence;

  Match(this.name, this.confidence);

  @override
  String toString() => 'Match(name: $name, confidence: $confidence)';
}

class TokenRange {
  int start;
  int end;
  String text;

  TokenRange(this.start, this.end);

  @override
  String toString() => 'start: $start, end: $end';
}

class Hash {
  TokenRange tok;
  int checksum;

  Hash(this.tok, this.checksum);
}

class SearchSet {
  String name;
  String normalizedText;
  Map<int, List<TokenRange>> hashes;
  List<Hash> hashList;
  List<String> tokens;

  SearchSet(this.hashes, this.tokens, this.hashList, this.normalizedText,
      [this.name = 'target']);
}

class MatchRange {
  TokenRange source;
  TokenRange target;

  MatchRange(this.source, this.target);

  @override
  String toString() => 'source: $source, target: $target';
}
