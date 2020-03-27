import 'formulas/formulas.dart';

import 'sun.dart';

class SunCalc {
  const SunCalc._();

  static const List<List<dynamic>> _times = [
    [-0.833, 'sunrise', 'sunset'],
    [-0.3, 'sunriseEnd', 'sunsetStart'],
    [-6, 'dawn', 'dusk'],
    [-12, 'nauticalDawn', 'nauticalDusk'],
    [-18, 'nightEnd', 'night'],
    [6, 'goldenHourEnd', 'goldenHour']
  ];

  /// Calculates the [SunPosition] for a given date and location.
  static SunPosition getPosition(DateTime date, num latitude, num longitude) {
    final lw = RAD * -longitude;
    final phi = RAD * latitude;
    final d = toDays(date);

    final c = sunCoords(d);
    final H = siderealTime(d, lw) - c['ra'];

    return SunPosition(
      azimuth: azimuth(H, phi, c['dec']).toDouble(),
      altitude: altitude(H, phi, c['dec']).toDouble(),
    );
  }

  /// Calculates the [SunTimes] for a given date and location.
  static SunTimes getTimes(DateTime date, num latitude, num longitude, {bool isUtc = false}) {
    final lw = RAD * -longitude;
    final phi = RAD * latitude;

    final d = toDays(date);
    final n = julianCycle(d, lw);
    final ds = approxTransit(0, lw, n);

    final M = solarMeanAnomaly(ds);
    final L = eclipticLongitude(M);
    final dec = declination(L, 0);

    final jnoon = solarTransitJ(ds, M, L);
    dynamic i, time, jset, jrise;

    final result = {'solarNoon': fromJulian(jnoon), 'nadir': fromJulian(jnoon - 0.5)};

    for (i = 0; i < _times.length; i += 1) {
      time = _times[i];

      jset = getSetJ(time[0] * RAD, lw, phi, dec, n, M, L);
      jrise = jnoon - (jset - jnoon);

      result[time[1]] = fromJulian(jrise);
      result[time[2]] = fromJulian(jset);
    }

    return SunTimes.fromMap(result, isUtc: isUtc);
  }
}