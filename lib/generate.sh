#!/bin/bash
rm -rf baked_*
rm -rf *.json
python3 main.py
dart run generate_components.dart
dart run generate_completion.dart
cd ../ && dart fix --apply
