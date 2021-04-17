import 'package:flutter/material.dart';

/*
Title: TextButtonWidget
Purpose:TextButtonWidget
Created By:Kalpesh Khandla
*/

class TextButtonWidget extends StatelessWidget {
  final String btnTxt;
  final Color btnBackColor;
  final Color textColor;
  final Function() btnOnTap;

  TextButtonWidget({
    Key key,
    @required this.btnTxt,
    @required this.btnBackColor,
    @required this.textColor,
    @required this.btnOnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height, width;
    height = MediaQuery.of(context).size.height;
    return Container(
      height: height * .15 / 2,
      decoration: BoxDecoration(
        color: btnBackColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: () {
          btnOnTap();
        },
        child: Center(
          child: Text(
            btnTxt,
            style: Theme.of(context).textTheme.caption.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
          ),
        ),
      ),
    );
  }
}
