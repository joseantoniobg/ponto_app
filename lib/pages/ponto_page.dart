import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:ponto_app/features/Time.dart';
import 'package:ponto_app/util/consts.dart';
import 'package:ponto_app/widgets/header_text.dart';
import 'package:ponto_app/widgets/timerCard.dart';
import 'package:ponto_app/widgets/timer_control_array.dart';
import 'package:vibration/vibration.dart';

class PontoPage extends StatefulWidget {
  PontoPage({Key key}) : super(key: key);

  @override
  _PontoPageState createState() => _PontoPageState();
}

class _PontoPageState extends State<PontoPage> {
  Time timer =
      new Time(new TimerData(hourMinuteSecond: "00:00:05", milliSecond: "000"));
  AssetsAudioPlayer player = AssetsAudioPlayer();
  Timer clickWatch;
  bool isPlaying = false;

  _addMinuteToTime(BuildContext ctx) {
    setState(() {
      if (timer.isMaximumPossibleTime()) {
        final snackBar =
            SnackBar(content: Text('Esse é o maior tempo possível!'));
        Scaffold.of(ctx).hideCurrentSnackBar();
        Scaffold.of(ctx).showSnackBar(snackBar);
        return;
      }
      timer.addMinuteTotime();
    });
  }

  _removeMinuteFromTime(BuildContext ctx) {
    setState(() {
      if (timer.isTimeUp()) {
        timer.resetTimer();
      }
      if (timer.isMinimalPossibleTime()) {
        final snackBar =
            SnackBar(content: Text('Esse é o menor tempo possível!'));
        Scaffold.of(ctx).hideCurrentSnackBar();
        Scaffold.of(ctx).showSnackBar(snackBar);
        return;
      }
      timer.removeMinuteFromTime();
    });
  }

  _resetTimer() {
    setState(() {
      timer.resetTimer();
    });
  }

  void startTimer(BuildContext ctx) {
    if (timer.isTimeUp()) {
      timer.resetTimer();
    }

    clickWatch = new Timer.periodic(Consts.decSecond, (clickWatch) async {
      timer.setCurrentRemainingTime();

      setState(() {
        timer.runTimeInDecSeconds();
      });

      if (timer.isTimeUp()) {
        clickWatch.cancel();
        showTimeUpDialog(ctx);
        if (await Vibration.hasCustomVibrationsSupport()) {
          Vibration.vibrate(
            pattern: [1000, 500],
            intensities: [1, 255],
            repeat: 1,
          );
        }
        playAlarm();
      }
    });
  }

  void playAlarm() async {
    setState(() {
      isPlaying = true;
    });
    await player.open(Audio("assets/alarm.mp3"), loopMode: LoopMode.single);
    await player.play();
  }

  void showTimeUpDialog(BuildContext ctx) {
    CoolAlert.show(
      context: ctx,
      type: CoolAlertType.warning,
      title: "Atenção!",
      text: "Está na hora de bater o ponto!",
      onConfirmBtnTap: () {
        pauseAlarm();
        Navigator.of(ctx).pop();
      },
    );
  }

  void pauseAlarm() async {
    setState(() {
      isPlaying = false;
    });
    await player.stop();
    await Vibration.cancel();
  }

  void cancelTimer() {
    setState(() {
      if (isWatchActive()) {
        clickWatch.cancel();
      }
    });
  }

  bool isWatchActive() {
    if (clickWatch != null) {
      return clickWatch.isActive;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Builder(
        builder: (cont) => Column(
          children: [
            HeaderText(headText: 'O seu aviso diário de Ponto'),
            SizedBox(height: 10),
            TimerControlArray(
              addMinute: () => _addMinuteToTime(cont),
              resetTimer: _resetTimer,
              substractMinute: () => _removeMinuteFromTime(cont),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 7.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    timer.timerData.hourMinuteSecond,
                    style: TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      timer.timerData.milliSecond,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TimerCard(
              isPlaying: isPlaying,
              isWatchActive: isWatchActive,
              cancelTimer: cancelTimer,
              pauseAlarm: pauseAlarm,
              startTimer: () => startTimer(cont),
              timer: timer,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 5,
              child:
                  SizedBox(), //TO-DO quant de vezes que o usuario usou o app, Shared Preferences
            ),
          ],
        ),
      ),
    );
  }
}
