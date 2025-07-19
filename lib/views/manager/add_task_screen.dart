import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ChecklistTree/widget/appbar_widget.dart';
import 'package:ChecklistTree/widget/textfield_widget.dart';
import '../../utils/app_theme.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<AddTaskScreen> {
  int selectedRadioIndex=9999;
  bool pageNavigator=false;
  bool check=false;
  int selectedOption=0;

  List<String> sopList=[
    "SOP 1",
    "SOP 2",
  ];
  List<String> assetsList=[
    "Assets 1",
    "Assets 2",
  ];
  String? selectedSOP;
  String? selectedAssets;
  bool _switchValue = true;
  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(

        body:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarWidget("New Task"),
            
            SizedBox(height: 10),


            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF00407E),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Select SOP"),
                    TextSpan(
                      text: " *",
                      style: const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12,right: 12),
              child: DropdownButton2(
                isExpanded: true,
                menuItemStyleData: const MenuItemStyleData(
                  //height: 40,
                  padding: EdgeInsets.only(left: 5, right: 5),
                ),
                iconStyleData: IconStyleData(
                  icon: const Icon(
                      Icons
                          .keyboard_arrow_down_rounded),
                ),

                hint: Text(
                  'Select campaign',
                  style:
                  TextStyle(
                    fontSize:
                    13,
                    color: Theme
                        .of(
                        context)
                        .hintColor,
                  ),
                ),
                items: sopList
                    .map((item) =>
                    DropdownMenuItem<
                        String>(
                      value: item,
                      child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow
                              .visible
                      ),
                    ))
                    .toList(),
                value:
                selectedSOP,
                onChanged:
                    (value) {
                  selectedSOP =
                  value
                  as String;



                  setState(() {

                  });


                  // Fetch Address ID

                  // API CALL


                },

              ),
            ),



            SizedBox(height: 15),
            
            TextFieldWidget("Task Name","Enter task name"),


            SizedBox(height: 20),


            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF00407E),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Select Assets"),
                    TextSpan(
                      text: " *",
                      style: const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12,right: 12),
              child: DropdownButton2(
                isExpanded: true,
                menuItemStyleData: const MenuItemStyleData(
                  //height: 40,
                  padding: EdgeInsets.only(left: 5, right: 5),
                ),
                iconStyleData: IconStyleData(
                  icon: const Icon(
                      Icons
                          .keyboard_arrow_down_rounded),
                ),

                hint: Text(
                  'Select assets',
                  style:
                  TextStyle(
                    fontSize:
                    13,
                    color: Theme
                        .of(
                        context)
                        .hintColor,
                  ),
                ),
                items: assetsList
                    .map((item) =>
                    DropdownMenuItem<
                        String>(
                      value: item,
                      child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow
                              .visible
                      ),
                    ))
                    .toList(),
                value:
                selectedAssets,
                onChanged:
                    (value) {
                      selectedAssets =
                  value
                  as String;



                  setState(() {

                  });


                  // Fetch Address ID

                  // API CALL


                },

              ),
            ),



            SizedBox(height: 15),


            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 13,
                    height: 0.5,
                    color: Color(0xFF00407E),
                  )),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: TextFormField(
                maxLines: 3,
                decoration:  InputDecoration(
                    hintText: "Enter description",
                    hintStyle: TextStyle(
                        fontSize: 14
                    )
                ),
              ),
            ),


            SizedBox(height: 15),



            Row(
              children: [

                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF00407E),
                        fontWeight: FontWeight.w500
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: "Start immediately"),
                       /* TextSpan(
                          text: " *",
                          style: const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                              color: Colors.red),
                        ),*/
                      ],
                    ),
                  ),
                ),

                Spacer(),

                CupertinoSwitch(
                  value: _switchValue,
                  onChanged: (value) {
                    setState(() {
                      _switchValue = value;
                    });
                  },
                ),

                SizedBox(width: 12,)

              ],
            ),


            SizedBox(height: 25),

            InkWell(
              onTap: () {

              },
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      color: AppTheme.themeColor,
                      borderRadius: BorderRadius.circular(5)),
                  height: 49,
                  child: const Center(
                    child: Text('Create Task',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  )),
            )












          ],
        ),
      ),
    );
  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
}
