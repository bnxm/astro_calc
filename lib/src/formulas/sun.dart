import 'dart:math' as math;

import 'formulas.dart';

num solarMeanAnomaly(num d) {
  return RAD * (357.5291 + 0.98560028 * d);
}

num equationOfCenter(num M) {
  final firstFactor = 1.9148 * math.sin(M);
  final secondFactor = 0.02 * math.sin(2 * M);
  final thirdFactor = 0.0003 * math.sin(3 * M);

  return RAD * (firstFactor + secondFactor + thirdFactor);
}

num eclipticLongitude(num M) {
  final C = equationOfCenter(M);
  const P = RAD * 102.9372; // perihelion of the Earth

  return M + C + P + PI;
}

Map<String, num> sunCoords(num d) {
  final M = solarMeanAnomaly(d);
  final L = eclipticLongitude(M);

  return {"dec": declination(L, 0), "ra": rightAscension(L, 0)};
}
