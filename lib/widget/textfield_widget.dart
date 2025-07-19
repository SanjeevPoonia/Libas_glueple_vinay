
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget
{
  final String title,initialValue;
  var controller;
 /* var controller;
  final String? Function(String?)? validator;*/
  TextFieldWidget(this.title,this.initialValue,{this.controller});
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                height: 0.5,
                color: Color(0xFF00407E),
              )),
        ),

        SizedBox(height: 10),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black,width: 0.4)
          ),
          child: TextFormField(
            controller: controller,
            decoration:  InputDecoration(
              border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
                hintText: initialValue,
                hintStyle: TextStyle(
                    fontSize: 14
                )
            ),
          ),
        ),

      ],
    );
  }

}