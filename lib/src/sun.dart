class SunPosition {
  /// Sun azimuth in radians
  /// (direction along the horizon, measured from south to west),
  /// e.g. 0 is south and Math.PI * 3/4 is northwest
  final double azimuth;

  /// Sun altitude above the horizon in radians, e.g. 0 at
  /// the horizon and PI/2 at the zenith (straight over your head).
  final double altitude;
  const SunPosition({
    this.azimuth,
    this.altitude,
  });

  @override
  String toString() => 'SunPosition(azimuth: $azimuth, altitude: $altitude)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SunPosition && o.azimuth == azimuth && o.altitude == altitude;
  }

  @override
  int get hashCode => azimuth.hashCode ^ altitude.hashCode;
}

class SunTimes {
  /// Sunrise (top edge of the sun appears on the horizon).
  final DateTime sunrise;

  /// Sunrise ends (bottom edge of the sun touches the horizon).
  final DateTime sunriseEnd;

  /// Sunset starts (bottom edge of the sun touches the horizon).
  final DateTime sunsetStart;

  /// Sunset (sun disappears below the horizon, evening civil twilight starts).
  final DateTime sunset;

  /// Dawn (morning nautical twilight ends, morning civil twilight starts).
  final DateTime dawn;

  /// Dusk (evening nautical twilight starts).
  final DateTime dusk;

  /// Nautical dawn (morning nautical twilight starts).
  final DateTime nauticalDawn;

  /// Nautical dusk (evening astronomical twilight starts).
  final DateTime nauticalDusk;

  /// Night starts (dark enough for astronomical observations).
  final DateTime nightStart;

  /// Night ends (morning astronomical twilight starts).
  final DateTime nightEnd;

  /// Evening golden hour starts.
  final DateTime eveningGoldenHourStart;

  /// Morning golden hour (soft light, best time for photography) ends.
  final DateTime morningGoldenHourEnd;

  /// Solar noon (sun is in the highest position).
  final DateTime solarNoon;

  /// Nadir (darkest moment of the night, sun is in the lowest position).
  final DateTime nadir;
  const SunTimes({
    this.sunrise,
    this.sunriseEnd,
    this.sunsetStart,
    this.sunset,
    this.dawn,
    this.dusk,
    this.nauticalDawn,
    this.nauticalDusk,
    this.nightStart,
    this.nightEnd,
    this.eveningGoldenHourStart,
    this.morningGoldenHourEnd,
    this.solarNoon,
    this.nadir,
  });

  /// The duration between sunrise and sunset.
  Duration get lengthOfDay => sunrise.difference(sunset);

  /// The golden hour in the morning.
  ///
  /// {@template golden_hour}
  /// The golden hour is a colloqial term and refers
  /// to a state of natural lighting that is most common
  /// around sunrise and sunset.
  /// {@endtemplate}
  Twighlight get morningGoldenHour => Twighlight(sunrise, morningGoldenHourEnd);

  /// The golden hour in the evening.
  ///
  /// {@macro golden_hour}
  Twighlight get eveningGoldenHour => Twighlight(eveningGoldenHourStart, sunset);

  /// The blue hour in the morning.
  ///
  /// {@template blue_hour}
  /// The blue hour is a colloqial term that refers
  /// to a state of natural lighting that
  /// usually occurs at daybreak in the morning and at
  /// the last stages of twilight in the evening.
  ///
  /// This is why this value is thus an approximation.
  /// {@endtemplate}
  Twighlight get morningBlueHour {
    return Twighlight(
      dawn,
      dawn.add(sunrise.difference(dawn) * 0.66),
    );
  }

  /// The blue hour in the evening.
  ///
  /// {@macro blue_hour}
  Twighlight get eveningBlueHour {
    return Twighlight(
      sunset.add(dusk.difference(sunset) * 0.33),
      dusk,
    );
  }

  factory SunTimes.fromMap(Map<String, dynamic> map, {bool isUtc = false}) {
    if (map == null) return null;

    return SunTimes(
      sunrise: isUtc ? map['sunrise'] : map['sunrise']?.toLocal(),
      sunriseEnd: isUtc ? map['sunriseEnd'] : map['sunriseEnd']?.toLocal(),
      sunsetStart: isUtc ? map['sunsetStart'] : map['sunsetStart']?.toLocal(),
      sunset: isUtc ? map['sunset'] : map['sunset']?.toLocal(),
      dawn: isUtc ? map['dawn'] : map['dawn']?.toLocal(),
      dusk: isUtc ? map['dusk'] : map['dusk']?.toLocal(),
      nauticalDawn: isUtc ? map['nauticalDawn'] : map['nauticalDawn']?.toLocal(),
      nauticalDusk: isUtc ? map['nauticalDusk'] : map['nauticalDusk']?.toLocal(),
      nightStart: isUtc ? map['night'] : map['night']?.toLocal(),
      nightEnd: isUtc ? map['nightEnd'] : map['nightEnd']?.toLocal(),
      eveningGoldenHourStart: isUtc ? map['goldenHour'] : map['goldenHour']?.toLocal(),
      morningGoldenHourEnd: isUtc ? map['goldenHourEnd'] : map['goldenHourEnd']?.toLocal(),
      solarNoon: isUtc ? map['solarNoon'] : map['solarNoon']?.toLocal(),
      nadir: isUtc ? map['nadir'] : map['nadir']?.toLocal(),
    );
  }

  @override
  String toString() {
    return 'SunTimes(sunrise: $sunrise, sunriseEnd: $sunriseEnd, sunsetStart: $sunsetStart, sunset: $sunset, dawn: $dawn, dusk: $dusk, nauticalDawn: $nauticalDawn, nauticalDusk: $nauticalDusk, night: $nightStart, nightEnd: $nightEnd, goldenHour: $eveningGoldenHourStart, goldenHourEnd: $morningGoldenHourEnd, solarNoon: $solarNoon, nadir: $nadir)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SunTimes &&
        o.sunrise == sunrise &&
        o.sunriseEnd == sunriseEnd &&
        o.sunsetStart == sunsetStart &&
        o.sunset == sunset &&
        o.dawn == dawn &&
        o.dusk == dusk &&
        o.nauticalDawn == nauticalDawn &&
        o.nauticalDusk == nauticalDusk &&
        o.nightStart == nightStart &&
        o.nightEnd == nightEnd &&
        o.eveningGoldenHourStart == eveningGoldenHourStart &&
        o.morningGoldenHourEnd == morningGoldenHourEnd &&
        o.solarNoon == solarNoon &&
        o.nadir == nadir;
  }

  @override
  int get hashCode {
    return sunrise.hashCode ^
        sunriseEnd.hashCode ^
        sunsetStart.hashCode ^
        sunset.hashCode ^
        dawn.hashCode ^
        dusk.hashCode ^
        nauticalDawn.hashCode ^
        nauticalDusk.hashCode ^
        nightStart.hashCode ^
        nightEnd.hashCode ^
        eveningGoldenHourStart.hashCode ^
        morningGoldenHourEnd.hashCode ^
        solarNoon.hashCode ^
        nadir.hashCode;
  }
}

class Twighlight {
  final DateTime start;
  final DateTime end;
  const Twighlight(
    this.start,
    this.end,
  );

  Duration get duration => end.difference(start);

  @override
  String toString() => 'Twighlight(start: $start, end: $end)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Twighlight && o.start == start && o.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
