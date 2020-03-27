import 'dart:math' as math;

import 'formulas.dart';

Map<String, num> moonCoords(num d) {
  final L = RAD * (218.316 + 13.176396 * d);
  final M = RAD * (134.963 + 13.064993 * d);
  final F = RAD * (93.272 + 13.229350 * d);

  final l = L + RAD * 6.289 * math.sin(M);
  final b = RAD * 5.128 * math.sin(F);
  final dt = 385001 - 20905 * math.cos(M);

  return {"ra": rightAscension(l, b), "dec": declination(l, b), "dist": dt};
}
