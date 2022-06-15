import 'dart:async';

import 'package:build/build.dart';
import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:font_awesome_pro_flutter/icons.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

class _IconWrapper {
  final String unicode;
  final String label;
  final String name;

  const _IconWrapper({
    required this.unicode,
    required this.label,
    required this.name,
  });

  static _IconWrapper parse(Map<String, dynamic> map) => _IconWrapper(
        unicode: map['unicode'],
        label: map['label'],
        name: map['name'],
      );
  Field toField() {
    return Field(
      (b) => b
        ..name = ReCase("fa-${name}").camelCase
        ..modifier = FieldModifier.constant
        ..type = refer("IconData")
        ..static = true
        ..assignment = refer('IconData').call(
          [literalNum(int.parse(unicode, radix: 16))],
          {'fontFamily': refer('_fontFamily')},
        ).code,
    );
  }
}

const styles = {'solid', 'regular', 'light', 'thin', 'brands'};

Library print(String style, List<_IconWrapper> icons) {
  return Library(
    (b) => b
      ..directives = ListBuilder(
        [Directive.import("package:flutter/widgets.dart")],
      )
      ..body = ListBuilder(
        [
          Class(
            (b) => b
              ..name = ReCase("font_awesome_${style}_icon_data").pascalCase
              ..constructors = ListBuilder([Constructor((b) => b..name = "_")])
              ..fields = ListBuilder([
                ...icons.map((e) => e.toField()),
                Field(
                  (b) => b
                    ..name = '_fontFamily'
                    ..static = true
                    ..modifier = FieldModifier.constant
                    ..assignment = literalString(
                      ReCase("font-awesome-${style}").pascalCase,
                    ).code,
                )
              ]),
          )
        ],
      ),
  );
}

class FontAwesomePro extends Builder {
  /// A static method to initialize the builder.
  static FontAwesomePro builder(BuilderOptions options) => FontAwesomePro();

  @override
  FutureOr<void> build(BuildStep buildStep) {
    final Map<String, List<_IconWrapper>> parsedIcons = {};

    for (final icon in iconsMap) {
      final parsedIcon = _IconWrapper.parse(icon);
      for (final String style in icon['styles']) {
        if (parsedIcons[style] == null) {
          parsedIcons[style] = [];
        }
        parsedIcons[style]?.add(parsedIcon);
      }
    }

    for (final style in styles) {
      final formatter = DartFormatter();
      final emitter = DartEmitter(useNullSafetySyntax: true);
      final library = print(style, parsedIcons[style] ?? []);
      final contents = formatter.format("${library.accept(emitter)}");
      buildStep.writeAsString(
        AssetId(
          buildStep.inputId.package,
          p.join('lib', 'font_awesome', '${style}.dart'),
        ),
        contents,
      );
    }
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        r'lib/$lib$': [
          r'lib/font_awesome/solid.dart',
          r'lib/font_awesome/regular.dart',
          r'lib/font_awesome/light.dart',
          r'lib/font_awesome/thin.dart',
          r'lib/font_awesome/brands.dart',
        ],
      };
}
