import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class AddSpentTime_Screen extends StatefulWidget{
  String taskId;
  AddSpentTime_Screen(this.taskId);
  _addSpentTime createState()=>_addSpentTime();
}
class _addSpentTime extends State<AddSpentTime_Screen>{
  bool isLoading=false;
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;
  late var platform;
  final _formKey = GlobalKey<FormState>();
  var descriptionController = TextEditingController();
  var weekController=TextEditingController();
  var dayController=TextEditingController();
  var hourController=TextEditingController();
  var minuteController=TextEditingController();
  String taskDate="";
  String taskDateStr="Select Date";
  String selectedDescription="";

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
        title: const Text(
          "Add Time Tracking",
          style: TextStyle(
              fontSize: 18.5,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        /*actions: [IconButton(onPressed: (){
              _showAlertDialog();

            }, icon: SvgPicture.asset("assets/logout.svg"))] ,*/
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: isLoading?SizedBox():
      Padding(padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Time Spent(2w 4d 6h 45m)",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                    SizedBox( height: 5,),
                    Row(
                      children: [
                        Expanded(child:
                        TextFormField(
                          textAlign: TextAlign.start,
                          controller: weekController,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp('[a-zA-Z]')),
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppTheme.bottomDisabledColor,
                                  width: 2.0
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppTheme.orangeColor,
                                  width: 2.0
                              ),
                            ),
                            hintText: 'W',
                            hintStyle: TextStyle(
                                color: AppTheme.at_lightgray
                            ),
                          ),
                        )
                        ),
                        SizedBox(width: 2,),
                        Text('w',style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),),
                        SizedBox(width: 5,),

