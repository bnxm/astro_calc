import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';

import 'package:astro_calc/astro_calc.dart';

void main() {
  final date = utc(00, 00);

  const latitude = 53.551086;
  const longitude = 9.993682;

  group('Sun', () {
    test('Should return the correct SunTimes for the given date and location in utc', () {
      // act
      final sunTimes = SunCalc.getTimes(date, latitude, longitude, isUtc: true);
      // assert
      isAround(sunTimes.sunrise, utc(05, 07));
      isAround(sunTimes.sunset, utc(17, 45));
      isAround(sunTimes.dawn, utc(04, 31));
      isAround(sunTimes.dusk, utc(18, 20));
      isAround(sunTimes.solarNoon, utc(11, 25));
      isAround(sunTimes.nauticalDawn, utc(03, 49));
      isAround(sunTimes.nauticalDusk, utc(19, 02));
      isAround(sunTimes.morningGoldenHourEnd, utc(05, 52));
      isAround(sunTimes.eveningGoldenHourStart, utc(17, 00));
      isAround(sunTimes.nightStart, utc(19, 47));
      isAround(sunTimes.nightEnd, utc(03, 04));
      isAround(sunTimes.nadir.add(const Duration(days: 1)), utc(23, 26));
    });

    test('Should return the correct SunTimes for the given date and location in local time', () {
      // act
      final sunTimes = SunCalc.getTimes(date, latitude, longitude, isUtc: false);
      // assert
      isAround(sunTimes.sunrise, local(06, 07));
      isAround(sunTimes.sunset, local(18, 45));
      isAround(sunTimes.dawn, local(05, 31));
      isAround(sunTimes.dusk, local(19, 20));
      isAround(sunTimes.solarNoon, local(12, 25));
      isAround(sunTimes.nauticalDawn, local(04, 49));
      isAround(sunTimes.nauticalDusk, local(20, 02));
      isAround(sunTimes.morningGoldenHourEnd, local(06, 52));
      isAround(sunTimes.eveningGoldenHourStart, local(18, 00));
      isAround(sunTimes.nightStart, local(20, 47));
      isAround(sunTimes.nightEnd, local(04, 04));
      isAround(sunTimes.nadir, local(00, 26));
    });

    test('Should ', () async {
      // arrange
      final sunTimes = SunCalc.getTimes(DateTime.now(), 1.3521, 103.8198, isUtc: false);
      print(sunTimes);
      
    });

    test('Should return the correct SunPosition for the given date and location', () {
      // act
      final sunPosition = SunCalc.getPosition(utc(11, 25), latitude, longitude);
      // assert
      isCloseTo(sunPosition.azimuth, radians(0));
      isCloseTo(sunPosition.altitude, radians(39));
    });
  });

  group('Moon', () {
    test('Should return the correct MoonTimes for the given date and location in utc', () {
      // act
      final moonTimes = MoonCalc.getTimes(date, latitude, longitude, isUtc: true);
      // assert
      isAround(moonTimes.rise, utc(06, 16));
      isAround(moonTimes.set, utc(20, 00));
      expect(moonTimes.isAlwaysDown, isFalse);
      expect(moonTimes.isAlwaysUp, isFalse);
    });

    test('Should return the correct MoonTimes for the given date and location in local time', () {
      // act
      final moonTimes = MoonCalc.getTimes(date, latitude, longitude, isUtc: true);
      // assert
      isAround(moonTimes.rise, local(07, 16));
      isAround(moonTimes.set, local(21, 00));
    });

    test('Should return the correct MoonIllumination for the given date', () {
      // act
      final illumination = MoonCalc.getIllumination(date);
      // assert
      isCloseTo(illumination.fraction, 0.03);
      isCloseTo(illumination.phase, 0.05);
      isCloseTo(illumination.angle, -1.69);
    });

    test('Should return the correct MoonPosition for the given date and location', () {
      // act
      final position = MoonCalc.getPosition(date, latitude, longitude);
      // assert
      isCloseTo(position.azimuth, 2.94);
      isCloseTo(position.altitude, radians(-30), 0.1);
      isCloseTo(position.distance, 404904, 1000);
      isCloseTo(position.parallacticAngle, 0.11);
    });
  });
}

DateTime utc(int hour, int minute) => DateTime.utc(2020, 3, 26, hour, minute);

DateTime local(int hour, int minute) => DateTime(2020, 3, 26, hour, minute);

double radians(double angle) => angle * math.pi / 180;

// Check whether the actual is roughly the same as the reference time.
//
// Astronomical calculations always differ slightly between each other
// so we have to be more lenient with our tests.
void isAround(DateTime actual, DateTime expected, {int margin = 3}) {
  final before = expected.subtract(Duration(minutes: margin));
  final after = expected.add(Duration(minutes: margin));
  final isInBetween = before.isBefore(actual) && after.isAfter(actual);

  if (!isInBetween) {
    print('Before: $before');
    print('Actual: $actual');
    print('After: $after');
  }

  expect(isInBetween, isTrue);
}

void isCloseTo(num actual, num expected, [num margin = 0.01]) {
  final result = (actual - expected).abs() < margin;

  if (!result) {
    print('Actual: $actual');
    print('Expected: $expected');
  }

  expect(result, isTrue);
}
