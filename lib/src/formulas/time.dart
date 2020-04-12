import 'dart:math' as math;

import './constants.dart';

num julianCycle(num d, num lw) {
  return (d - J0 - lw / (2 * PI)).round();
}

num approxTransit(num ht, num lw, num n) {
  return J0 + (ht + lw) / (2 * PI) + n;
}

num solarTransitJ(num ds, num M, num L) {
  return J2000 + ds + 0.0053 * math.sin(M) - 0.0069 * math.sin(2 * L);
}

num hourAngle(num h, num phi, num d) {
  final arc = (math.sin(h) - math.sin(phi) * math.sin(d)) / (math.cos(phi) * math.cos(d));
  return math.acos(arc.clamp(-1.0, 1.0));
}

num getSetJ(num h, num lw, num phi, num dec, num n, num M, num L) {
  final w = hourAngle(h, phi, dec);
  final a = approxTransit(w, lw, n);

  return solarTransitJ(a, M, L);
}
