import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ChecklistTree/views/gluple/attendance/ApplyShort_Leave_Screen.dart';
import 'package:ChecklistTree/views/gluple/network/api_dialog.dart';
import 'package:ChecklistTree/views/gluple/qd_attendance/QD_Attendance_Correction.dart';
import 'package:ChecklistTree/views/gluple/utils/attendance_details_series.dart';
import 'package:ChecklistTree/views/gluple/views/apply_attendance_correction_screen.dart';
import 'package:ChecklistTree/views/gluple/views/applyc_off_screen.dart';
import 'package:ChecklistTree/views/gluple/views/applyleave_screen_ub.dart';
import 'package:ChecklistTree/views/gluple/views/applytour_screen.dart';
import 'package:ChecklistTree/views/gluple/views/viewattlogs_screen.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

import '../../login_screen.dart';
import '../network/Utils.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import 'MarkAttendanceScreen.dart';
import 'login_screen.dart';
class AttendanceDetailsScreen extends StatefulWidget{

  _attendanceDetailsState createState()=>_attendanceDetailsState();
}
class _attendanceDetailsState extends State<AttendanceDetailsScreen>{
  String currentMonthName="";
  String currentTimeName="";
  String currentDateName="";
  String firstCheckinTime="";
  String lastCheckOutTime="";
  String lastUpdateTime="";

  bool isLoading=false;
  var userIdStr="";
  var fullNameStr="";
  var firstNameStr="";
  var designationStr="";
  var token="";
  var empId="";
  var baseUrl="";
  var clientCode="";
  var platform="";
  var isAttendanceAccess="1";
  bool showCheckIn=true;
  String logedInTime="00:00:00";

  List<AttendanceDetailsSeries> attendanceDate=[];


  String currentmonth="";
  String showingmonth="";
  String headerTitle="";
  String headerTime="";




  var titleColor=Colors.black;

