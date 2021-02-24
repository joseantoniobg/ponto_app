import 'dart:async';

import 'package:ponto_app/util/consts.dart';
import 'package:ponto_app/util/data_formatter.dart';

class TimerData {
  String hourMinuteSecond;
  String milliSecond;

  TimerData({
    this.hourMinuteSecond,
    this.milliSecond,
  });
}

class Time {
  int _durationInMilliSeconds;
  int _totalDurationInMilliseconds;
  TimerData timerData;
  DataFormatter dataFormatter = new DataFormatter();

  Time(this.timerData) {
    _durationInMilliSeconds = getMillisecondsFromTimer();
    _totalDurationInMilliseconds = _durationInMilliSeconds;
  }

  void runTimeInMilliseconds() {
    _durationInMilliSeconds--;
    setCurrentRemainingTime();
  }

  void runTimeInDecSeconds() {
    _durationInMilliSeconds -= 100;
    setCurrentRemainingTime();
  }

  setCurrentRemainingTime() {
    int millisecondsRemaining = _durationInMilliSeconds;
    int hours = (millisecondsRemaining / Consts.hourInMilliSeconds).floor();
    millisecondsRemaining -= hours * Consts.hourInMilliSeconds;
    int minutes = (millisecondsRemaining / Consts.minuteInMilliSeconds).floor();
    millisecondsRemaining -= minutes * Consts.minuteInMilliSeconds;
    int seconds =
        (millisecondsRemaining / Consts.secondsInMilliseconds).floor();
    millisecondsRemaining -= seconds * Consts.secondsInMilliseconds;
    int milliseconds = millisecondsRemaining;

    String hourMinuteSecond = dataFormatter.getFormattedTimer(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );

    String milliSecondsStr = dataFormatter.formatMilliseconds(milliseconds);

    timerData.hourMinuteSecond = hourMinuteSecond;
    timerData.milliSecond = milliSecondsStr;
  }

  void addMinuteTotime() {
    this.timerData.hourMinuteSecond =
        dataFormatter.addMinuteToTimer(this.timerData.hourMinuteSecond);
    this.timerData.milliSecond = "000";
    _durationInMilliSeconds = getMillisecondsFromTimer();
    _totalDurationInMilliseconds = _durationInMilliSeconds;
  }

  void removeMinuteFromTime() {
    this.timerData.hourMinuteSecond =
        dataFormatter.removeMinuteFromTimer(this.timerData.hourMinuteSecond);
    this.timerData.milliSecond = "000";
    _durationInMilliSeconds = getMillisecondsFromTimer();
    _totalDurationInMilliseconds = _durationInMilliSeconds;
  }

  void resetTimer() {
    this.timerData.hourMinuteSecond =
        dataFormatter.resetTimer(this.timerData.hourMinuteSecond);
    this.timerData.milliSecond = "000";
    _durationInMilliSeconds = getMillisecondsFromTimer();
    _totalDurationInMilliseconds = _durationInMilliSeconds;
  }

  String getTimePercentageStr() {
    return getTimePercentage().toStringAsFixed(2);
  }

  int getTimePercentageInt() {
    return getTimePercentage().round();
  }

  double getTimePercentage() {
    return _durationInMilliSeconds / _totalDurationInMilliseconds * 100;
  }

  int getMillisecondsFromTimer() {
    return dataFormatter.getMillisecondsFromTimer(timerData.hourMinuteSecond);
  }

  bool isMinimalPossibleTime() {
    return _durationInMilliSeconds == 60000;
  }

  bool isMaximumPossibleTime() {
    return _durationInMilliSeconds == 3 * Consts.hourInMilliSeconds;
  }

  bool isTimeUp() {
    return _durationInMilliSeconds == 0;
  }

  // void stopTimer() {
  //   _timer.cancel();
  // }
}
