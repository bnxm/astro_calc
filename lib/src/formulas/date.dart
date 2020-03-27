import './constants.dart';

num toJulian(DateTime date) {
  return date.difference(julianEpoch).inSeconds / Duration.secondsPerDay;
}

DateTime fromJulian(num j) {
  return julianEpoch.add(Duration(milliseconds: (j * Duration.millisecondsPerDay).floor()));
}

num toDays(DateTime date) {
  return toJulian(date) - J2000;
}

DateTime hoursLater(DateTime date, num h) {
  final ms = h * 60 * 60 * 1000;
  return date.add(Duration(milliseconds: ms.toInt()));
}
