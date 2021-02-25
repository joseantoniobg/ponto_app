import 'package:flutter/material.dart';

import 'control_round_button.dart';

class TimerControlArray extends StatelessWidget {
  final Function addMinute;
  final Function substractMinute;
  final Function resetTimer;

  const TimerControlArray({
    Key key,
    this.addMinute,
    this.substractMinute,
    this.resetTimer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ControlRoundButton(
            onPressed: addMinute,
            icon: Icons.arrow_drop_up,
            size: 30,
            buttonColor: Theme.of(context).primaryColor,
            iconColor: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          ControlRoundButton(
            onPressed: substractMinute,
            icon: Icons.arrow_drop_down,
            size: 30,
            buttonColor: Theme.of(context).primaryColor,
            iconColor: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          ControlRoundButton(
            onPressed: resetTimer,
            icon: Icons.settings_backup_restore,
            size: 30,
            buttonColor: Theme.of(context).primaryColor,
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
