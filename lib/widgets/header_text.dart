import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final headText;

  const HeaderText({Key key, this.headText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      height: MediaQuery.of(context).size.height / 7,
      child: Center(
        child: Text(
          headText,
          style: TextStyle(
            fontSize: 50,
            height: .96,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
