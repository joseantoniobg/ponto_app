import 'package:ponto_app/util/consts.dart';

class DataFormatter {
  String formatTimetoString(int data) {
    return data.toString().padLeft(2, '0');
  }

  String formatMilliseconds(int milliseconds) {
    return milliseconds.toString().padLeft(3, '0');
  }

  String getFormattedTimer({
    int hours,
    int minutes,
    int seconds,
  }) {
    String formattedTimer = formatTimetoString(hours) + ':';
    formattedTimer += formatTimetoString(minutes) + ':';
    formattedTimer += formatTimetoString(seconds);
    return formattedTimer;
  }

  int getMillisecondsFromTimer(String timer) {
    int hours = getHourInTimer(timer);
    int minutes = getMinuteInTimer(timer);
    return hours * Consts.hourInMilliSeconds +
        minutes * Consts.minuteInMilliSeconds;
  }

  String addMinuteToTimer(String timer) {
    return formatTimer(timer, 1);
  }

  String removeMinuteFromTimer(String timer) {
    return formatTimer(timer, -1);
  }

  String resetTimer(String timer) {
    return formatTimer(timer, 59);
  }

  String formatTimer(String timer, int minuteAdjustment) {
    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    if (minuteAdjustment != 59) {
      hours = getHourInTimer(timer);
      minutes = getMinuteInTimer(timer);
      seconds = getSecondInTimer(timer);
    }

    minutes += minuteAdjustment;

    if (minutes > 59) {
      hours = hours + 1;
      minutes = 0;
    } else if (minutes < 0) {
      hours = hours - 1;
      minutes = 59;
    }

    return getFormattedTimer(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }

  int getHourInTimer(String timer) {
    return int.parse(timer.substring(0, 2));
  }

  int getMinuteInTimer(String timer) {
    return int.parse(timer.substring(3, 5));
  }

  int getSecondInTimer(String timer) {
    return int.parse(timer.substring(6, 8));
  }
}
