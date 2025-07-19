
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class APIDialog
{
  static Future<void> showAlertDialog(BuildContext context,String dialogText) async {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.themeColor),
          ),
          Container(margin: EdgeInsets.only(left: 9), child: Text(dialogText,maxLines:2,style: TextStyle(color:Colors.blueGrey,fontFamily: 'OpenSans'),)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


}






