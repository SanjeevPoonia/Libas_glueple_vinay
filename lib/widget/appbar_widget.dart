

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget
{
  final String title;
  AppBarWidget(this.title);
  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
      ),
      child: Container(
        height: 69,
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);

                },
                child:Icon(Icons.keyboard_backspace_rounded)),


            Text(title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                )),

            Image.asset("assets/bell_ic.png",width: 23,height: 23)


          ],
        ),
      ),
    );
  }

}

class AppBarWidget2 extends StatelessWidget
{
  final String title;
  AppBarWidget2(this.title);
  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
      ),
      child: Container(
        height: 69,
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);

                },
                child:Icon(Icons.keyboard_backspace_rounded)),


            Text(title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                )),

            Image.asset("assets/bell_ic.png",width: 23,height: 23)


          ],
        ),
      ),
    );
  }

}