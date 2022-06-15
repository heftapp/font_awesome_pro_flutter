import 'dart:io';

import 'package:build_test/build_test.dart';
import 'package:font_awesome_pro_flutter/builder.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

final assetsDir = Directory("test/assets");

void main() {
  group("Builder", () {
    test("works", () async {
      final writer = InMemoryAssetWriter();
      await testBuilder(
        FontAwesomePro(),
        {'a|lib/foo.dart': "# Hello"},
        writer: writer,
        rootPackage: 'a',
        outputs: {
          r'a|lib/font_awesome/solid.dart': decodedMatches(
            stringContainsInOrder(['class FontAwesomeSolid']),
          ),
          r'a|lib/font_awesome/regular.dart': decodedMatches(
            stringContainsInOrder(['class FontAwesomeRegular']),
          ),
          r'a|lib/font_awesome/light.dart': decodedMatches(
            stringContainsInOrder(['class FontAwesomeLight']),
          ),
          r'a|lib/font_awesome/thin.dart': decodedMatches(
            stringContainsInOrder(['class FontAwesomeThin']),
          ),
          r'a|lib/font_awesome/brands.dart': decodedMatches(
            stringContainsInOrder(['class FontAwesomeBrands']),
          ),
        },
      );
    });
  });
}
