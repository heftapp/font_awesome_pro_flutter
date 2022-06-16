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
        {
          'a|lib/foo.dart': """
const v = FontAwesomeSolidIconData.faAlbumCollectionCirclePlus;
"""
        },
        writer: writer,
        rootPackage: 'a',
        outputs: {
          r'a|lib/font_awesome/solid.dart': decodedMatches(
            stringContainsInOrder([
              'class FontAwesomeSolidIconData',
              'faAlbumCollectionCirclePlus'
            ]),
          ),
          r'a|lib/font_awesome/regular.dart': decodedMatches(
            stringContainsInOrder(['class FontAwesomeRegularIconData']),
          ),
          r'a|lib/font_awesome/light.dart': decodedMatches(
            stringContainsInOrder(['class FontAwesomeLightIconData']),
          ),
          r'a|lib/font_awesome/thin.dart': decodedMatches(
            stringContainsInOrder(['class FontAwesomeThinIconData']),
          ),
          r'a|lib/font_awesome/brands.dart': decodedMatches(
            stringContainsInOrder(['class FontAwesomeBrandsIconData']),
          ),
        },
      );
    });
  });
}
