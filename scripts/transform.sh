#!/usr/bin/env bash

json=$(cat ./icons.json | jq "[ to_entries[] | { name: .key, label: .value.label, unicode: .value.unicode, styles: .value.styles, free: .value.free}  ]")

echo "const List<Map<String, dynamic>> iconsMap = ${json};" > lib/icons.dart

dart format lib/icons.dart