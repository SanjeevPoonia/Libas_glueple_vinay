import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import 'package:intl/intl.dart';

class HolidayScreen extends StatefulWidget{
  _holidayList createState()=>_holidayList();
}
class _holidayList extends State<HolidayScreen>{
  bool isLoading=false;
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;
  List<dynamic> holidayList=[];

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
          "Holiday",
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
      holidayList.length==0?Align(alignment: Alignment.center,child: Text("No Holiday Available",style: TextStyle(fontSize: 17.5,color: AppTheme.orangeColor,fontWeight: FontWeight.w900),),):
      ListView.builder(
          shrinkWrap: true,
          itemCount: holidayList.length,
          itemBuilder: (BuildContext cntx, int index){
            String fromDate="";
            String toDate="";
            String noDays="";
            String dayStr="";
            String holiday="";



            var backColor=AppTheme.task_progress_back;
            var textColor= AppTheme.themeColor;





            if(holidayList[index]['holiday_from']!=null){
              var dateTime=DateFormat("dd-MM-yyyy").parse(holidayList[index]['holiday_from']);
              fromDate=DateFormat("MMM d,yyyy").format(dateTime);
            }
            if(holidayList[index]['holiday_to']!=null){
              var dateTime=DateFormat("dd-MM-yyyy").parse(holidayList[index]['holiday_to']);
              toDate=DateFormat("MMM d,yyyy").format(dateTime);

            }
            if(holidayList[index]['days']!=null){
              noDays=holidayList[index]['days'].toString();
            }
            if(holidayList[index]['day']!=null){
              dayStr=holidayList[index]['day'];
            }
            if(holidayList[index]['holiday']!=null){
              holiday=holidayList[index]['holiday'];
            }
            return Stack(children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(

                  children: [
                    const SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                          border: Border.all(color: AppTheme.orangeColor,width: 1.0)
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 7,right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15,),

                            Text("$fromDate - $toDate",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppTheme.themeColor
                            ),),
                            SizedBox(height: 10,),
                            Text(holiday,style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppTheme.orangeColor
                            ),),
                            const SizedBox(height: 10,),
                          ],
                        ),
                      ),

                    ),
                    const SizedBox(height: 10,),
                  ],

                ) ,),
              Positioned(
                right: 15,
                top: 10,
                child:  Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: backColor),
                  width: 80,
                  height: 30,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Days:- $noDays",
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ),

                ),),
            ],);

          }
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _getDashboardData();
    });
  }
  _getDashboardData() async {
    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    userIdStr=await MyUtils.getSharedPreferences("user_id");
    fullNameStr=await MyUtils.getSharedPreferences("full_name");
    token=await MyUtils.getSharedPreferences("token");
    designationStr=await MyUtils.getSharedPreferences("designation");
    empId=await MyUtils.getSharedPreferences("emp_id");
    baseUrl=await MyUtils.getSharedPreferences("base_url");
    Navigator.of(context).pop();
    getLeaveList();
  }
  getLeaveList() async {

    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl, 'attendance_management/holidays', token, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      holidayList.clear();
      holidayList=responseJSON['data']['holidays_list'];
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
      _finishScreens();
    }
  }

  _finishScreens(){
    Navigator.pop(context);
  }

}