                        Expanded(child:
                        TextFormField(
                          textAlign: TextAlign.start,
                          controller: dayController,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp('[a-zA-Z]')),
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppTheme.bottomDisabledColor,
                                  width: 2.0
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppTheme.orangeColor,
                                  width: 2.0
                              ),
                            ),
                            hintText: 'd',
                            hintStyle: TextStyle(
                                color: AppTheme.at_lightgray
                            ),
                          ),
                        )
                        ),
                        SizedBox(width: 2,),
                        Text('d',style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),),
                        SizedBox(width: 5,),

                        Expanded(child:
                        TextFormField(
                          textAlign: TextAlign.start,
                          controller: hourController,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp('[a-zA-Z]')),
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppTheme.bottomDisabledColor,
                                  width: 2.0
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppTheme.orangeColor,
                                  width: 2.0
                              ),
                            ),
                            hintText: 'h',
                            hintStyle: TextStyle(
                                color: AppTheme.at_lightgray
                            ),
                          ),
                        )
                        ),
                        SizedBox(width: 2,),
                        Text('h',style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),),
                        SizedBox(width: 5,),

                        Expanded(child:
                        TextFormField(
                          textAlign: TextAlign.start,
                          controller: minuteController,
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp('[a-zA-Z]')),
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppTheme.bottomDisabledColor,
                                  width: 2.0
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppTheme.orangeColor,
                                  width: 2.0
                              ),
                            ),
                            hintText: 'm',
                            hintStyle: TextStyle(
                                color: AppTheme.at_lightgray
                            ),
                          ),
                        )
                        ),
                        SizedBox(width: 2,),
                        Text('m',style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),),
                        SizedBox(width: 5,),
                      ],
                    ),
                    SizedBox(height: 10,),


                    Text("Date Started",
                      style: TextStyle(fontSize: 14.5,
                          color: AppTheme.themeColor,
                          fontWeight: FontWeight.w500),),
                    SizedBox(height: 10,),
                    InkWell(
                      onTap: (){
                        _showFromDatePicker();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(color: AppTheme.greyColor,width: 2.0),

                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: Text(taskDateStr,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),)),
                            SizedBox(width: 5,),
                            SvgPicture.asset('assets/at_calendar.svg',height: 21,width: 18,),
                          ],
                        ),
                      ),
                    ),



                    SizedBox(height: 10,),
                    Text("Description*",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                    SizedBox( height: 5,),
                    TextFormField(
                      textAlign: TextAlign.start,
                      controller: descriptionController,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      maxLength: 500,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppTheme.bottomDisabledColor,
                              width: 2.0
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppTheme.orangeColor,
                              width: 2.0
                          ),
                        ),
                        hintText: 'Description',
                        hintStyle: TextStyle(
                            color: AppTheme.at_lightgray
                        ),
                      ),
                    ),


                    SizedBox(height: 10,),
                    TextButton(
                        onPressed: (){
                          _submitHandler();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.orangeColor,
                          ),
                          height: 45,
                          child: const Center(child: Text("Submit",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                        )
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),),
    );
  }

  _showFromDatePicker() async{

    var nowDate=DateTime.now();
    var lastDate=DateTime(nowDate.year,nowDate.month+2,1);
    var firstDate=DateTime(nowDate.year,nowDate.month-1,1);

    DateTime? pickedDate=await showDatePicker(context: context, firstDate: firstDate, lastDate: nowDate);
    if(pickedDate !=null){
      taskDate= DateFormat("yyyy-MM-dd").format(pickedDate);
      setState(() {
        taskDateStr=taskDate;
      });
    }
  }
  _submitHandler(){
    selectedDescription=descriptionController.text;
    String week=weekController.text;
    String day=dayController.text;
    String hour=hourController.text;
    String minute=minuteController.text;
    if(week.isEmpty && day.isEmpty && hour.isEmpty && minute.isEmpty){
      Toast.show("Please Enter Spent Time.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(selectedDescription.isEmpty || selectedDescription==""){
      Toast.show("Please Enter Description.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(taskDate.isEmpty){
      Toast.show("Please Select Task Date",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else{
        _submitTaskOnServer();
    }

  }
  _submitTaskOnServer()async{
    APIDialog.showAlertDialog(context, "Please Wait...");
    String originalEsti="";

    String week=weekController.text;
    String day=dayController.text;
    String hour=hourController.text;
    String minute=minuteController.text;
    if(week.isEmpty){
      week='0w';
    }else{
      week='${week}w';
    }
    if(day.isEmpty){
      day='0d';
    }else{
      day='${day}d';
    }
    if(hour.isEmpty){
      hour='0h';
    }else{
      hour='${hour}h';
    }
    if(minute.isEmpty){
      minute='0m';
    }else{
      minute='${minute}m';
    }
    originalEsti='$week $day $hour $minute';
    var requestModel = {
      "type": 'worklog',
      "task_id": widget.taskId,
      "value": originalEsti,
      "history_date": taskDate,
      "description": selectedDescription,
    };
    ApiBaseHelper helper= ApiBaseHelper();
    var response = await helper.postAPIWithHeader(baseUrl, 'tasks/save-time-tracking',requestModel,context, token);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      if(responseJSON['code']==200){
        _showCustomDialog(responseJSON['message']);
      }
    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  _finishTheScreen(){
    Navigator.of(context).pop();
  }
  _showCustomDialog(String msg){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 350,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                          _finishTheScreen();
                        },
                        child: Icon(Icons.close_rounded,color: Colors.red,size: 20,),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 100,
                      width: double.infinity,
                      child: Lottie.asset("assets/api_done_anim.json"),
                    ),
                    SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.center,
                      child: Text(msg,style: TextStyle(color: AppTheme.orangeColor,fontWeight: FontWeight.w900,fontSize: 18),),
                    ),
                    SizedBox(height: 20,),
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          _finishTheScreen();
                          //call attendance punch in or out
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.themeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(child: Text("Done",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
                        )
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _buildListItems();
    });


  }
  _buildListItems() async{
    APIDialog.showAlertDialog(context, "Please Wait...");
    setState(() {
      isLoading=true;
    });
    userIdStr=await MyUtils.getSharedPreferences("user_id");
    fullNameStr=await MyUtils.getSharedPreferences("full_name");
    token=await MyUtils.getSharedPreferences("token");
    designationStr=await MyUtils.getSharedPreferences("designation");
    empId=await MyUtils.getSharedPreferences("emp_id");
    baseUrl=await MyUtils.getSharedPreferences("base_url");
    if(Platform.isAndroid){
      platform="Android";
    }else if(Platform.isIOS){
      platform="iOS";
    }else{
      platform="Other";
    }
    Navigator.pop(context);
    setState(() {
      isLoading=false;
    });
  }

}