import 'package:flutter/material.dart';

const poses = [
  {'X': 9.0, 'Y': -55.0, 'Z': 20.0, 'A': 22.0, 'B': 32.0, 'C': 24.0},
  {'X': 28.0, 'Y': -36.0, 'Z': -24.0, 'A': 44.0, 'B': -17.0, 'C': -40.0},
  {'X': -15.0, 'Y': 11.0, 'Z': -82.0, 'A': -21.0, 'B': 26.0, 'C': 27.0},
  {'X': -15.0, 'Y': -36.0, 'Z': 62.0, 'A': -68.0, 'B': -81.0, 'C': 27.0},
];

bool isAtTarget(start, target) {
  bool atTarget = true;
  start.forEach((startKey, startValue) {
    atTarget &= startValue == target[startKey];
  });
  return atTarget;
}
