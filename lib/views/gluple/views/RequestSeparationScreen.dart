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
import 'dart:io';
import 'package:intl/intl.dart';

class RequestSeparationScreen extends StatefulWidget{
  _requestSeparation createState()=>_requestSeparation();
}
class _requestSeparation extends State<RequestSeparationScreen>{
  bool isLoading=false;
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;
  late var platform;
  String actualRelievingDate="";
  String noticePeriod="";
  String currentDate="";
  String requestedRelievingDate="Select Date";

  var separationItems=['Select Separation Type','Resignation','Other'];
  String separationValue = 'Select Separation Type';
  String separationTitle = 'Select Separation Type';
  final _formKey = GlobalKey<FormState>();
  var reasonController = TextEditingController();

  String fromDate="";



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
          "Request Separation",
          style: TextStyle(
              fontSize: 18.5,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        centerTitle: true,
      ),
      body:isLoading?const Center():ListView(
        children: [
          Padding(padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Separation Type",
                  style: TextStyle(fontSize: 14.5,
                      color: AppTheme.themeColor,
                      fontWeight: FontWeight.w500),),
                SizedBox(height: 2,),
                Container(
                  width: double.infinity,
                  height: 45,
                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppTheme.greyColor,width: 2.0),

                  ),
                  child: DropdownButton(
                    items: separationItems.map((String items) {return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );}).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        separationValue = newValue!;
                      });
                    },
                    value: separationValue,
                    icon: Icon(Icons.keyboard_arrow_down,color: AppTheme.themeColor,size: 15,),
                    isExpanded: true,
                    underline: SizedBox(),
                  ),
                ),
                SizedBox(height: 20,),

                Row(
                  children: [
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Actual Relieving Date",
                          style: TextStyle(fontSize: 14.5,
                              color: AppTheme.themeColor,
                              fontWeight: FontWeight.w500),),
                        SizedBox(height: 10,),
                        InkWell(
                          onTap: (){
                            //_showFromDatePicker();
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
                                Expanded(child: Text(actualRelievingDate,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),)),
                                SizedBox(width: 5,),
                                SvgPicture.asset('assets/at_calendar.svg',height: 21,width: 18,),
                              ],
                            ),
                          ),
                        )

                      ],
                    )),
                    SizedBox(width: 5,),
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Request Relieving Date",
                          style: TextStyle(fontSize: 14.5,
                              color: AppTheme.themeColor,
                              fontWeight: FontWeight.w500),),
                        SizedBox(height: 10,),
                        InkWell(
                          onTap: (){
                            _showDatePicker();
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
                                Expanded(child: Text(requestedRelievingDate,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),)),
                                SizedBox(width: 5,),
                                SvgPicture.asset('assets/at_calendar.svg',height: 21,width: 18,),
                              ],
                            ),
                          ),
                        )

                      ],
                    )),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Notice Period(As per Offer Letter)",
                          style: TextStyle(fontSize: 14.5,
                              color: AppTheme.themeColor,
                              fontWeight: FontWeight.w500),),
                        SizedBox(height: 10,),
                        InkWell(
                          onTap: (){
                          },
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(color: AppTheme.greyColor,width: 2.0),

                            ),
                            child: Center(
                              child: Text(noticePeriod,textAlign:TextAlign.center,style: const TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),),
                            ),
                          ),
                        )

                      ],
                    )),

                  ],
                ),
                SizedBox( height: 20,),
                Text("Reason",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                SizedBox( height: 5,),
                Form(
                    key: _formKey,
                    child:  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: AppTheme.greyColor,width: 2.0),

                      ),
                      child: TextField(
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        controller: reasonController,
                        maxLength: 500,
                        decoration: InputDecoration(
                            border: InputBorder.none
                        ),
                      ),

                    )),

                SizedBox(height: 10,),
                TextButton(
                    onPressed: (){
                      checkValidation();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppTheme.orangeColor,
                      ),
                      height: 45,
                      padding: const EdgeInsets.all(10),
                      child: const Center(child: Text("Apply",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                    )
                ),





              ],
            ),),
        ],
      ) ,
    );
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


    getSepartionDetails();
  }
  getSepartionDetails() async {
    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl, 'employee_separation/getBasicDetailForSeparation', token, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {


      List<dynamic> tempList=[];
      tempList=responseJSON['data'];



      for(int i=0;i<tempList.length;i++){
        if(tempList[i]['notice_period']!=null){
          noticePeriod=tempList[i]['notice_period'].toString();
        }
        if(tempList[i]['actual_relieving_date']!=null){
          actualRelievingDate=tempList[i]['actual_relieving_date'].toString();
        }
        if(tempList[i]['current_date']!=null){
          currentDate=tempList[i]['current_date'].toString();
        }
      }
      setState(() {
        isLoading=false;
      });
    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

      setState(() {
        isLoading=false;
      });
    }
  }
  _showDatePicker() async{

    var nowDate=DateTime.now();
    var lastDate=DateTime(nowDate.year,nowDate.month+3,nowDate.day);

    DateTime? pickedDate=await showDatePicker(context: context, firstDate: nowDate, lastDate: lastDate);
    if(pickedDate !=null){
      fromDate= DateFormat("yyyy-MM-dd").format(pickedDate);
      setState(() {
        requestedRelievingDate=fromDate;
      });
    }
  }
  checkValidation(){

    if(separationValue!=separationTitle){
      if(requestedRelievingDate!="Select Date"){
        if(reasonController.text.isNotEmpty){
          _submitSeparationOnServer();
        }else{
          Toast.show("Please Enter a valid Reason",
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
        }
      }else{
        Toast.show("Please Select Request Relieving Date",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }

    }else{
      Toast.show("Please Select Separation Type",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }



  }
  _submitSeparationOnServer()async{
    APIDialog.showAlertDialog(context, 'Please Wait...');
    var requestModel = {
      "separation_type": separationValue,
      "resignation_reason":reasonController.text.toString(),
      "actual_relieving_date":actualRelievingDate,
      "request_relieving_date":requestedRelievingDate,
      "notice_period":noticePeriod,
    };
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(baseUrl, 'employee_separation/applyForSaperation',requestModel,context, token);
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