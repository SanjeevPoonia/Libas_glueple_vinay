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

class ApplyQDAttendanceCorrection extends StatefulWidget{
  final String alDate;
  final String alCheckIn;
  final String alcheckOut;
  final String attStatus;
  ApplyQDAttendanceCorrection({required this.alDate,required this.alCheckIn,required this.alcheckOut,required this.attStatus});
  _qdAttendanceCorrection createState()=>_qdAttendanceCorrection();
}
class _qdAttendanceCorrection extends State<ApplyQDAttendanceCorrection>{
  String dateRageStr="Please Select Date";
  String applyDate="";
  String selectedInTime="";
  String selectedOutTime="";
  String checkInTime="";
  String checkOutTime="";
  bool isLoading=false;
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;

  var reasonController = TextEditingController();
  var reasonOutController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  int lastMonthLength=0;
  String HODName="";
  int ShowCorrectionCount=0;

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
          "Attendance Correction",
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
      body:isLoading?const Center(): SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(color: AppTheme.otpColor,width: 2.0),
                          color: AppTheme.themeColor

                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child:
                          Text("Correction Count : $ShowCorrectionCount",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white,fontSize: 17.5,
                                fontWeight: FontWeight.bold),)),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),


                    Row(
                      children: [
                        Expanded(child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text("Date",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                            SizedBox( height: 5,),
                            InkWell(
                              onTap: (){
                                //_showDatePicker();
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(color: AppTheme.greyColor,width: 2.0),
                                    color: AppTheme.otpColor

                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(child: Text(dateRageStr,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                        SizedBox(width: 5,),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Attendance Status",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                            SizedBox( height: 5,),
                            InkWell(
                              onTap: (){
                                // _showDatePicker();
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(color: AppTheme.greyColor,width: 2.0),
                                    color: AppTheme.otpColor

                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(child: Text(widget.attStatus,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                        children: [
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text("Actual Check In",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                              SizedBox( height: 5,),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppTheme.otpColor,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: AppTheme.greyColor,
                                    width: 2.0,
                                  ),

                                ),
                                child: Text(widget.alCheckIn,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),),),
                            ],),),
                          SizedBox(width: 5,),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Actual Check Out",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                              SizedBox( height: 5,),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppTheme.otpColor,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: AppTheme.greyColor,
                                    width: 2.0,
                                  ),

                                ),
                                child: Text(widget.alcheckOut,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),),),
                            ],
                          )),]
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text("Choose In Time",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                            SizedBox( height: 5,),
                            InkWell(
                              onTap: (){
                                _showInTimePicker();
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
                                    Expanded(child: Text(selectedInTime,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),)),
                                    SizedBox(width: 5,),
                                    SvgPicture.asset('assets/ic_clock_icon.svg',height: 21,width: 18,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                        SizedBox(width: 5,),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Choose Out Time",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                            SizedBox( height: 5,),
                            InkWell(
                              onTap: (){
                                _showOutTimePicker();
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
                                    Expanded(child: Text(selectedOutTime,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),)),
                                    SizedBox(width: 5,),
                                    SvgPicture.asset('assets/ic_clock_icon.svg',height: 21,width: 18,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                    SizedBox(height: 10,),

                    Text("Reason Check In",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
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
                        scrollPadding: EdgeInsets.only(bottom: 250),
                        maxLength: 500,
                        decoration: InputDecoration(
                            border: InputBorder.none
                        ),
                      ),

                    ),
                    SizedBox(height: 10,),
                    Text("Reason Check Out",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                    SizedBox( height: 5,),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: AppTheme.greyColor,width: 2.0),

                      ),
                      child: TextField(
                        controller: reasonOutController,
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        maxLength: 500,
                        scrollPadding: EdgeInsets.only(bottom: 150),
                        decoration: InputDecoration(
                            border: InputBorder.none
                        ),
                      ),

                    ),

                    SizedBox(height: 10,),
                    TextButton(
                        onPressed: (){
                          // Navigator.of(context).pop();
                          _checkTheValidation();
                          //call attendance punch in or out
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
      ),
    );

  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _buildListItems();
    });


  }

  _showDatePicker() async{
    var nowDate=DateTime.now();
    var firstDate=DateTime(nowDate.year,nowDate.month-1,1);
    var lastDate=DateTime(nowDate.year,nowDate.month,nowDate.day-1);

    DateTime? pickedDate=await showDatePicker(context: context, firstDate: firstDate, lastDate: lastDate);
    if(pickedDate !=null){
      applyDate= DateFormat("yyyy-MM-dd").format(pickedDate);
      var tDate= DateFormat("dd MMM yyyy").format(pickedDate);
      setState(() {
        dateRageStr=tDate;
      });
    }
  }
  _showInTimePicker()async{
    Toast.show("Please Select In Time!!!",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.red);
    var pickedTime= await showTimePicker(context: context, initialTime: TimeOfDay(hour: 09, minute: 00));
    if(pickedTime !=null){


      var datetime=DateFormat("hh:mm").parse("${pickedTime.hour}:${pickedTime.minute}");
      var selectedtime=DateFormat("hh:mm a").format(datetime);
      checkInTime=DateFormat("HH:mm:ss").format(datetime);
      print("Check In Time"+checkInTime);


      setState(() {
        selectedInTime=selectedtime;
      });


      // _showOutTimePicker();

    }
  }
  _showOutTimePicker()async{
    Toast.show("Please Select Out Time!!!",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.red);
    var pickedTime= await showTimePicker(context: context, initialTime: TimeOfDay(hour: 18, minute: 00));
    if(pickedTime !=null){
      var datetime=DateFormat("hh:mm").parse("${pickedTime.hour}:${pickedTime.minute}");
      var selectedtime=DateFormat("hh:mm a").format(datetime);
      checkOutTime=DateFormat("HH:mm:ss").format(datetime);
      print("Check Out time"+checkOutTime);


      setState(() {
        selectedOutTime=selectedtime;
      });

    }
  }
  _checkTheValidation(){
    FocusScope.of(context).unfocus();
    if(applyDate.isEmpty){
      Toast.show("Please Select Date",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(checkInTime.isEmpty){
      Toast.show("Please Select Check In Time",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(checkOutTime.isEmpty){
      Toast.show("Please Select Check Out Time",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(reasonController.text.isEmpty || reasonController.text.length<5){
      Toast.show("Please enter the Reason for Check In Correction.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(reasonOutController.text.isEmpty || reasonOutController.text.length<5){
      Toast.show("Please enter the Reason for Check Out Correction.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(ShowCorrectionCount>4){
      _showAlertDialog();
    }else{
      _applyCorrectionOnServer();
    }
  }
  _applyCorrectionOnServer()async{


    APIDialog.showAlertDialog(context, 'Please Wait...');
    var requestModel = {
      "emp_id": empId,
      "date":applyDate,
      "requested_check_in_time":checkInTime,
      "requested_check_out_time":checkOutTime,
      "requested_check_in_reason":reasonController.text.toString(),
      "requested_check_out_reason":reasonOutController.text.toString(),
      "type":"both"

    };
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(baseUrl, 'attendance_management/employeeAttendanceCorrectionApply',requestModel,context, token);
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
  _buildListItems() async{


    print("already Date"+widget.alDate);
    print("already Check In"+widget.alCheckIn);
    print("already Check Out"+widget.alcheckOut);

    APIDialog.showAlertDialog(context, "Please Wait...");
    setState(() {
      isLoading=true;
    });
    var nDate=DateFormat("yyyy-MM-dd").parse(widget.alDate);
    applyDate= widget.alDate;
    var tDate= DateFormat("dd MMM yyyy").format(nDate);
    dateRageStr=tDate;
    if(widget.alCheckIn!="00:00:00" && widget.alCheckIn!="0" && widget.alCheckIn!="Invalid date"){
      var chInTime=DateFormat("HH:mm:ss").parse(widget.alCheckIn);
      var selectedtime=DateFormat("hh:mm a").format(chInTime);
      checkInTime=widget.alCheckIn;
      selectedInTime=selectedtime;
      print("Check In Time"+checkInTime);
    }

    if(widget.alcheckOut!="00:00:00" && widget.alcheckOut!="0" && widget.alcheckOut!="Invalid date"){
      var chOutTime=DateFormat("HH:mm:ss").parse(widget.alcheckOut);
      var selectedtime=DateFormat("hh:mm a").format(chOutTime);
      checkOutTime=widget.alcheckOut;
      selectedOutTime=selectedtime;
      print("Check out Time"+checkOutTime);
    }







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

    getCorrectionCount();

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

  getCorrectionCount() async{

     APIDialog.showAlertDialog(context, "Please wait...");
    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithBase(baseUrl,"attendance_management/correction-counter?emp_id="+empId, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {

      if(responseJSON['data']['lastMonthLength']!=null){
        lastMonthLength=responseJSON['data']['lastMonthLength'];
      }
      if(responseJSON['data']['hod']!=null){
        HODName=responseJSON['data']['hod'].toString();
      }


      ShowCorrectionCount=lastMonthLength+1;

      setState(() {

      });

    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

      setState(() {

      });

    }

  }

  _showAlertDialog(){
    showDialog(context: context, builder: (ctx)=> AlertDialog(
      title: const Text("Are you sure to submit?",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 18),),
      content:  Text("Your Correction request goes to the Functional Head($HODName) for Approval",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16,color: Colors.black),),
      actions: <Widget>[
        TextButton(
            onPressed: (){
              Navigator.of(ctx).pop();
              _applyCorrectionOnServer();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.themeColor,
              ),
              height: 45,
              padding: const EdgeInsets.all(10),
              child: const Center(child: Text("Submit",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
            )
        ),
        TextButton(
            onPressed: (){
              Navigator.of(ctx).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.greyColor,
              ),
              height: 45,
              padding: const EdgeInsets.all(10),
              child: const Center(child: Text("No,Cancel it!",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
            )
        )
      ],
    ));
  }

}