final lineBreakRegEx = RegExp('[\r\n]+');

//3.1
final whiteSpaceRegEx = RegExp('[\t ]+');
final leadingWhiteSpaceRegEx = RegExp(
  '^[\t ]+',
  multiLine: true,
);
final trailingWhiteSpaceRegEx = RegExp('[\n\t ]+\$', multiLine: true);

// 5.1
final punctuationRegEx = RegExp('[-‒–—―⁓⸺⸻~˗‐‑⁃⁻₋−∼⎯⏤─➖𐆑֊﹘/;.:﹣－]+');
final quotesRegEx = RegExp('["\'“”‘’„‚,«»‹›❛❜❝❞`]+');

final paranthesisRegEx = RegExp('[\(\)\{\}]+');
//6.1
final commentsRegEx = RegExp(r'(\/\/|\/\*) +.*');

//7.1
final bulletRegEx = RegExp(
    r'(([0-9a-z]\.\s)+|(\([0-9a-z]\)\s)+|(\*\s)+)|([0-9a-z]\)\s)|(\s\([i]+\))');
final urlRegEx = RegExp(
    r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+');

//8.1
final varietalWords = {
  'acknowledgment': 'acknowledgement',
  'analogue': 'analog',
  'analyse': 'analyze',
  'artefact': 'artifact',
  'authorisation': 'authorization',
  'authorised': 'authorized',
  'calibre': 'caliber',
  'cancelled': 'canceled',
  'capitalisations': 'capitalizations',
  'catalogue': 'catalog',
  'categorise': 'categorize',
  'centre': 'center',
  'emphasised': 'emphasized',
  'favour': 'favor',
  'favourite': 'favorite',
  'fulfil': 'fulfill',
  'fulfilment': 'fulfillment',
  'initialise': 'initialize',
  'judgment': 'judgement',
  'labelling': 'labeling',
  'labour': 'labor',
  'licence': 'license',
  'maximise': 'maximize',
  'modelled': 'modeled',
  'modelling': 'modeling',
  'offence': 'offense',
  'optimise': 'optimize',
  'organisation': 'organization',
  'organise': 'organize',
  'practise': 'practice',
  'programme': 'program',
  'realise': 'realize',
  'recognise': 'recognize',
  'signalling': 'signaling',
  'sub-license': 'sublicense',
  'sub license': 'sublicense',
  'utilisation': 'utilization',
  'whilst': 'while',
  'wilful': 'wilfull',
  'non-commercial': 'noncommercial',
  'per cent': 'percent'
};

//9.1
final copyrightSymbolRegEx = RegExp(r'[©Ⓒⓒ]');
final trademarkSymbolRegEx = RegExp('trademark(s?)|\\(tm\\)');

//10.1
final copyrightTextRegEx =
    RegExp(r'((?<=\n)|.*)Copyright.+(?=\n)|Copyright.+\\n');

String normalize(String licenseText) {
  licenseText = licenseText
      .replaceAll(bulletRegEx, '')
      .replaceAll(punctuationRegEx, ' ')
      .replaceAll(quotesRegEx, ' ')
      .replaceAll(paranthesisRegEx, '')
      .replaceAll(urlRegEx, '')
      .replaceAll(commentsRegEx, '')
      .replaceAll(copyrightSymbolRegEx, '')
      .replaceAll(copyrightTextRegEx, '')
      .replaceAll(trademarkSymbolRegEx, ' ')
      .replaceAll(whiteSpaceRegEx, ' ')
      .replaceAll(trailingWhiteSpaceRegEx, '')
      .replaceAll(leadingWhiteSpaceRegEx, '')
      //4.1
      .toLowerCase()
      .trim();

  //Removes license header
  if (licenseText.split('\n')[0].contains('license')) {
    licenseText = licenseText.split('\n').sublist(1).join('\n');
  }

  varietalWords.forEach((key, value) {
    licenseText = licenseText.replaceAll(key, value);
  });

  licenseText = licenseText.replaceAll(RegExp('[\n]+'), '\n');

  return licenseText;
}
