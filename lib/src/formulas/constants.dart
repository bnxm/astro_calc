import 'dart:math' as math;

const PI = math.pi;
const RAD = PI / 180;
const E = RAD * 23.4397;  // obliquity of the Earth

// date/time constants and conversions
const dayMs = 1000 * 60 * 60 * 24;
const J1970 = 2440588;
const J2000 = 2451545;
const J0 = 0.0009;
final DateTime julianEpoch = DateTime.utc(-4713, 11, 24, 12, 0, 0);
