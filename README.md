# Sample License Matcher

This is a library for detecting license from a string, file or a dart project.

<ul>
<li>Can detect over 200 licenses</li>
<li>Supports multiple license detection from a single file(but this is in a very early stage so sometimes it may give inaccurate results)</li>
<li>Supports license detection from file, directory and string</li>

</ul>

## Usage

**detectFromDirectory**
<br>
This method is specifically for detecting license from a dart/flutter package because by default, Dart and Flutter projects contain License
text in a file called "LICENSE". This method detects file called LICENSE and calls detectFromFile with it.

```dart
  var path = "/path_to_directory/";
  var matches = detectFromDirectory(path);
```

**detectFromFile**
<br>
This method extracts license text from given file path and returns list of all licenses in source which are matched with this text alongwith their confidence values.

```dart
  var path = "/path_to_file/";
  var matches = detectFromFile(path);
```

**detectFromString**
<br>
This method detects takes an unknown text as input and returns list of all licenses in source which are matched with this text alongwith their confidence value.

```dart
  var path = "<license string>";
  var matches = detectFromString(path);
```

## Example

```dart

const licenseText = '''
Copyright 2014 The Flutter Authors. All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of Google Inc. nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

''';

void main() {

  var matches = detectFromString(licenseText);

  for (var match in matches) {
  print(match);
  }
}
```

**OUTPUT**

```

Match(name: BSD-3-Clause, confidence: 0.98)

```

## Caveats

<ul>
<li>
This is a prototype for Dart's SPDX license detection for GSOC 2021.
</li>
<li>
This was built to show working of my idea about the main GSOC project as quickly as possible. So, it's performance and accuracy can be further improved.
</li>
<li>
Multiple license detection works fine but it suffers when different licenses with similar texts appear together. In such cases, it might create inaccurate MatchRange which might lead to inaccurate results or even some exceptions.
</li>
<li>
This project works perfectly fine for most cases but since it's not tested for all corner cases, the results must further verified.
</li>
</ul>
