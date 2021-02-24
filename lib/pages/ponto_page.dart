import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ponto_app/features/Time.dart';
import 'package:ponto_app/util/consts.dart';
import 'package:ponto_app/widgets/control_round_button.dart';

class PontoPage extends StatefulWidget {
  PontoPage({Key key}) : super(key: key);

  @override
  _PontoPageState createState() => _PontoPageState();
}

class _PontoPageState extends State<PontoPage> {
  Time timer =
      new Time(new TimerData(hourMinuteSecond: "00:01:00", milliSecond: "000"));
  final player = AudioPlayer();
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

  void startTimer() {
    clickWatch = new Timer.periodic(Consts.decSecond, (clickWatch) async {
      timer.setCurrentRemainingTime();

      setState(() {
        timer.runTimeInDecSeconds();
      });

      if (timer.isTimeUp()) {
        playAlarm();
        clickWatch.cancel();
      }
    });
  }

  void playAlarm() async {
    setState(() {
      isPlaying = true;
    });
    await player.setAsset('assets/alarm.mp3');
    await player.setLoopMode(LoopMode.one);
    await player.play();
  }

  void pauseAlarm() async {
    setState(() {
      isPlaying = false;
    });
    await player.stop();
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
            Container(
              height: MediaQuery.of(context).size.height / 5,
              child: Center(
                child: Text(
                  'O seu aviso diário de Ponto',
                  style: TextStyle(
                    fontSize: 50,
                    height: .96,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height / 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ControlRoundButton(
                    onPressed: () {
                      _addMinuteToTime(cont);
                    },
                    icon: Icons.arrow_drop_up,
                    size: 30,
                    buttonColor: Theme.of(context).primaryColor,
                    iconColor: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ControlRoundButton(
                    onPressed: () {
                      _removeMinuteFromTime(cont);
                    },
                    icon: Icons.arrow_drop_down,
                    size: 30,
                    buttonColor: Theme.of(context).primaryColor,
                    iconColor: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ControlRoundButton(
                    onPressed: _resetTimer,
                    icon: Icons.settings_backup_restore,
                    size: 30,
                    buttonColor: Theme.of(context).primaryColor,
                    iconColor: Colors.white,
                  ),
                ],
              ), //Placeholder(),
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
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * .9,
                height: MediaQuery.of(context).size.height / 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 10,
                        top: 15,
                      ),
                      child: CircularPercentIndicator(
                        radius: 190.0,
                        lineWidth: 15.0,
                        percent: timer.getTimePercentage() / 100,
                        footer: new Text(
                          timer.getTimePercentageStr() + " %",
                          style: TextStyle(
                            fontSize: 20,
                            height: 1.8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.green[700],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: ControlRoundButton(
                        onPressed: isWatchActive() ? cancelTimer : startTimer,
                        icon: isWatchActive() ? Icons.pause : Icons.play_arrow,
                        size: 100,
                        buttonColor: Colors.orange,
                        iconColor: Colors.white,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 60,
                        left: 90,
                      ),
                      child: ControlRoundButton(
                        onPressed: isPlaying ? pauseAlarm : null,
                        icon: Icons.close,
                        size: 30,
                        buttonColor: Colors.red,
                        iconColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 5,
              child: Placeholder(),
            ),
          ],
        ),
      ),
    );
  }
}
