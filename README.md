# Astro Calc

A Dart port of the [suncalc library](https://github.com/mourner/suncalc) by Vladimir Agafonkin.

### SunCalc

~~~dart
final SunTimes sunTimes = SunCalc.getTimes(date, latitude, longitude, isUtc: false);
print(sunTimes.sunrise);
print(sunTimes.nauticalDusk);

final SunPosition sunPosition = SunCalc.getPosition(date, latitude, longitude);
print(sunPosition.azimuth);
print(sunTimes.altitude);
~~~

### MoonCalc

~~~dart
final MoonTimes moonTimes = MoonCalc.getTimes(date, latitude, longitude, isUtc: true);
print(moonTimes.rise);
print(moonTimes.set);

final MoonPosition moonPosition = MoonCalc.getPosition(date, latitude, longitude);
print(moonPosition.azimuth);
print(moonPosition.distance);

final MoonIllumination illumination = MoonCalc.getIllumination(date);
print(illumination.fraction);
print(illumination.phase);
~~~