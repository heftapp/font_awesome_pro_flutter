import 'dart:async';

import 'package:build/build.dart';

class FontAwesomePro extends Builder {
  @override
  FutureOr<void> build(BuildStep buildStep) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        r'lib/$lib$': [r'.font_awesome.dart'],
      };
}
