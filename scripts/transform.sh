#!/usr/bin/env bash

json=$(cat ./icons.json | jq "[to_entries[] | {key: .key, value: .value.unicode } ] | from_entries")

echo "const Map<String, String> iconsMap = ${json};" > lib/icons.dart

dart format lib/icons.dart