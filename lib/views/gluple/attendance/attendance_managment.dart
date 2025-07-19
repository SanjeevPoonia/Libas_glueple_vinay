import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ChecklistTree/views/gluple/attendance/applied_correction_screen.dart';
import 'package:ChecklistTree/views/gluple/attendance/applied_tours_screen.dart';
import 'package:ChecklistTree/views/gluple/attendance/holiday_screen.dart';
import 'package:ChecklistTree/views/gluple/attendance/requested_coff_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../qd_attendance/QD_Applied_Correction_Screen.dart';
import '../utils/app_theme.dart';
import 'dart:io';

import '../views/attendance_details_screen.dart';
import '../views/login_screen.dart';
import 'applied_leaves_screen.dart';
import 'package:ChecklistTree/views/login_screen.dart';

class AttendanceManagementScreen extends StatefulWidget{
  _atManagmentScreen createState()=>_atManagmentScreen();
}
class _atManagmentScreen extends State<AttendanceManagementScreen>{
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;
  late var platform;
  late var isAttendanceAccess;
  var clientCode="";


  String daysPresent="0";
  String daysAbsent="0";
  String leaveTaken="0";
  String publicHoliday="0";
  String totalLoginHour="00:00:00";
  String averageLogin="00:00:00";
  String totalOTHours="0";

  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    return isLoading?const SizedBox():
    Padding(padding: EdgeInsets.symmetric(horizontal: 12),child: ListView(
      children: [
        const SizedBox(height: 10,),
        Row(
          children: [
            Expanded(child: Card(
              elevation: 5,
              color: AppTheme.cardColor,
              margin: EdgeInsets.all(5),
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image(image: AssetImage("assets/at_present.png"),width: 30,height: 30,),
                        SizedBox(width: 5,),
                        Expanded(child: Text(daysPresent,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: AppTheme.themeColor),))

                      ],
                    ),
                    SizedBox(height: 5,),
                    Text("Days Present",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 16),)
                  ],
                ),
              ),

            )),
            SizedBox(width: 5,),
            Expanded(child: Card(
              elevation: 5,
              color: AppTheme.cardColor,
              margin: EdgeInsets.all(5),
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image(image: AssetImage("assets/at_absent.png"),width: 30,height: 30,),
                        SizedBox(width: 5,),
                        Expanded(child: Text(daysAbsent,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: AppTheme.themeColor),))

                      ],
                    ),
                    SizedBox(height: 5,),
                    Text("Days Absent",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 16),)
                  ],
                ),
              ),

            )),
          ],
        ),
        const SizedBox(height: 5,),
        Row(
          children: [
            Expanded(child: Card(
              elevation: 5,
              color: AppTheme.cardColor,
              margin: EdgeInsets.all(5),
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image(image: AssetImage("assets/at_leave.png"),width: 30,height: 30,),
                        SizedBox(width: 5,),
                        Expanded(child: Text(leaveTaken,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: AppTheme.themeColor),))

                      ],
                    ),
                    SizedBox(height: 5,),
                    Text("Leave Taken",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 16),)
                  ],
                ),
              ),

            )),
            SizedBox(width: 5,),
            Expanded(child: Card(
              elevation: 5,
              color: AppTheme.cardColor,
              margin: EdgeInsets.all(5),
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image(image: AssetImage("assets/at_holiday.png"),width: 30,height: 30,),
                        SizedBox(width: 5,),
                        Expanded(child: Text(publicHoliday,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: AppTheme.themeColor),))

                      ],
                    ),
                    SizedBox(height: 5,),
                    Text("Public Holiday",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 16),)
                  ],
                ),
              ),

            )),
          ],
        ),
        const SizedBox(height: 5,),
        Row(
          children: [
            Expanded(child: Card(
              elevation: 5,
              color: AppTheme.cardColor,
              margin: EdgeInsets.all(5),
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image(image: AssetImage("assets/at_loginhour.png"),width: 30,height: 30,),
                        SizedBox(width: 5,),
                        Expanded(child: Text(totalLoginHour,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: AppTheme.themeColor),))

                      ],
                    ),
                    SizedBox(height: 5,),
                    Text("Total Login Hour",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 16),)
                  ],
                ),
              ),

            )),
            SizedBox(width: 5,),
            Expanded(child: Card(
              elevation: 5,
              color: AppTheme.cardColor,
              margin: EdgeInsets.all(5),
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Row(
                      children: [
                        Image(image: AssetImage("assets/at_average_login.png"),width: 30,height: 30,),
                        SizedBox(width: 5,),
                        Expanded(child: Text(averageLogin,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: AppTheme.themeColor),))

                      ],
                    ),
                    SizedBox(height: 5,),
                    Text("Average Login",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 16),)
                  ],
                ),
              ),

            )),
          ],
        ),

        const SizedBox(height: 5,),
        clientCode=="MH100"?
        Row(
          children: [
            Expanded(child: Card(
              elevation: 5,
              color: AppTheme.cardColor,
              margin: EdgeInsets.all(5),
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image(image: AssetImage("assets/at_holiday.png"),width: 30,height: 30,),
                        SizedBox(width: 5,),
                        Expanded(child: Text(totalOTHours,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: AppTheme.themeColor),))

                      ],
                    ),
                    SizedBox(height: 5,),
                    Text("Total OT Hour",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 16),)
                  ],
                ),
              ),

            )),
            const SizedBox(width: 5,),
            const Expanded(child: Spacer()),
          ],
        ):SizedBox(height: 1,),


        const SizedBox(height: 10,),


        Row(
          children: [
            Expanded(child: TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AttendanceDetailsScreen()),);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.orangeColor,
                  ),
                  height: 45,
                  child: const Center(child: Text("View Attendance",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 13,color: Colors.white),),),
                )
            ),),
            SizedBox(width: 5,),
            Expanded(child: TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HolidayScreen()),);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.themeColor,
                  ),
                  height: 45,
                  child: const Center(child: Text("View Holiday",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 13,color: Colors.white),),),
                )
            ),),
          ],
        ),
        const SizedBox(height: 10,),


        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
          ),
          child: Column(

            children: [
              SizedBox(height: 20,),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [

                    Expanded(child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AppliedLeavesScreen()),);
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppTheme.at_details_divider,width: 1,style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/at_details_leave.svg',height: 30,width: 30,),
                            SizedBox(height: 5,),
                            Text("Applied Leaves",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    )),
                    SizedBox(width: 10,),
                    Expanded(child: InkWell(
                      onTap: (){
                        _navigateToAttendanceCorrection();
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppTheme.at_details_divider,width: 1,style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/at_details_correction.svg',height: 30,width: 30,),
                            SizedBox(height: 5,),
                            Text("Applied Corrections",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    )),

                  ],
                ),),
              SizedBox(height: 10,),

              clientCode=="MH100"?
                  SizedBox(height: 1,):
              Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [

                    Expanded(child: InkWell(
                      onTap: (){

                        Navigator.push(context, MaterialPageRoute(builder: (context) => AppliedToursScreen()),);
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppTheme.at_details_divider,width: 1,style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/at_details_tour.svg',height: 30,width: 30,),
                            SizedBox(height: 5,),
                            Text("Applied Tour",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    )),
                    SizedBox(width: 10,),
                    Expanded(child: InkWell(
                      onTap: (){

                        Navigator.push(context, MaterialPageRoute(builder: (context) => RequestedCOffScreen()),);
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppTheme.at_details_divider,width: 1,style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/at_details_coff.svg',height: 30,width: 30,),
                            SizedBox(height: 5,),
                            Text("Requested Week-Off",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    )),


                  ],
                ),),
              SizedBox(height: 10,),



            ],
          ),
        )
      ],
    ),);
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
    clientCode=await MyUtils.getSharedPreferences("client_code")??"";
    String? access=await MyUtils.getSharedPreferences("at_access")??'1';
    isAttendanceAccess=access;

    if(Platform.isAndroid){
      platform="Android";
    }else if(Platform.isIOS){
      platform="iOS";
    }else{
      platform="Other";
    }
    print("userId:-"+userIdStr.toString());
    print("token:-"+token.toString());
    print("employee_id:-"+empId.toString());
    print("Base Url:-"+baseUrl.toString());
    print("Platform:-"+platform);
    Navigator.of(context).pop();
    getAttendanceDetails();
  }
  getAttendanceDetails() async {

    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl=prefs.getString('base_url')??'';
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl, 'attendance_management/attendanceBasicDetails', token, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {

      daysPresent=responseJSON['data']['attendance_basic_details']['total_present_days'].toString();
      daysAbsent=responseJSON['data']['attendance_basic_details']['total_absent_days'].toString();
      publicHoliday=responseJSON['data']['attendance_basic_details']['total_holiday'].toString();
      leaveTaken=responseJSON['data']['attendance_basic_details']['total_taken_leave'].toString();
      totalLoginHour=responseJSON['data']['attendance_basic_details']['total_login_hours'].toString();
      averageLogin=responseJSON['data']['attendance_basic_details']['average_login_time'].toString();
      if(responseJSON['data']['attendance_basic_details']['total_overtime_hours']!=null){
        totalOTHours=responseJSON['data']['attendance_basic_details']['total_overtime_hours'].toString();
      }

      setState(() {
        isLoading=false;
      });
    }
    else if(responseJSON['code']==401 || responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        isLoading=false;
      });
      _logOut(context);
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
  _finishTheScreen(){
    Navigator.of(context).pop();
  }
  _logOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("user_id");
    await preferences.remove("email");
    await preferences.remove("designation");
    await preferences.remove("department");
    await preferences.remove("manager");
    await preferences.remove("location");
    await preferences.remove("first_name");
    await preferences.remove("last_name");
    await preferences.remove("role");
    await preferences.remove("full_name");
    await preferences.remove("token");
    await preferences.remove("emp_id");
    await preferences.remove("at_access");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
  }

  _navigateToAttendanceCorrection(){
    if(clientCode=='QD100'){
      Navigator.push(context, MaterialPageRoute(builder: (context) => QDAppliedCorrectionScreen()),);
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => AppliedCorrectionScreen()),);
    }
  }

}