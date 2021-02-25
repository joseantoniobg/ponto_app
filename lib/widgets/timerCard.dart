import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../features/Time.dart';
import 'control_round_button.dart';

class TimerCard extends StatelessWidget {
  final isPlaying;
  final Time timer;
  final Function cancelTimer;
  final Function startTimer;
  final Function isWatchActive;
  final Function pauseAlarm;

  const TimerCard({
    Key key,
    this.isPlaying,
    this.timer,
    this.cancelTimer,
    this.startTimer,
    this.isWatchActive,
    this.pauseAlarm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                top: 80,
                left: 90,
              ),
              child: ControlRoundButton(
                onPressed: isPlaying ? pauseAlarm : null,
                icon: Icons.close,
                size: 20,
                buttonColor: Colors.red,
                iconColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
