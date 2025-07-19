import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import 'package:intl/intl.dart';

class ApplyCOffScreen extends StatefulWidget{
  _applyCOffScreen createState()=> _applyCOffScreen();
}
class _applyCOffScreen extends State<ApplyCOffScreen>{
  bool isLoading=false;
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;

  final _formKey = GlobalKey<FormState>();
  var reasonController = TextEditingController();
  String sDate="";
  String showDate="";
  String dropdownvalue = 'Full Day';
  var items = [
    'Full Day',
    'Half Day',
  ];
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
          "Apply Week-Off",
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
      body: isLoading?const Center():ListView(
        children: [
          Padding(padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Text("Choose Date",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                  SizedBox( height: 5,),
                  InkWell(
                    onTap: (){
                      _showFromDatePicker();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: AppTheme.greyColor,width: 2.0),

                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Text(showDate,style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w500),)),
                          SizedBox(width: 5,),
                          SvgPicture.asset('assets/at_calendar.svg',height: 21,width: 18,),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                /*  Text("Choose C-OFF Status",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                  SizedBox( height: 5,),
                  Container(
                    width: double.infinity,
                    height: 45,
                    padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: AppTheme.greyColor,width: 2.0),

                    ),
                    child: DropdownButton(
                      items: items.map((String items) {return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );}).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                      value: dropdownvalue,
                      icon: Icon(Icons.keyboard_arrow_down,color: AppTheme.themeColor,size: 15,),
                      isExpanded: true,
                      underline: SizedBox(),
                    ),
                  ),
                  SizedBox(height: 10,),*/
                  Text("Reason",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                  SizedBox( height: 5,),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: AppTheme.greyColor,width: 2.0),

                    ),
                    child: TextField(
                      controller: reasonController,
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          border: InputBorder.none
                      ),
                    ),

                  ),
                  SizedBox(height: 10,),
                  TextButton(
                      onPressed: (){
                        _checkValidation();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppTheme.orangeColor,
                        ),
                        height: 45,
                        padding: const EdgeInsets.all(10),
                        child: const Center(child: Text("Submit For Approval",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                      )
                  ),





                ],
              ),
            ),),
        ],
      ),
    );

  }

  _checkValidation(){
    if(sDate.isEmpty){
      Toast.show("Please Select Date!!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(dropdownvalue.isEmpty){
      Toast.show("Please Select Comp-Off Status",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(reasonController.text.isEmpty || reasonController.text.length<5){
      Toast.show("Please Enter Valid Reason",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else{
      _submitTourOnServer();
    }
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
    Navigator.pop(context);
    setState(() {
      isLoading=false;
    });
  }
  _showFromDatePicker() async{
    Toast.show("Please Select  Date!!!",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.red);

    var nowDate=DateTime.now();
    var lastDate=DateTime(nowDate.year,nowDate.month+2,1);
    var firstDate=DateTime(nowDate.year,nowDate.month-1,1);

    DateTime? pickedDate=await showDatePicker(context: context, firstDate: firstDate, lastDate: lastDate);
    if(pickedDate !=null){
      setState(() {
        sDate= DateFormat("yyyy-MM-dd").format(pickedDate);
        showDate=DateFormat("dd MMM yyyy").format(pickedDate);
      });

    }
  }
  _submitTourOnServer()async{
    APIDialog.showAlertDialog(context, 'Please Wait...');
    var requestModel = {
      "date":sDate,
      "reason":reasonController.text.toString(),
    };
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(baseUrl, 'attendance_management/applyWeekOffApplication',requestModel,context, token);
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
  _showCustomDialog(String msg){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 300,
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

  _finishTheScreen(){
    Navigator.of(context).pop();
  }


}