  XFile? image;
  XFile? imageFile;
  File? file;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );
  Position? _currentPosition;
  String? _currentAddress;
  String lastImage="";

  List<dynamic> locationList=[];
  Timer? countdownTimer;
  Duration? myDuration;


  XFile? capturedImage;
  File? capturedFile;


  /********Correction for QD******************/

  List<String> correctionAllowDate=[];
  bool isCorrectLoading=false;

  /******Attendance Lock Functionality*********/

  String attendanceMonth="";
  String attendanceYear="";
  bool isAttendanceLock=false;


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
          "Attendance",
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
      body: isLoading ? const Center():
      SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 221,
                      color: AppTheme.at_details_header,
                      child: Padding(padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 20,),
                            Text(headerTitle,style: TextStyle(color: titleColor,fontSize: 14.5,fontWeight: FontWeight.w500),),
                            SizedBox(height: 5,),
                            Text(headerTime,style: TextStyle(color: Colors.black,fontSize: 20.5,fontWeight: FontWeight.w900),),
                            SizedBox(height: 5,),
                            isAttendanceAccess=='1'?
                            InkWell(
                              onTap: (){
                                _getCurrentPosition();
                              },
                              child: Container(
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppTheme.orangeColor) ,
                                height: 30,
                                child:   Center(
                                  child: Text(showCheckIn==true?"Check In":"Check Out",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 16
                                    ),),
                                ),
                              ),
                            ):SizedBox(height: 1,)
                          ],
                        ),),
                    ),
                    Container(
                      color: Colors.white,
                      height: 71,
                    )
                  ],
                ),
                Positioned(
                  child: Container(
                    height: 142,
                    width: MediaQuery.of(context).size.width/1.06,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: AppTheme.at_details_divider,width: 1)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text("Today's Attendance Details",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 14.5),),),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Check In",style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
                                Text(firstCheckinTime,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w900),)
                              ],
                            )),
                            const SizedBox(width: 2,),

                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Check Out",style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
                                Text(lastCheckOutTime,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w900),)
                              ],
                            )),
                            const SizedBox(width: 2,),

                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Working Hrs",style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
                                Text(logedInTime,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w900),)
                              ],
                            )),
                          ],
                        )
                      ],

                    ),
                  ),
                  bottom: 0,

                ),
                Positioned(child: SvgPicture.asset('assets/at_detail_head.svg',height: 162,width: 50,),right: 5,bottom: 130,)
              ],
            ),







            SizedBox(height: 10,),
            Card(color: Colors.white,
              elevation: 5,
              shadowColor: AppTheme.greyColor,
              child: Container(
                width: double.infinity,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){_getPreviousMonthAttendance();},
                      child:Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black,size: 24,),
                    ),
                    Expanded(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/at_calendar.svg',height: 21,width: 18,),
                        SizedBox(width: 5,),
                        Text(currentMonthName,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w900,color: Colors.black),),
                      ],
                    )),

                    currentmonth!=showingmonth?
                    InkWell(
                      onTap: (){_getNextMonthAttendance();},
                      child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.black,size: 24,),
                    )
                        :
                    SizedBox(width: 5,),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),

            Container(
              width: double.infinity,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(width: 1,color: AppTheme.at_details_divider),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 5,),
                  Container(
                    height: 70,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Align(
                            alignment: Alignment.center,
                            child: Text("Date",textAlign:TextAlign.center,style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
                          )),
                          const SizedBox(width: 1,),
                          Container(width: 1,color: AppTheme.at_details_divider,),
                          Expanded(child:  Text("Check In",textAlign:TextAlign.center,style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),),
                          const SizedBox(width: 1,),
                          Container(width: 1,color: AppTheme.at_details_divider,),
                          const SizedBox(width: 1,),
                          Expanded(child: Text("Check Out",textAlign:TextAlign.center,style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),),
                          const SizedBox(width: 1,),
                          Container(width: 1,color: AppTheme.at_details_divider,),
                          const SizedBox(width: 1,),
                          Expanded(child: Text("Working Hrs",textAlign:TextAlign.center,style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,)
                ],
              ),
            ),



            ListView.builder(
              shrinkWrap: true,
              physics:NeverScrollableScrollPhysics(),
              itemCount: attendanceDate.length,
              itemBuilder: (BuildContext cntx,int index){

                String firstHalfText="";
                var firstHalfColor=Colors.black;
                String firstHalfStatusText="";


                String secondHalfText="";
                var secondHalfColor=Colors.black;
                String secondHalfStatusText="";

                String workingHourText="";
                var workingHourColor=Colors.black;
                String workingHourStatusText="";

                if(attendanceDate[index].firstCheckIn=="00:00:00"||attendanceDate[index].firstCheckIn=="Invalid date"){

                  if(attendanceDate[index].firstHalfStatus=="first_half_present"||attendanceDate[index].firstHalfStatus=="FHP"){
                    firstHalfText="FHP";
                    firstHalfColor=AppTheme.FHPColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="second_half_present"||attendanceDate[index].firstHalfStatus=="SHP"){
                    firstHalfText="SHP";
                    firstHalfColor=AppTheme.FHPColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="Sunday_Off"|| attendanceDate[index].firstHalfStatus=="Second_Saturday_Off"|| attendanceDate[index].firstHalfStatus=="Forth_Saturday_Off"|| attendanceDate[index].firstHalfStatus=="Fourth_Saturday_Off"|| attendanceDate[index].firstHalfStatus=="WO"){
                    firstHalfText="WO";
                    firstHalfColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="present"|| attendanceDate[index].firstHalfStatus=="PR"){
                    firstHalfText="P";
                    firstHalfColor=AppTheme.PColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="AB"){
                    firstHalfText="A";
                    firstHalfColor=AppTheme.ABColor;
                  }

                  // New


                  else if(attendanceDate[index].firstHalfStatus=="CL"){
                    firstHalfText="CL";
                    firstHalfColor=AppTheme.PLColor;
                  }

                  else if(attendanceDate[index].firstHalfStatus=="EL"){
                    firstHalfText="EL";
                    firstHalfColor=AppTheme.PLColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="PH"){
                    firstHalfText="PH";
                    firstHalfColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="PH_"||attendanceDate[index].firstHalfStatus=="PH_P"){
                    firstHalfText="PH-P";
                    firstHalfColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="PH_FHP"){
                    firstHalfText="PH-FHP";
                    firstHalfColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="PH_SHP"){
                    firstHalfText="PH-SHP";
                    firstHalfColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="WO_P"){
                    firstHalfText="WO-P";
                    firstHalfColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="WO_FHP"){
                    firstHalfText="WO-FHP";
                    firstHalfColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="WO_SHP"){
                    firstHalfText="WO-SHP";
                    firstHalfColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="PL"){
                    firstHalfText="PL";
                    firstHalfColor=AppTheme.PLColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="LW"){
                    firstHalfText="LW";
                    firstHalfColor=AppTheme.LWColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="CO"){
                    firstHalfText="CO";
                    firstHalfColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="TOD"){
                    firstHalfText="TOD";
                    firstHalfColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="C_Off"){
                    firstHalfText="C-off";
                    firstHalfColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="SSL"){
                    firstHalfText="SSL";
                    firstHalfColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="FH_PL"){
                    firstHalfText="FH-PL";
                    firstHalfColor=AppTheme.PLColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="SH_PL"){
                    firstHalfText="SH-PL";
                    firstHalfColor=AppTheme.PLColor;
                  }



                }
                else{
                  firstHalfText=attendanceDate[index].firstCheckIn;

                  if(attendanceDate[index].firstHalfStatus=="first_half_present"||attendanceDate[index].firstHalfStatus=="FHP"){
                    firstHalfStatusText="FHP";
                    firstHalfColor=AppTheme.FHPColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="second_half_present"||attendanceDate[index].firstHalfStatus=="SHP"){
                    firstHalfStatusText="SHP";
                    firstHalfColor=AppTheme.FHPColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="Sunday_Off"|| attendanceDate[index].firstHalfStatus=="Second_Saturday_Off"|| attendanceDate[index].firstHalfStatus=="Forth_Saturday_Off"|| attendanceDate[index].firstHalfStatus=="Fourth_Saturday_Off"|| attendanceDate[index].firstHalfStatus=="WO"){
                    firstHalfStatusText="WO";
                    firstHalfColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="present"|| attendanceDate[index].firstHalfStatus=="PR"){
                    firstHalfStatusText="P";
                    firstHalfColor=AppTheme.PColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="AB"){
                    firstHalfStatusText="A";
                    firstHalfColor=AppTheme.ABColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="PH"){
                    firstHalfStatusText="PH";
                    firstHalfColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="PH_"||attendanceDate[index].firstHalfStatus=="PH_P"){
                    firstHalfStatusText="PH-P";
                    firstHalfColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="PH_FHP"){
                    firstHalfStatusText="PH-FHP";
                    firstHalfColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="PH_SHP"){
                    firstHalfStatusText="PH-SHP";
                    firstHalfColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="WO_P"){
                    firstHalfStatusText="WO-P";
                    firstHalfColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="WO_FHP"){
                    firstHalfStatusText="WO-FHP";
                    firstHalfColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="WO_SHP"){
                    firstHalfStatusText="WO-SHP";
                    firstHalfColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="PL"){
                    firstHalfStatusText="PL";
                    firstHalfColor=AppTheme.PLColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="LW"){
                    firstHalfStatusText="LW";
                    firstHalfColor=AppTheme.LWColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="CO"){
                    firstHalfStatusText="CO";
                    firstHalfColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="TOD"){
                    firstHalfStatusText="TOD";
                    firstHalfColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="C_Off"){
                    firstHalfStatusText="C-off";
                    firstHalfColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="SSL"){
                    firstHalfStatusText="SSL";
                    firstHalfColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="FH_PL"){
                    firstHalfStatusText="FH-PL";
                    firstHalfColor=AppTheme.PLColor;
                  }
                  else if(attendanceDate[index].firstHalfStatus=="SH_PL"){
                    firstHalfStatusText="SH-PL";
                    firstHalfColor=AppTheme.PLColor;
                  }

                }
                if(attendanceDate[index].lastCheckOut=="00:00:00"||attendanceDate[index].lastCheckOut=="Invalid date"){

                  if(attendanceDate[index].secondHalfStatus=="first_half_present"||attendanceDate[index].secondHalfStatus=="FHP"){
                    secondHalfText="FHP";
                    secondHalfColor=AppTheme.FHPColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="second_half_present"||attendanceDate[index].secondHalfStatus=="SHP"){
                    secondHalfText="SHP";
                    secondHalfColor=AppTheme.FHPColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="Sunday_Off"|| attendanceDate[index].secondHalfStatus=="Second_Saturday_Off"|| attendanceDate[index].secondHalfStatus=="Forth_Saturday_Off"|| attendanceDate[index].secondHalfStatus=="Fourth_Saturday_Off"|| attendanceDate[index].secondHalfStatus=="WO"){
                    secondHalfText="WO";
                    secondHalfColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="present"|| attendanceDate[index].secondHalfStatus=="PR"){
                    secondHalfText="P";
                    secondHalfColor=AppTheme.PColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="AB"){
                    secondHalfText="A";
                    secondHalfColor=AppTheme.ABColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="PH"){
                    secondHalfText="PH";
                    secondHalfColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="PH_"||attendanceDate[index].secondHalfStatus=="PH_P"){
                    secondHalfText="PH-P";
                    secondHalfColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="PH_FHP"){
                    secondHalfText="PH-FHP";
                    secondHalfColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="PH_SHP"){
                    secondHalfText="PH-SHP";
                    secondHalfColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="WO_P"){
                    secondHalfText="WO-P";
                    secondHalfColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="WO_FHP"){
                    secondHalfText="WO-FHP";
                    secondHalfColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="WO_SHP"){
                    secondHalfText="WO-SHP";
                    secondHalfColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="PL"){
                    secondHalfText="PL";
                    secondHalfColor=AppTheme.PLColor;
                  }

                  // New


                  else if(attendanceDate[index].secondHalfStatus=="CL"){
                    secondHalfText="CL";
                    secondHalfColor=AppTheme.PLColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="EL"){
                    secondHalfText="EL";
                    secondHalfColor=AppTheme.PLColor;
                  }

                  else if(attendanceDate[index].secondHalfStatus=="LW"){
                    secondHalfText="LW";
                    secondHalfColor=AppTheme.LWColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="CO"){
                    secondHalfText="CO";
                    secondHalfColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="TOD"){
                    secondHalfText="TOD";
                    secondHalfColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="C_Off"){
                    secondHalfText="C-off";
                    secondHalfColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="SSL"){
                    secondHalfText="SSL";
                    secondHalfColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="FH_PL"){
                    secondHalfText="FH-PL";
                    secondHalfColor=AppTheme.PLColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="SH_PL"){
                    secondHalfText="SH-PL";
                    secondHalfColor=AppTheme.PLColor;
                  }



                }
                else{
                  secondHalfText=attendanceDate[index].lastCheckOut;
                  if(attendanceDate[index].secondHalfStatus=="first_half_present"||attendanceDate[index].secondHalfStatus=="FHP"){
                    secondHalfStatusText="FHP";
                    secondHalfColor=AppTheme.FHPColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="second_half_present"||attendanceDate[index].secondHalfStatus=="SHP"){
                    secondHalfStatusText="SHP";
                    secondHalfColor=AppTheme.FHPColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="Sunday_Off"|| attendanceDate[index].secondHalfStatus=="Second_Saturday_Off"|| attendanceDate[index].secondHalfStatus=="Forth_Saturday_Off"|| attendanceDate[index].secondHalfStatus=="Fourth_Saturday_Off"|| attendanceDate[index].secondHalfStatus=="WO"){
                    secondHalfStatusText="WO";
                    secondHalfColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="present"|| attendanceDate[index].secondHalfStatus=="PR"){
                    secondHalfStatusText="P";
                    secondHalfColor=AppTheme.PColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="AB"){
                    secondHalfStatusText="A";
                    secondHalfColor=AppTheme.ABColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="PH"){
                    secondHalfStatusText="PH";
                    secondHalfColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="PH_"||attendanceDate[index].secondHalfStatus=="PH_P"){
                    secondHalfStatusText="PH-P";
                    secondHalfColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="PH_FHP"){
                    secondHalfStatusText="PH-FHP";
                    secondHalfColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="PH_SHP"){
                    secondHalfStatusText="PH-SHP";
                    secondHalfColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="WO_P"){
                    secondHalfStatusText="WO-P";
                    secondHalfColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="WO_FHP"){
                    secondHalfStatusText="WO-FHP";
                    secondHalfColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="WO_SHP"){
                    secondHalfStatusText="WO-SHP";
                    secondHalfColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="PL"){
                    secondHalfStatusText="PL";
                    secondHalfColor=AppTheme.PLColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="LW"){
                    secondHalfStatusText="LW";
                    secondHalfColor=AppTheme.LWColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="CO"){
                    secondHalfStatusText="CO";
                    secondHalfColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="TOD"){
                    secondHalfStatusText="TOD";
                    secondHalfColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="C_Off"){
                    secondHalfStatusText="C-off";
                    secondHalfColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="SSL"){
                    secondHalfStatusText="SSL";
                    secondHalfColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="FH_PL"){
                    secondHalfStatusText="FH-PL";
                    secondHalfColor=AppTheme.PLColor;
                  }
                  else if(attendanceDate[index].secondHalfStatus=="SH_PL"){
                    secondHalfStatusText="SH-PL";
                    secondHalfColor=AppTheme.PLColor;
                  }
                }
                if(attendanceDate[index].totalTime=="00:00:00"||attendanceDate[index].totalTime=="Invalid date"){
                  if(attendanceDate[index].attendanceStatus=="first_half_present"||attendanceDate[index].attendanceStatus=="FHP"){
                    workingHourText="FHP";
                    workingHourColor=AppTheme.FHPColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="second_half_present"||attendanceDate[index].attendanceStatus=="SHP"){
                    workingHourText="SHP";
                    workingHourColor=AppTheme.FHPColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="Sunday_Off"|| attendanceDate[index].attendanceStatus=="Second_Saturday_Off"|| attendanceDate[index].attendanceStatus=="Forth_Saturday_Off"|| attendanceDate[index].attendanceStatus=="Fourth_Saturday_Off"|| attendanceDate[index].attendanceStatus=="WO"){
                    workingHourText="WO";
                    workingHourColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="present"|| attendanceDate[index].attendanceStatus=="PR"){
                    workingHourText="P";
                    workingHourColor=AppTheme.PColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="AB"){
                    workingHourText="A";
                    workingHourColor=AppTheme.ABColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="PH"){
                    workingHourText="PH";
                    workingHourColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="PH_"||attendanceDate[index].attendanceStatus=="PH_P"){
                    workingHourText="PH-P";
                    workingHourColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="PH_FHP"){
                    workingHourText="PH-FHP";
                    workingHourColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="PH_SHP"){
                    workingHourText="PH-SHP";
                    workingHourColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="WO_P"){
                    workingHourText="WO-P";
                    workingHourColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="WO_FHP"){
                    workingHourText="WO-FHP";
                    workingHourColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="WO_SHP"){
                    workingHourText="WO-SHP";
                    workingHourColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="PL"){
                    workingHourText="PL";
                    workingHourColor=AppTheme.PLColor;
                  }



                  // new


                  else if(attendanceDate[index].attendanceStatus=="CL"){
                    workingHourText="CL";
                    workingHourColor=AppTheme.PLColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="EL"){
                    workingHourText="EL";
                    workingHourColor=AppTheme.PLColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="LW"){
                    workingHourText="LW";
                    workingHourColor=AppTheme.LWColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="CO"){
                    workingHourText="CO";
                    workingHourColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="TOD"){
                    workingHourText="TOD";
                    workingHourColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="C_Off"){
                    workingHourText="C-off";
                    workingHourColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="SSL"){
                    workingHourText="SSL";
                    workingHourColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="FH_PL"){
                    workingHourText="FH-PL";
                    workingHourColor=AppTheme.PLColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="SH_PL"){
                    workingHourText="SH-PL";
                    workingHourColor=AppTheme.PLColor;
                  }
                }
                else{
                  workingHourText=attendanceDate[index].totalTime;

                  if(attendanceDate[index].attendanceStatus=="first_half_present"||attendanceDate[index].attendanceStatus=="FHP"){
                    workingHourStatusText="FHP";
                    workingHourColor=AppTheme.FHPColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="second_half_present"||attendanceDate[index].attendanceStatus=="SHP"){
                    workingHourStatusText="SHP";
                    workingHourColor=AppTheme.FHPColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="Sunday_Off"|| attendanceDate[index].attendanceStatus=="Second_Saturday_Off"|| attendanceDate[index].attendanceStatus=="Forth_Saturday_Off"|| attendanceDate[index].attendanceStatus=="Fourth_Saturday_Off"|| attendanceDate[index].attendanceStatus=="WO"){
                    workingHourStatusText="WO";
                    workingHourColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="present"|| attendanceDate[index].attendanceStatus=="PR"){
                    workingHourStatusText="P";
                    workingHourColor=AppTheme.PColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="AB"){
                    workingHourStatusText="A";
                    workingHourColor=AppTheme.ABColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="PH"){
                    workingHourStatusText="PH";
                    workingHourColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="PH_"||attendanceDate[index].attendanceStatus=="PH_P"){
                    workingHourStatusText="PH-P";
                    workingHourColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="PH_FHP"){
                    workingHourStatusText="PH-FHP";
                    workingHourColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="PH_SHP"){
                    workingHourStatusText="PH-SHP";
                    workingHourColor=AppTheme.PHColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="WO_P"){
                    workingHourStatusText="WO-P";
                    workingHourColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="WO_FHP"){
                    workingHourStatusText="WO-FHP";
                    workingHourColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="WO_SHP"){
                    workingHourStatusText="WO-SHP";
                    workingHourColor=AppTheme.WOColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="PL"){
                    workingHourStatusText="PL";
                    workingHourColor=AppTheme.PLColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="LW"){
                    workingHourStatusText="LW";
                    workingHourColor=AppTheme.LWColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="CO"){
                    workingHourStatusText="CO";
                    workingHourColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="TOD"){
                    workingHourStatusText="TOD";
                    workingHourColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="C_Off"){
                    workingHourStatusText="C-off";
                    workingHourColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="SSL"){
                    workingHourStatusText="SSL";
                    workingHourColor=AppTheme.COColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="FH_PL"){
                    workingHourStatusText="FH-PL";
                    workingHourColor=AppTheme.PLColor;
                  }
                  else if(attendanceDate[index].attendanceStatus=="SH_PL"){
                    workingHourStatusText="SH-PL";
                    workingHourColor=AppTheme.PLColor;
                  }
                }


                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(width: 1,color: AppTheme.at_details_divider),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      InkWell(onTap: (){
                        isAttendanceLock?_showAttendanceBottomDialogForLock(attendanceDate[index].dateStr,attendanceDate[index].firstCheckIn,attendanceDate[index].lastCheckOut,attendanceDate[index].totalTime,workingHourText):
                        _showAttendanceBottomDialog(attendanceDate[index].dateStr,attendanceDate[index].firstCheckIn,attendanceDate[index].lastCheckOut,attendanceDate[index].totalTime,workingHourText);
                        // _showEditAttendanceDialog(attendanceDate[index].dateStr,attendanceDate[index].firstCheckIn,attendanceDate[index].lastCheckOut);
                      },
                        child: Container(
                          height: 70,
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: AppTheme.at_details_date_back,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('${attendanceDate[index].dayStr} ${attendanceDate[index].monthStr}',style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white
                                          ),),

                                          Text(attendanceDate[index].attendanceDay,style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white
                                          ),),
                                        ],
                                      )
                                  ),
                                )),


                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //Text("Check In",style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
                                    Text(firstHalfText,style: TextStyle(color: firstHalfColor,fontSize: 14.5,fontWeight: FontWeight.w900),),
                                    firstHalfStatusText.isEmpty?SizedBox(height: 1,):
                                    Text(firstHalfStatusText,style: TextStyle(color: firstHalfColor,fontSize: 14.5,fontWeight: FontWeight.w900),)

                                  ],
                                )),
                                const SizedBox(width: 1,),
                                Container(width: 1,color: AppTheme.at_details_divider,),
                                const SizedBox(width: 1,),
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Text("Check Out",style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
                                    Text(secondHalfText,style: TextStyle(color: secondHalfColor,fontSize: 14.5,fontWeight: FontWeight.w900),),
                                    secondHalfStatusText.isEmpty?SizedBox(height: 1,):
                                    Text(secondHalfStatusText,style: TextStyle(color: secondHalfColor,fontSize: 14.5,fontWeight: FontWeight.w900),)
                                  ],
                                )),
                                const SizedBox(width: 1,),
                                Container(width: 1,color: AppTheme.at_details_divider,),
                                const SizedBox(width: 1,),
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //Text("Working Hrs",style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
                                    Text(workingHourText,style: TextStyle(color: workingHourColor,fontSize: 14.5,fontWeight: FontWeight.w900),),
                                    workingHourStatusText.isEmpty?SizedBox(height: 1,):
                                    Text(workingHourStatusText,style: TextStyle(color: workingHourColor,fontSize: 14.5,fontWeight: FontWeight.w900),)
                                  ],
                                )),





                              ],
                            ),
                          ),
                        ),),
                      const SizedBox(height: 10,)
                    ],
                  ),
                );


              },
            )

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
  _buildListItems() async{
    APIDialog.showAlertDialog(context, "Please Wait...");
    setState(() {
      isLoading=true;
    });
    currentMonthName=DateFormat("MMMM").format(DateTime.now());
    currentTimeName=DateFormat("hh:mm a").format(DateTime.now());
    currentDateName=DateFormat.yMMMMEEEEd().format(DateTime.now());
    currentmonth=DateFormat.yMMM().format(DateTime.now());


    userIdStr=await MyUtils.getSharedPreferences("user_id")??"";
    fullNameStr=await MyUtils.getSharedPreferences("full_name")??"";
    firstNameStr=await MyUtils.getSharedPreferences("first_name")??"";
    token=await MyUtils.getSharedPreferences("token")??"";
    designationStr=await MyUtils.getSharedPreferences("designation")??"";
    empId=await MyUtils.getSharedPreferences("emp_id")??"";
    baseUrl=await MyUtils.getSharedPreferences("base_url")??"";
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

    Navigator.pop(context);
    setState(() {
      isLoading=false;
    });

    getAttendanceDetails();
    getLocationList();

    if(clientCode=='QD100'){
      getCorrectionNotification();
    }

  }
  getAttendanceDetails() async {

    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl, 'attendance_management/attendanceBasicDetails', token, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {

      String sAttendanceTypeServer = responseJSON['data']['attendance_basic_details']['attendance_type'].toString();
      if(sAttendanceTypeServer=="attendance"){
        String last_check_status=responseJSON['data']['attendance_basic_details']['last_check_status'].toString();

        if(last_check_status=="null"){
          logedInTime="00:00:00";
          showCheckIn=true;
          titleColor=AppTheme.at_details_divider;
          headerTime = "Let's get to Work";
          if(checkRestaurentStatus("00:01", "12:00")){
            headerTitle="Good Morning $firstNameStr";
          }
          else if(checkRestaurentStatus("12:01", "16:00")){
            headerTitle="Good Afternoon $firstNameStr";
          }
          else if(checkRestaurentStatus("16:01", "20:00")){
            headerTitle="Good Evening $firstNameStr";
          }
          else{
            headerTitle="Hi, $firstNameStr";
          }
          lastCheckOutTime="--:--";
        }
        else if(last_check_status=="in"){
          showCheckIn=false;
          logedInTime=responseJSON['data']['attendance_basic_details']['total_time'].toString();

          if(logedInTime=="null"){
            logedInTime="00:00:00";
          }

          headerTime = "$logedInTime Hrs";
          headerTitle="Your are Checked In";

          titleColor=Colors.black;
          startTimer(logedInTime);

        }
        else if(last_check_status=="out"){
          showCheckIn=true;
          logedInTime=responseJSON['data']['attendance_basic_details']['total_time'].toString();
          if(logedInTime=="null"){
            logedInTime="00:00:00";
          }
          headerTime = "$logedInTime Hrs";
          headerTitle="Your are Checked Out";
          titleColor=Colors.black;
          stopTimer();
        }



        String firstCheckStatus=responseJSON['data']['attendance_basic_details']['first_check_status'].toString();
        String lastCheckStatus=responseJSON['data']['attendance_basic_details']['last_check_status'].toString();
        String lastCheckTime=responseJSON['data']['attendance_basic_details']['last_check_time'].toString();
        if(firstCheckStatus=='in'){
          firstCheckinTime=responseJSON['data']['attendance_basic_details']['first_check_time'].toString();
          if(firstCheckinTime!="null"){
            DateTime parseDate =
            new DateFormat("yyyy-MM-dd hh:mm:ss").parse(firstCheckinTime);
            var inputDate = DateTime.parse(parseDate.toString());
            var outputFormat = DateFormat('hh:mm a');
            var outputDate = outputFormat.format(inputDate);
            firstCheckinTime=outputDate.toString();
          }else{
            firstCheckinTime="--:--";
          }
        }else{
          firstCheckinTime="--:--";
        }

        if(lastCheckStatus=='out'){
          lastCheckOutTime=responseJSON['data']['attendance_basic_details']['last_check_time'].toString();
          if(lastCheckOutTime!="null"){
            DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(lastCheckOutTime);
            var inputDate = DateTime.parse(parseDate.toString());
            var outputFormat = DateFormat('hh:mm a');
            var outputDate = outputFormat.format(inputDate);
            lastCheckOutTime=outputDate.toString();
          }else{
            lastCheckOutTime="--:--";
          }



        }else{
          lastCheckOutTime="--:--";
        }


        if(lastCheckTime!="null"){
          DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(lastCheckTime);
          var inputDate = DateTime.parse(parseDate.toString());
          var outputFormat = DateFormat('hh:mm a');
          var outputDate = outputFormat.format(inputDate);
          lastUpdateTime=outputDate.toString();
        }

      }
      else{

        headerTime = "Let's get to Work";
        if(checkRestaurentStatus("00:01", "12:00")){
          headerTitle="Good Morning $firstNameStr";
        }else if(checkRestaurentStatus("12:01", "16:00")){
          headerTitle="Good Afternoon $firstNameStr";
        }else if(checkRestaurentStatus("16:01", "20:00")){
          headerTitle="Good Evening $firstNameStr";
        }else{
          headerTitle="Hi, $firstNameStr";
        }
        titleColor=AppTheme.at_details_divider;
        showCheckIn=true;
      }

      setState(() {
        isLoading=false;
      });

      _getCurrentMonthAttendance();

    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

      setState(() {
        isLoading=false;
      });

    }
  }
  _getCurrentMonthAttendance(){
    final now = DateTime.now();
    var date = DateTime(now.year, now.month, 1).toString();
    var dateParse = DateTime.parse(date);
    var firstDayOfMonth=DateFormat("yyyy-MM-dd").format(dateParse);
    var currentDayOfMonth=DateFormat("yyyy-MM-dd").format(now);
    showingmonth=DateFormat.yMMM().format(now);
    if(dateParse.month>9){
      attendanceMonth=dateParse.month.toString();
    }else{
      attendanceMonth="0${dateParse.month}";
    }
    attendanceYear=dateParse.year.toString();
    print("Showing Month: "+showingmonth);
    print("Current Month: "+currentmonth);
    print("Attendance Month: "+attendanceMonth);
    print("Attendance Year: "+attendanceYear);
    _getAttendanceDetails(firstDayOfMonth, currentDayOfMonth);
    getAttendanceStatus();

  }
  _getPreviousMonthAttendance(){
    final showing=DateFormat.yMMM().parse(showingmonth);
    var date = DateTime(showing.year,showing.month-1,1).toString();
    var dateParse = DateTime.parse(date);
    var firstDayOfMonth=DateFormat("yyyy-MM-dd").format(dateParse);
    var lastDayCurrentMonth = DateTime(showing.year,showing.month,1).subtract(Duration(days: 1));
    var currentDayOfMonth=DateFormat("yyyy-MM-dd").format(lastDayCurrentMonth);
    showingmonth=DateFormat.yMMM().format(lastDayCurrentMonth);
    currentMonthName=DateFormat("MMMM").format(dateParse);
    print("Showing Month: "+showingmonth);
    print("Current Month: "+currentmonth);
    print("Current Month for show: "+currentMonthName);
    if(dateParse.month>9){
      attendanceMonth=dateParse.month.toString();
    }else{
      attendanceMonth="0${dateParse.month}";
    }
    attendanceYear=dateParse.year.toString();
    print("Attendance Month: "+attendanceMonth);
    print("Attendance Year: "+attendanceYear);
    _getAttendanceDetails(firstDayOfMonth, currentDayOfMonth);
    getAttendanceStatus();
  }
  _getNextMonthAttendance(){
    final showing=DateFormat.yMMM().parse(showingmonth);
    var date = DateTime(showing.year,showing.month+1,1).toString();
    var dateParse = DateTime.parse(date);
    var firstDayOfMonth=DateFormat("yyyy-MM-dd").format(dateParse);
    var lastDayCurrentMonth = DateTime(showing.year,showing.month+2,1).subtract(Duration(days: 1));
    var currentDayOfMonth=DateFormat("yyyy-MM-dd").format(lastDayCurrentMonth);

    showingmonth=DateFormat.yMMM().format(lastDayCurrentMonth);
    currentMonthName=DateFormat("MMMM").format(dateParse);
    print("Showing Month: "+showingmonth);
    print("Current Month: "+currentmonth);
    print("Current Month for show: "+currentMonthName);
    if(dateParse.month>9){
      attendanceMonth=dateParse.month.toString();
    }else{
      attendanceMonth="0${dateParse.month}";
    }
    attendanceYear=dateParse.year.toString();
    print("Attendance Month: "+attendanceMonth);
    print("Attendance Year: "+attendanceYear);
    _getAttendanceDetails(firstDayOfMonth, currentDayOfMonth);
    getAttendanceStatus();
  }
  _getAttendanceDetails(String startDate,String endDate)async{
    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    var requestModel = {
      "emp_id": empId,
      "start_date":startDate,
      "last_date":endDate,
    };
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(baseUrl, 'attendance_management/get-attendance-by-id', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {

      List<dynamic> tempUserList=[];
      tempUserList=responseJSON['data'];
      attendanceDate.clear();
      if(tempUserList.length>0){
        for(int i=tempUserList.length-1;i>=0;i--){
          String dateStr=tempUserList[i]['date'];
          String first_half_status=tempUserList[i]['first_half_status'];
          String second_half_status=tempUserList[i]['second_half_status'];
          String first_check_in=tempUserList[i]['first_check_in'];
          String last_check_out=tempUserList[i]['last_check_out'];
          String total_time=tempUserList[i]['total_time'];
          String attendance_status=tempUserList[i]['attendance_status'];
          String attendance_day="";
          if(tempUserList[i]['attendance_day']!=null){
            String atDay=tempUserList[i]['attendance_day'];
            if(atDay.length>3){
              attendance_day='${atDay[0]}${atDay[1]}${atDay[2]}';
            }else{
              attendance_day=atDay;
            }


          }
          var atDate=DateTime.parse(dateStr);
          var nDay=DateFormat("dd").format(atDate);
          var nMnth=DateFormat("MMM").format(atDate);
          double attendanceHour=8;
          if(attendance_status=="HD"){
            attendanceHour=4;
          }
          attendanceDate.add(AttendanceDetailsSeries(
              dateStr,
              first_half_status,
              second_half_status,
              first_check_in,
              last_check_out,
              total_time,
              attendance_status,
              attendance_day,
              nDay,
              nMnth));
        }
      }

      /*for(int i=0;i<tempUserList.length;i++){
        String dateStr=tempUserList[i]['date'];
        String first_half_status=tempUserList[i]['first_half_status'];
        String second_half_status=tempUserList[i]['second_half_status'];
        String first_check_in=tempUserList[i]['first_check_in'];
        String last_check_out=tempUserList[i]['last_check_out'];
        String total_time=tempUserList[i]['total_time'];
        String attendance_status=tempUserList[i]['attendance_status'];
        String attendance_day=tempUserList[i]['attendance_day'];
        var atDate=DateTime.parse(dateStr);
        var nDay=DateFormat("dd").format(atDate);
        var nMnth=DateFormat("MMM").format(atDate);
        double attendanceHour=8;
        if(attendance_status=="HD"){
          attendanceHour=4;
        }
        attendanceDate.add(AttendanceDetailsSeries(
            dateStr,
            first_half_status,
            second_half_status,
            first_check_in,
            last_check_out,
            total_time,
            attendance_status,
            attendance_day,
            nDay,
            nMnth));
      }*/
    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {
      isLoading=false;
    });

  }

  _showEditAttendanceDialog(String dateStr,String firstHalfTime,String secondHalfTime){
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


                    Row(
                      children: [
                        Expanded(child: Text(
                          "Edit Attendance",
                          style: TextStyle(color: AppTheme.themeColor,fontWeight: FontWeight.w900,fontSize: 18),),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.close_rounded,color: Colors.red,size: 20,),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),

                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                        Toast.show("Apply Leave will be available Shortly",
                            duration: Toast.lengthLong,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.red);
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyLeave_Screen()),);
                      },
                      child: Text("Apply Leave",style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                      ),),
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop();

                        Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyCOffScreen()),);
                      },
                      child: Text("Apply C-OFF",style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                      ),),
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyTourScreen()),);
                      },
                      child: Text("Apply Tour",style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                      ),),
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyAttendanceCorrectionScreen(alDate: dateStr,alCheckIn: firstHalfTime,alcheckOut: secondHalfTime,)),);
                      },
                      child: Text("Attendance Correction",style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                      ),),
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showAttendanceBottomDialog(String dateStr,String firstHalfTime,String secondHalfTime,String workingHour,String attStatus){
    print(dateStr);
    print("Attendance Status :$attStatus");
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (BuildContext contx){
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
            ),
            child: Wrap(
              children: [
                Column(

                  children: [
                    SizedBox(height: 20,),
                    Align(alignment: Alignment.center, child: Container(height: 5,width: 30,color: AppTheme.greyColor,),),
                    SizedBox(height: 10,),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(child: Text("Leave Managment",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black,fontSize: 18.5),)),
                          SizedBox(width: 5,),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.close_rounded,color: AppTheme.greyColor,size: 32,),
                          ),
                          SizedBox(width: 5,),

                        ],
                      ),),
                    SizedBox(height: 10,),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(child: InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAttendanceLogs(dateStr,firstHalfTime,secondHalfTime,workingHour)),);
                            },
                            child: Container(
                              height: 125,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: AppTheme.at_details_divider,width: 1,style: BorderStyle.solid),
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/at_details.svg',height: 70,width: 70,),
                                  SizedBox(height: 5,),
                                  const Text("View Attendance Events",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black,fontSize: 16.5,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          )),
                          SizedBox(width: 10,),
                          _checkCorrectionValidation(dateStr)?
                          Expanded(child: InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                              _navigateToAttendanceCorrectionScreen(dateStr, firstHalfTime, secondHalfTime, workingHour,attStatus);
                            },
                            child: Container(
                              height: 125,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: AppTheme.at_details_divider,width: 1,style: BorderStyle.solid),
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/at_details_correction.svg',height: 50,width: 50,),
                                  SizedBox(height: 5,),
                                  Text("Attendance Correction",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black,fontSize: 16.5,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          )):const SizedBox(width: 0,),
                        ],
                      ),),
                    SizedBox(height: 10,),



                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [

                          Expanded(child: InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyLeave_Screen_UB()),);
                              /*clientCode=="UB100"?
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyLeave_Screen_UB()),):
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyLeave_Screen()),);*/
                            },
                            child: Container(
                              height: 125,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: AppTheme.at_details_divider,width: 1,style: BorderStyle.solid),
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/at_details_leave.svg',height: 50,width: 50,),
                                  SizedBox(height: 5,),
                                  Text("Apply Leaves",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black,fontSize: 16.5,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          )),
                          SizedBox(width: 10,),
                          Expanded(child: InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyCOffScreen()),);
                            },
                            child: Container(
                              height: 125,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: AppTheme.at_details_divider,width: 1,style: BorderStyle.solid),
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/at_details_coff.svg',height: 50,width: 50,),
                                  SizedBox(height: 5,),
                                  Text("Apply Week-Off",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black,fontSize: 16.5,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          )),

                        ],
                      ),),
                    SizedBox(height: 10,),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [

                          Expanded(child: InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyTourScreen()),);
                            },
                            child: Container(
                              height: 125,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: AppTheme.at_details_divider,width: 1,style: BorderStyle.solid),
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/at_details_tour.svg',height: 50,width: 50,),
                                  SizedBox(height: 5,),
                                  Text("Apply Tour",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black,fontSize: 16.5,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          )),
                          SizedBox(width: 10,),



                        ],
                      ),),
                    SizedBox(height: 10,),

                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.orangeColor,
                          ),
                          height: 40,
                          padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                          child: const Center(child: Text("Done",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                        )
                    ),


                  ],
                )
              ],
            ),
          );
        });
  }
  _showAttendanceBottomDialogForLock(String dateStr,String firstHalfTime,String secondHalfTime,String workingHour,String attStatus){
    print(dateStr);
    print("Attendance Status :$attStatus");
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (BuildContext contx){
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
            ),
            child: Wrap(
              children: [
                Column(

                  children: [
                    SizedBox(height: 20,),
                    Align(alignment: Alignment.center, child: Container(height: 5,width: 30,color: AppTheme.greyColor,),),
                    SizedBox(height: 10,),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(child: Text("Leave Managment",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black,fontSize: 18.5),)),
                          SizedBox(width: 5,),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.close_rounded,color: AppTheme.greyColor,size: 32,),
                          ),
                          SizedBox(width: 5,),

                        ],
                      ),),
                    SizedBox(height: 10,),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(child: InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAttendanceLogs(dateStr,firstHalfTime,secondHalfTime,workingHour)),);
                            },
                            child: Container(
                              height: 125,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: AppTheme.at_details_divider,width: 1,style: BorderStyle.solid),
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/at_details.svg',height: 70,width: 70,),
                                  SizedBox(height: 5,),
                                  const Text("View Attendance Events",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black,fontSize: 16.5,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),),
                    SizedBox(height: 10,),

                    Text("Attendance is Locked for $currentMonthName-$attendanceYear !!!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: AppTheme.task_Reopen_text,fontStyle: FontStyle.italic),
                    ),
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.orangeColor,
                          ),
                          height: 40,
                          padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                          child: const Center(child: Text("Done",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                        )
                    ),


                  ],
                )
              ],
            ),
          );
        });
  }

  bool checkRestaurentStatus(String openTime, String closedTime) {
    //NOTE: Time should be as given format only
    //10:00PM
    //10:00AM

    // 01:60PM ->13:60
    //Hrs:Min
    //if AM then its ok but if PM then? 12+time (12+10=22)

    TimeOfDay timeNow = TimeOfDay.now();
    String openHr = openTime.substring(0, 2);
    String openMin = openTime.substring(3, 5);
    String openAmPm = openTime.substring(5);
    TimeOfDay timeOpen;
    if (openAmPm == "AM") {
      //am case
      if (openHr == "12") {
        //if 12AM then time is 00
        timeOpen = TimeOfDay(hour: 00, minute: int.parse(openMin));
      } else {
        timeOpen =
            TimeOfDay(hour: int.parse(openHr), minute: int.parse(openMin));
      }
    } else {
      //pm case
      if (openHr == "12") {
//if 12PM means as it is
        timeOpen =
            TimeOfDay(hour: int.parse(openHr), minute: int.parse(openMin));
      } else {
//add +12 to conv time to 24hr format
        timeOpen =
            TimeOfDay(hour: int.parse(openHr) + 12, minute: int.parse(openMin));
      }
    }

    String closeHr = closedTime.substring(0, 2);
    String closeMin = closedTime.substring(3, 5);
    String closeAmPm = closedTime.substring(5);

    TimeOfDay timeClose;

    if (closeAmPm == "AM") {
      //am case
      if (closeHr == "12") {
        timeClose = TimeOfDay(hour: 0, minute: int.parse(closeMin));
      } else {
        timeClose =
            TimeOfDay(hour: int.parse(closeHr), minute: int.parse(closeMin));
      }
    } else {
      //pm case
      if (closeHr == "12") {
        timeClose =
            TimeOfDay(hour: int.parse(closeHr), minute: int.parse(closeMin));
      } else {
        timeClose = TimeOfDay(
            hour: int.parse(closeHr) + 12, minute: int.parse(closeMin));
      }
    }

    int nowInMinutes = timeNow.hour * 60 + timeNow.minute;
    int openTimeInMinutes = timeOpen.hour * 60 + timeOpen.minute;
    int closeTimeInMinutes = timeClose.hour * 60 + timeClose.minute;

//handling day change ie pm to am
    if ((closeTimeInMinutes - openTimeInMinutes) < 0) {
      closeTimeInMinutes = closeTimeInMinutes + 1440;
      if (nowInMinutes >= 0 && nowInMinutes < openTimeInMinutes) {
        nowInMinutes = nowInMinutes + 1440;
      }
      if (openTimeInMinutes < nowInMinutes &&
          nowInMinutes < closeTimeInMinutes) {
        return true;
      }
    } else if (openTimeInMinutes < nowInMinutes &&
        nowInMinutes < closeTimeInMinutes) {
      return true;
    }

    return false;

  }



  /// *******************Mark Attendance******************************

  Future<void> _getCurrentPosition() async {

    APIDialog.showAlertDialog(context, "Fetching Location..");
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      Navigator.of(context).pop();
      _showPermissionCustomDialog();
      return;
    }
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      print("Location  latitude : ${_currentPosition!.latitude} Longitude : ${_currentPosition!.longitude}");
      Navigator.pop(context);
      _getAddressFromLatLng(position);

    }).catchError((e) {
      debugPrint(e);
      Toast.show("Error!!! Can't get Location. Please Ensure your location services are enabled",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      Navigator.pop(context);
    });


  }
  Future<void> _getAddressFromLatLng(Position position) async {
    APIDialog.showAlertDialog(context, "Fetching Address....");
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.name}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.country}, ${place.postalCode}';
      });
      print("Current Address : "+_currentAddress!);
      bool isLocationMatched=false;
      double distancePoints=0.0;

      if(locationList.isNotEmpty) {
        for (int i = 0; i < locationList.length; i++) {
          double lat1 = double.parse(locationList[i]['lat'].toString());
          double long1 = double.parse(locationList[i]['lng'].toString());
          distancePoints = Geolocator.distanceBetween(
              lat1, long1, position.latitude, position.longitude);
          print("distance calculated:::$distancePoints Meter");
          if (distancePoints < 101) {
            isLocationMatched = true;
            break;
          }
        }
      }else{
        isLocationMatched = true;
      }

      Navigator.pop(context);
      if(isLocationMatched){
        // imageSelector(context);
        prepairCamera();
      }else{
        /* Toast.show("Sorry!!! Please check your location. You are not  Allowed to Check-In on this Location",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);*/
        String distanceStr="";
        if(distancePoints<1000){
          distanceStr="${distancePoints.toStringAsFixed(2)} Meters";
        }else{
          double ddsss=distancePoints/1000;
          distanceStr="${ddsss.toStringAsFixed(2)} Kms";
        }
        _showLocationErrorCustomDialog(distanceStr);
      }





    }).catchError((e) {
      debugPrint(e.toString());
      // imageSelector(context);
      prepairCamera();
    });
  }
  Future<void> prepairCamera() async{
    // imageSelector(context);


    if(Platform.isAndroid){
      final imageData=await Navigator.push(context,MaterialPageRoute(builder: (context)=>MarkAttendanceScreen()));
      if(imageData!=null)
      {
        capturedImage=imageData;
        capturedFile=File(capturedImage!.path);
        _faceFromCamera();
      }else{
        Toast.show("Unable to capture Image. Please try Again...",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    }else{
      imageSelector(context);
    }


  }
  Future<bool> _handleCameraPermission() async{
    bool serviceEnabled;
    PermissionStatus status=await Permission.camera.status;
    if(status.isGranted){
      serviceEnabled = true;
    }else if(status.isPermanentlyDenied){
      serviceEnabled=false;
    }else{
      var camStatus=await Permission.camera.request();
      if(camStatus.isGranted){
        serviceEnabled = true;
      }else{
        serviceEnabled = false;
      }
    }
    return serviceEnabled;
  }
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      Toast.show("Location services are disabled. Please enable the services.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      /*ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));*/
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Toast.show("Location permissions are denied.",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
        /*ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));*/
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Toast.show("Location permissions are permanently denied, we cannot request permissions.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      /*ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));*/
      return false;
    }




    return true;
  }
  imageSelector(BuildContext context) async{

    imageFile = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 60,preferredCameraDevice: CameraDevice.front);

    if(imageFile!=null){
      file=File(imageFile!.path);

      final imageFiles = imageFile;
      if (imageFiles != null) {
        print("You selected  image : " + imageFiles.path.toString());
        setState(() {
          debugPrint("SELECTED IMAGE PICK   $imageFiles");
        });
        _faceDetection();
      } else {
        print("You have not taken image");
      }
    }else{
      Toast.show("Unable to capture Image. Please try Again...",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }


  }
  _faceDetection() async{
    APIDialog.showAlertDialog(context, "Detecting Face....");

    final image=InputImage.fromFile(file!);
    final faces=await _faceDetector.processImage(image);
    print("faces in image ${faces.length}");
    Navigator.pop(context);
    if(faces.isNotEmpty){
      _showImageDialog();
    }else{
      Toast.show("Face not detected in captured image. Please capture a selfie.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _showFaceErrorCustomDialog();
    }

  }
  _showImageDialog(){

    showDialog(context: context, builder: (ctx)=>AlertDialog(
        title: const Text("Mark Attendance",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 18),),
        content: Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.rectangle,
            image: DecorationImage(
                image: FileImage(file!),
                fit: BoxFit.cover
            ),

          ),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: (){
                Navigator.of(ctx).pop();
                markAttendance();
                //call attendance punch in or out
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme.themeColor,
                ),
                height: 45,
                padding: const EdgeInsets.all(10),
                child: const Center(child: Text("Mark",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
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
                child: const Center(child: Text("Cancel",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
              )
          )
        ]
    ));
  }
  getLocationList() async{
    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, "Please wait...");
    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithBase(baseUrl,"rest_api/get-project-location-by-empid?empId="+userIdStr, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {

      locationList=responseJSON['data'];
      for(int i=0;i<locationList.length;i++){

        print("lofgubh : "+locationList[i]['lat']);
        print("lnghsg : "+locationList[i]['lng']);
      }


      setState(() {
        isLoading=false;
      });

    }else if(responseJSON['code']==401|| responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        isLoading=false;
      });
      _logOut(context);
    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

      setState(() {
        isLoading=false;
      });

    }

  }
  _showCustomDialog(){
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
                          getAttendanceDetails();
                        },
                        child: Icon(Icons.close_rounded,color: Colors.red,size: 20,),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 100,
                      width: double.infinity,
                      child: Lottie.asset("assets/att_anim.json"),
                    ),
                    SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.center,
                      child: Text("Time Marked!!!",style: TextStyle(color: AppTheme.orangeColor,fontWeight: FontWeight.w900,fontSize: 18),),
                    ),
                    SizedBox(height: 20,),
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          getAttendanceDetails();
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
  startTimer(String time){

    List<String> splitString=time.split(':');
    int hour=int.parse(splitString[0]);
    int mnts=int.parse(splitString[1]);
    int sec=int.parse(splitString[2]);

    myDuration=Duration(hours: hour,minutes: mnts,seconds: sec);
    if(countdownTimer!=null){
      countdownTimer!.cancel();
    }
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }
  setCountDown(){
    const increasedSecBy = 1;
    setState(() {
      final second=myDuration!.inSeconds+increasedSecBy;
      myDuration=Duration(seconds: second);
      String strDigits(int n) => n.toString().padLeft(2, '0');
      final hours = strDigits(myDuration!.inHours.remainder(24));
      final minutes = strDigits(myDuration!.inMinutes.remainder(60));
      final seconds = strDigits(myDuration!.inSeconds.remainder(60));
      logedInTime="$hours:$minutes:$seconds";
      headerTime = "$logedInTime Hrs";
    });
  }
  stopTimer(){
    if(countdownTimer!=null){
      countdownTimer!.cancel();
    }
  }
  _showPermissionCustomDialog(){
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
                        },
                        child: Icon(Icons.close_rounded,color: Colors.red,size: 20,),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "Please allow below permissions for access the Attendance Functionality.",
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 14),),
                    SizedBox(height: 10,),
                    Text(
                      "1.) Location Permission",
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 14),),
                    SizedBox(height: 5,),
                    Text(
                      "2.) Enable GPS Services",
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 14),),

                    SizedBox(height: 20,),
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          //call attendance punch in or out
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.themeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(child: Text("OK",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
                        )
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
  _showCameraPermissionCustomDialog(){
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
                        },
                        child: Icon(Icons.close_rounded,color: Colors.red,size: 20,),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "Please allow Camera Permissions For Capture Image",
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 14),),

                    SizedBox(height: 20,),
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          //call attendance punch in or out
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.themeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(child: Text("OK",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
                        )
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
  _showFaceErrorCustomDialog(){
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
                        },
                        child: Icon(Icons.close_rounded,color: Colors.red,size: 20,),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "Please capture Selfie!!!",
                      style: TextStyle(color: Colors.red,fontWeight: FontWeight.w900,fontSize: 18),),
                    SizedBox(height: 20,),

                    Text(
                      "Face not detected in captured Image. Please capture Selfie.",
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 14),),
                    SizedBox(height: 20,),
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          //call attendance punch in or out
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.themeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(child: Text("OK",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
                        )
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String),fit: BoxFit.cover,width: 70,height: 70,gaplessPlayback: true,);
  }
  markAttendance() async{
    String attendanceCheck="";
    String addressStr="";
    if(showCheckIn){
      attendanceCheck="in";
    }else{
      attendanceCheck="out";
    }
    if(_currentAddress!=null){
      addressStr=_currentAddress!;
    }else{
      addressStr="Address Not Available";
    }



    APIDialog.showAlertDialog(context, 'Submitting Attendance...');



    final bytes= await File(file!.path).readAsBytesSync();
    String base64Image="data:image/jpeg;base64,"+base64Encode(bytes);
    print("imagePan $base64Image");
    print("Base Url $baseUrl");
    print("Check Status $attendanceCheck");
    print("emp_user_id $userIdStr");

    var requestModel = {
      "emp_user_id": userIdStr,
      "latitude":_currentPosition!.latitude.toString(),
      "longitude":_currentPosition!.longitude.toString(),
      "status":"status",
      "attendance_check_status":attendanceCheck,
      "attendance_type" : "attendance",
      "attendance_check_location":addressStr,
      "capture":base64Image,
      "device":platform,
      "mac_address":"flutter",
      "other_break_time":"00:00:00:00",
      "comment":"flutter",
    };
    ApiBaseHelper apiBaseHelper=  ApiBaseHelper();
    var response = await apiBaseHelper.postAPIWithHeader(baseUrl, "attendance_management/attendanceCheckInCheckOut", requestModel, context, token);

    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      _showCustomDialog();
    }else if(responseJSON['code']==401|| responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _logOut(context);
    }else{
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }


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
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
  }
  /************Camera Functinality*********************/
  _faceFromCamera() async{
    APIDialog.showAlertDialog(context, "Detecting Face....");
    final image=InputImage.fromFile(capturedFile!);
    final faces=await _faceDetector.processImage(image);
    print("faces in image ${faces.length}");
    Navigator.pop(context);
    if(faces.isNotEmpty){
      // _showImageDialog();
      _showCameraImageDialog();
    }else{
      Toast.show("Face not detected in captured image. Please capture a selfie.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _showFaceErrorCustomDialog();
    }
  }
  _showCameraImageDialog(){

    showDialog(context: context, builder: (ctx)=>AlertDialog(
        title: const Text("Mark Attendance",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 18),),
        content: Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.rectangle,
            image: DecorationImage(
                image: FileImage(capturedFile!),
                fit: BoxFit.cover
            ),

          ),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: (){
                Navigator.of(ctx).pop();
                // markAttendance();
                markAttendanceFromCamera();
                //call attendance punch in or out
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme.themeColor,
                ),
                height: 45,
                padding: const EdgeInsets.all(10),
                child: const Center(child: Text("Mark",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
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
                child: const Center(child: Text("Cancel",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
              )
          )
        ]
    ));
  }
  markAttendanceFromCamera() async{
    String attendanceCheck="";
    String addressStr="";
    if(showCheckIn){
      attendanceCheck="in";
    }else{
      attendanceCheck="out";
    }
    if(_currentAddress!=null){
      addressStr=_currentAddress!;
    }else{
      addressStr="Address Not Available";
    }



    APIDialog.showAlertDialog(context, 'Submitting Attendance...');



    final bytes= await File(capturedFile!.path).readAsBytesSync();
    String base64Image="data:image/jpeg;base64,"+base64Encode(bytes);
    print("imagePan $base64Image");
    print("Base Url $baseUrl");
    print("Check Status $attendanceCheck");
    print("emp_user_id $userIdStr");

    var requestModel = {
      "emp_user_id": userIdStr,
      "latitude":_currentPosition!.latitude.toString(),
      "longitude":_currentPosition!.longitude.toString(),
      "status":"status",
      "attendance_check_status":attendanceCheck,
      "attendance_type" : "attendance",
      "attendance_check_location":addressStr,
      "capture":base64Image,
      "device":platform,
      "mac_address":"flutter",
      "other_break_time":"00:00:00:00",
      "comment":"flutter",
    };
    ApiBaseHelper apiBaseHelper=  ApiBaseHelper();
    var response = await apiBaseHelper.postAPIWithHeader(baseUrl, "attendance_management/attendanceCheckInCheckOut", requestModel, context, token);

    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      _showCustomDialog();
    }else if(responseJSON['code']==401|| responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _logOut(context);
    }else{
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }


  }
  _showLocationErrorCustomDialog(String distanceStr){
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
                        },
                        child: Icon(Icons.close_rounded,color: Colors.red,size: 20,),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "Location Not Matched !",
                      style: TextStyle(color: Colors.red,fontWeight: FontWeight.w900,fontSize: 18),),
                    SizedBox(height: 20,),

                    Text(
                      "You are not Allowed to Check-In OR Check-Out on this Location. You are $distanceStr away from required Location.",
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 14),),
                    SizedBox(height: 20,),
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          //call attendance punch in or out
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.themeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(child: Text("OK",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
                        )
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
  /**************Attendance correction Functinality For QD**************/
  getCorrectionNotification() async {

    setState(() {
      isCorrectLoading=true;
    });

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl, 'rest_api/get-correction-notification', token, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {


      List<dynamic> tempDataList=responseJSON['data'];


      if(tempDataList.isNotEmpty){
        String samplenotiStr=tempDataList[0]['message'].toString();
        correctionAllowDate.clear();
        List<dynamic> dateTempList=tempDataList[0]['correction_allow_dates'];
        for(int i=0;i<dateTempList.length;i++){
          correctionAllowDate.add(dateTempList[i]['date'].toString());
        }
      }
      setState(() {
        isCorrectLoading=false;
      });
    }
    else if(responseJSON['code']==401 || responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        isCorrectLoading=false;
      });
      _logOut(context);
    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        isCorrectLoading=false;
      });

    }
  }
  bool _checkCorrectionValidation(String dateStr){
    bool isValidate=false;
    if(clientCode=='QD100'){
      if(correctionAllowDate.contains(dateStr)){

        isValidate=true;
      }else{
        isValidate=false;
      }

    }else{
      isValidate=true;
    }

    return isValidate;
  }
  _navigateToAttendanceCorrectionScreen(String dateStr,String firstHalfTime,String secondHalfTime,String workingHour,String attStatus){


    if(clientCode=='QD100'){
      Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyQDAttendanceCorrection(alDate: dateStr,alCheckIn: firstHalfTime,alcheckOut: secondHalfTime,attStatus: attStatus,)),);
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyAttendanceCorrectionScreen(alDate: dateStr,alCheckIn: firstHalfTime,alcheckOut: secondHalfTime,)),);
    }

  }
  /**********Attendance Lock Functionality*****************/

  getAttendanceStatus() async {


    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithBase(baseUrl, 'attendance_management/getLockAttendanceData?year=$attendanceYear&month=$attendanceMonth',context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {

      List<dynamic>tempList=[];
      tempList=responseJSON['data'];
      if(tempList.isNotEmpty){
        for(int i=0;i<tempList.length;i++){
          String month=tempList[i]['mon'].toString();
          String year=tempList[i]['year'].toString();
          int isLock=tempList[i]['is_locked'];
          print("$month-$year attendance Lock Status $isLock");
          if(month==attendanceMonth && year==attendanceYear){
            if(isLock==1){
              isAttendanceLock=true;
            }else{
              isAttendanceLock=false;
            }
            break;
          }else{

            isAttendanceLock=false;
          }
        }
      }else{
        isAttendanceLock=false;
      }





      setState(() {
      });



    } else {
      isAttendanceLock=false;
      setState(() {

      });

    }
  }

}