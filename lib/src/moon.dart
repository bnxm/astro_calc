import 'dart:convert';

class MoonPosition {
  /// Moon azimuth in radians.
  final double azimuth;

  /// Moon altitude above the horizon in radians.
  final double altitude;

  /// Distance to moon in kilometers
  final int distance;

  /// Parallactic angle of the moon in radians
  final double parallacticAngle;
  const MoonPosition({
    this.azimuth = 0.0,
    this.altitude = 0.0,
    this.distance = 0,
    this.parallacticAngle = 0.0,
  });

  @override
  String toString() {
    return 'MoonPosition(azimuth: $azimuth, altitude: $altitude, distance: $distance, parallacticAngle: $parallacticAngle)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MoonPosition &&
        o.azimuth == azimuth &&
        o.altitude == altitude &&
        o.distance == distance &&
        o.parallacticAngle == parallacticAngle;
  }

  @override
  int get hashCode {
    return azimuth.hashCode ^ altitude.hashCode ^ distance.hashCode ^ parallacticAngle.hashCode;
  }
}

class MoonIllumination {
  /// Illuminated fraction of the moon; varies from 0.0 (new moon) to 1.0 (full moon)
  final double fraction;

  /// Moon phase; varies from 0.0 to 1.0.
  ///
  /// 0    - New Moon
  ///      - Waxing Crescent
  /// 0.25 - First Quarter
  ///      - Waxing Gibbous
  /// 0.5  - Full Moon
  ///      - Waning Gibbous
  /// 0.75 - Last Quarter
  ///      - Waning Crescent
  final double phase;

  /// Midpoint angle in radians of the illuminated limb
  /// of the moon reckoned eastward from the north point of the disk;
  /// the moon is waxing if the angle is negative, and waning if positive.
  final double angle;
  const MoonIllumination({
    this.fraction = 0.0,
    this.phase = 0.0,
    this.angle = 0.0,
  });

  @override
  String toString() => 'MoonIllumination(fraction: $fraction, phase: $phase, angle: $angle)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MoonIllumination && o.fraction == fraction && o.phase == phase && o.angle == angle;
  }

  @override
  int get hashCode => fraction.hashCode ^ phase.hashCode ^ angle.hashCode;
}

class MoonTimes {
  final DateTime rise;
  final DateTime set;
  final bool isAlwaysUp;
  final bool isAlwaysDown;
  const MoonTimes({
    this.rise,
    this.set,
    this.isAlwaysUp = false,
    this.isAlwaysDown = false,
  });

  factory MoonTimes.fromMap(Map<String, dynamic> map, {bool isUtc = false}) {
    if (map == null) return null;

    return MoonTimes(
      rise: isUtc ? map['rise'] : map['rise']?.toLocal(),
      set: isUtc ? map['set'] : map['set']?.toLocal(),
      isAlwaysUp: map['isAlwaysUp'] ?? false,
      isAlwaysDown: map['isAlwaysDown'] ?? false,
    );
  }

  @override
  String toString() {
    return 'MoonTimes(rise: $rise, set: $set, isAlwaysUp: $isAlwaysUp, isAlwaysDown: $isAlwaysDown)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MoonTimes &&
        o.rise == rise &&
        o.set == set &&
        o.isAlwaysUp == isAlwaysUp &&
        o.isAlwaysDown == isAlwaysDown;
  }

  @override
  int get hashCode {
    return rise.hashCode ^ set.hashCode ^ isAlwaysUp.hashCode ^ isAlwaysDown.hashCode;
  }
}

class MoonPhase {
  final double phase;
  final DateTime time;
  MoonPhase({
    this.phase,
    this.time,
  });

  @override
  String toString() => 'MoonPhase(phase: $phase, time: $time)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MoonPhase && o.phase == phase && o.time == time;
  }

  @override
  int get hashCode => phase.hashCode ^ time.hashCode;
}
