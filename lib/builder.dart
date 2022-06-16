import 'dart:async';

import 'package:analyzer/dart/ast/visitor.dart';
import 'package:build/build.dart';
import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:font_awesome_pro_flutter/icons.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

const styles = {'solid', 'regular', 'light', 'thin', 'brands'};

Library printLibrary(String style, Iterable<_IconResult> icons) {
  return Library(
    (b) => b
      ..directives = ListBuilder(
        [Directive.import("package:flutter/widgets.dart")],
      )
      ..body = ListBuilder(
        [
          Class(
            (b) => b
              ..name = ReCase("f_a_${style}").pascalCase
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

class _IconResult {
  final String style;
  final String name;

  _IconResult({
    required this.style,
    required this.name,
  });

  @override
  bool operator ==(other) =>
      other is _IconResult && other.style == style && other.name == name;

  @override
  int get hashCode => Object.hashAll([style, name]);

  Field toField() {
    final unicode = iconsMap[name];
    if (unicode == null) {
      throw new Error(); // TODO better errors
    }
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

class _Visitor extends RecursiveAstVisitor {
  static final RegExp prefixPattern =
      RegExp(r"^FA(Solid|Regular|Light|Thin|Brands)$");
  static final RegExp iconPattern = RegExp(r"^fa(.+)$");
  final Set<_IconResult> access = {};

  @override
  visitPrefixedIdentifier(node) {
    final prefixMatch = prefixPattern.firstMatch(node.prefix.name);
    final iconMatch = iconPattern.firstMatch(node.identifier.name);
    if (prefixMatch != null && iconMatch != null) {
      access.add(_IconResult(
        style: prefixMatch.group(1)!.toLowerCase(),
        name: ReCase(iconMatch.group(1)!).paramCase,
      ));
    }
    super.visitPrefixedIdentifier(node);
  }
}

class FontAwesomePro extends Builder {
  /// A static method to initialize the builder.
  static FontAwesomePro builder(BuilderOptions options) => FontAwesomePro();

  static final _allDartFiles = Glob('lib/**.dart');

  @override
  Future<void> build(BuildStep buildStep) async {
    final Set<_IconResult> icons = {};
    await for (final input in buildStep.findAssets(_allDartFiles)) {
      final node = await buildStep.resolver.compilationUnitFor(input);
      final visitor = _Visitor();
      node.accept(visitor);
      icons.addAll(visitor.access);
    }
    for (final style in styles) {
      final formatter = DartFormatter();
      final emitter = DartEmitter(useNullSafetySyntax: true);
      final library = printLibrary(
        style,
        icons.where((element) => element.style == style),
      );
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
