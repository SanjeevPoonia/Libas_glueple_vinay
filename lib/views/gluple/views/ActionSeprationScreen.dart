import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../utils/app_theme.dart';

class ActionSeparationScreen extends StatefulWidget{
  String employeeId;
  String separationType;
  String reasonSeparation;
  String actualRelievingDate;
  String requestedRelievingDate;
  String noticePeriod;

  ActionSeparationScreen(
      this.employeeId,
      this.separationType,
      this.reasonSeparation,
      this.actualRelievingDate,
      this.requestedRelievingDate,
      this.noticePeriod);

  _actionSeparationScreen createState()=>_actionSeparationScreen();
}
class _actionSeparationScreen extends State<ActionSeparationScreen>{
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar  (
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left_outlined, color: Colors.black,size: 35,),
          onPressed: () => {
            Navigator.of(context).pop()
          },
        ),
        backgroundColor: AppTheme.at_details_header,
        title:  const Text(
          "Separation Request",
          style: TextStyle(
              fontSize: 18.5,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }

}