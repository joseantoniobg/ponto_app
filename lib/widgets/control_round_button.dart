import 'package:flutter/material.dart';

class ControlRoundButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final double size;
  final Color buttonColor;
  final Color iconColor;

  const ControlRoundButton({
    Key key,
    @required this.onPressed,
    @required this.icon,
    @required this.size,
    @required this.buttonColor,
    @required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: 2.0,
      color: buttonColor,
      disabledColor: Colors.grey,
      child: Icon(
        icon,
        size: size,
        color: iconColor,
      ),
      padding: EdgeInsets.all(12.0),
      minWidth: 0,
      shape: CircleBorder(),
    );
  }
}
