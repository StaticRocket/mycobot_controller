import 'package:flutter/material.dart';

const poses = [
  {'X': 80.0, 'Y': 0.0, 'Z': 80.0, 'A': 0.0, 'B': 0.0, 'C': 0.0},
  {'X': 0.0, 'Y': 80.0, 'Z': 0.0, 'A': 0.0, 'B': 80.0, 'C': 0.0},
  {'X': 0.0, 'Y': 0.0, 'Z': 0.0, 'A': 0.0, 'B': 0.0, 'C': 0.0},
];

bool isAtTarget(start, target) {
  bool atTarget = true;
  start.forEach((startKey, startValue) {
    atTarget &= startValue == target[startKey];
  });
  return atTarget;
}
