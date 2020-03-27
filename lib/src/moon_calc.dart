import 'dart:math' as math;

import 'formulas/formulas.dart';

import 'moon.dart';

class MoonCalc {
  const MoonCalc._();

  /// Calculates the [MoonPosition] for a given date and location.
  static MoonPosition getPosition(DateTime date, num latitude, num longitude) {
    final lw = RAD * -longitude;
    final phi = RAD * latitude;
    final d = toDays(date);

    final c = moonCoords(d);
    final H = siderealTime(d, lw) - c['ra'];
    var h = altitude(H, phi, c['dec']);
    // formula 14.1 of "Astronomical Algorithms" 2nd edition by Jean Meeus (Willmann-Bell, Richmond) 1998.
    final pa = math.atan2(math.sin(H), math.tan(phi) * math.cos(c['dec']) - math.sin(c['dec']) * math.cos(H));

    h = h + astroRefraction(h); // altitude correction for refraction

    return MoonPosition(
      azimuth: azimuth(H, phi, c['dec']),
      altitude: h,
      distance: c['dist'].toInt(),
      parallacticAngle: pa,
    );
  }

  /// Calculates the [MoonIllumination] for a given date.
  static MoonIllumination getIllumination(DateTime date) {
    final d = toDays(date);
    final s = sunCoords(d);
    final m = moonCoords(d);

    const sdist = 149598000; // distance from Earth to Sun in km

    final phi = math.acos(math.sin(s['dec']) * math.sin(m['dec']) +
        math.cos(s["dec"]) * math.cos(m['dec']) * math.cos(s['ra'] - m['ra']));
    final inc = math.atan2(sdist * math.sin(phi), m['dist'] - sdist * math.cos(phi));
    final angle = math.atan2(
        math.cos(s['dec']) * math.sin(s['ra'] - m['ra']),
        math.sin(s['dec']) * math.cos(m['dec']) -
            math.cos(s['dec']) * math.sin(m['dec']) * math.cos(s['ra'] - m['ra']));

    return MoonIllumination(
      fraction: (1 + math.cos(inc)) / 2,
      phase: 0.5 + 0.5 * inc * (angle < 0 ? -1 : 1) / PI,
      angle: angle,
    );
  }

  /// Calculates the [MoonTimes] for a given date and location.
  ///
  /// All times are in UTC.
  static MoonTimes getTimes(DateTime date, num latitude, num longitude, {bool isUtc = false}) {
    final t = DateTime.utc(date.year, date.month, date.day, 0, 0, 0);

    const hc = 0.133 * RAD;
    var h0 = getPosition(t, latitude, longitude).altitude - hc;
    var h1 = 0.0;
    var h2 = 0.0;
    var rise = 0.0;
    var set = 0.0;
    var a = 0.0;
    var b = 0.0;
    var xe = 0.0;
    var ye = 0.0;
    var d = 0.0;
    var roots = 0.0;
    var x1 = 0.0;
    var x2 = 0.0;
    var dx = 0.0;

    // go in 2-hour chunks, each time seeing if a 3-point quadratic curve crosses zero (which means rise or set)
    for (var i = 1; i <= 24; i += 2) {
      h1 = getPosition(hoursLater(t, i), latitude, longitude).altitude - hc;
      h2 = getPosition(hoursLater(t, i + 1), latitude, longitude).altitude - hc;

      a = (h0 + h2) / 2 - h1;
      b = (h2 - h0) / 2;
      xe = -b / (2 * a);
      ye = (a * xe + b) * xe + h1;
      d = b * b - 4 * a * h1;
      roots = 0;

      if (d >= 0) {
        dx = math.sqrt(d) / (a.abs() * 2);
        x1 = xe - dx;
        x2 = xe + dx;
        if (x1.abs() <= 1) roots++;
        if (x2.abs() <= 1) roots++;
        if (x1 < -1) x1 = x2;
      }

      if (roots == 1) {
        if (h0 < 0) {
          rise = i + x1;
        } else {
          set = i + x1;
        }
      } else if (roots == 2) {
        rise = i + (ye < 0 ? x2 : x1);
        set = i + (ye < 0 ? x1 : x2);
      }

      if ((rise != 0) && (set != 0)) {
        break;
      }

      h0 = h2;
    }

    final Map<String, dynamic> result = {};
    result['alwaysUp'] = false;
    result['alwaysDown'] = false;

    if (rise != 0) {
      result['rise'] = hoursLater(t, rise);
    }
    if (set != 0) {
      result['set'] = hoursLater(t, set);
    }

    if ((rise == 0) && (set == 0)) {
      result[ye > 0 ? 'alwaysUp' : 'alwaysDown'] = true;
    }

    return MoonTimes.fromMap(result, isUtc: isUtc);
  }
}