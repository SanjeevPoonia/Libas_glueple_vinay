import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import '../utils/attendance_details_series.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'ViewTeamAttendanceLogs.dart';

class ShowTeamAttendance extends StatefulWidget{
  final String empId;
  final String designation;
  final String name;
  final String empProfile;

   const ShowTeamAttendance(this.empId, this.designation, this.name,this.empProfile, {super.key});

  _showTeamAttendance createState()=>_showTeamAttendance();
}
class _showTeamAttendance extends State<ShowTeamAttendance>{
  String currentMonthName="";
  String currentTimeName="";
  String currentDateName="";
  bool isLoading=false;


  var baseUrl="";
  var platform="";
  List<AttendanceDetailsSeries> attendanceDate=[];


  String currentmonth="";
  String showingmonth="";

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
            Container(
              width: double.infinity,
              height: 120,
              color: AppTheme.at_details_header,
              child: Padding(padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    widget.empProfile==""?
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/profile.png"),
                      radius: 50,)
                        :
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: CachedNetworkImage(
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        imageUrl: widget.empProfile,
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            CircularProgressIndicator(value: downloadProgress.progress),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                      //child: Image.network(widget.empProfile,width: 100,height: 100,fit: BoxFit.cover,),

                    ),

                    SizedBox(width: 10,),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.name,
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900,color: Colors.black),),
                        SizedBox(height: 5,),
                        Text("${widget.empId}  |  ${widget.designation}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
                      ],
                    ),flex: 1,)

                  ],
                ),),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewTeamAttendanceLogs(attendanceDate[index].dateStr,attendanceDate[index].firstCheckIn,attendanceDate[index].lastCheckOut,attendanceDate[index].totalTime,widget.empId)),);
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
                                   // Text("Check In",style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
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
                                    //Text("Check Out",style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
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



                                /*  attendanceDate[index].firstCheckIn=="00:00:00"?Expanded(child: Align(alignment: Alignment.center,child: Text(firstHalfText,style: TextStyle(color: firstHalfColor,fontWeight: FontWeight.w900,fontSize: 12),),)):
                                      Expanded(child: Align(alignment: Alignment.center,child: RichText(
                                        text: TextSpan(
                                            children: [
                                              WidgetSpan(child: Icon(Icons.arrow_drop_down,color: Colors.green,size: 10,)),
                                              TextSpan(text:firstHalfText,style: TextStyle(color: firstHalfColor,fontSize: 12,fontWeight: FontWeight.w500))
                                            ]
                                        ),
                                      ),) ),
                                      attendanceDate[index].lastCheckOut=="00:00:00"?Expanded(child: Align(alignment: Alignment.center,child: Text(secondHalfText,style: TextStyle(color: secondHalfColor,fontWeight: FontWeight.w900,fontSize: 12),),)):
                                      Expanded(child: Align(alignment: Alignment.center,child: RichText(
                                        text: TextSpan(
                                            children: [
                                              WidgetSpan(child: Icon(Icons.arrow_drop_up,color: Colors.red,size: 10,)),
                                              TextSpan(text:secondHalfText,style: TextStyle(color: secondHalfColor,fontSize: 12,fontWeight: FontWeight.w500))
                                            ]
                                        ),
                                      ),)),
                                      attendanceDate[index].totalTime=="00:00:00"?Expanded(child: Align(alignment: Alignment.center,child: Text(workingHourText,style: TextStyle(color: workingHourColor,fontWeight: FontWeight.w900,fontSize: 12),),)):
                                      Expanded(child: Align(alignment: Alignment.center,child: RichText(
                                        text: TextSpan(
                                            children: [
                                              TextSpan(text:workingHourText,style: TextStyle(color: workingHourColor,fontSize: 12,fontWeight: FontWeight.w500)),
                                              WidgetSpan(child: Icon(Icons.keyboard_arrow_down,color: Colors.black,size: 10,)),
                                            ]
                                        ),
                                      ),)),
*/

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
            /*ListView.builder(
              shrinkWrap: true,
              physics:NeverScrollableScrollPhysics(),
              itemCount: attendanceDate.length,
              itemBuilder: (BuildContext cntx,int index){

                String firstHalfText="";
                var firstHalfColor=Colors.black;
                String secondHalfText="";
                var secondHalfColor=Colors.black;
                String workingHourText="";
                var workingHourColor=Colors.black;
                if(attendanceDate[index].firstCheckIn=="00:00:00"||attendanceDate[index].firstCheckIn=="Invalid date"){
                  firstHalfText=attendanceDate[index].firstHalfStatus;
                  if(attendanceDate[index].firstHalfStatus=="AB"){
                    firstHalfColor=Colors.red;
                  }else{
                    firstHalfColor=AppTheme.greyColor;
                  }
                }else{
                  firstHalfText=attendanceDate[index].firstCheckIn;
                  if(attendanceDate[index].firstHalfStatus=="AB"){
                    firstHalfColor=Colors.red;
                  }else{
                    firstHalfColor=Colors.black;
                  }
                }
                if(attendanceDate[index].lastCheckOut=="00:00:00"||attendanceDate[index].lastCheckOut=="Invalid date"){
                  secondHalfText=attendanceDate[index].secondHalfStatus;
                  if(attendanceDate[index].secondHalfStatus=="AB"){
                    secondHalfColor=Colors.red;
                  }else{
                    secondHalfColor=AppTheme.greyColor;
                  }
                }else{
                  secondHalfText=attendanceDate[index].lastCheckOut;
                  if(attendanceDate[index].secondHalfStatus=="AB"){
                    secondHalfColor=Colors.red;
                  }else{
                    secondHalfColor=Colors.black;
                  }
                }
                if(attendanceDate[index].totalTime=="00:00:00"){
                  workingHourText=attendanceDate[index].attendanceStatus;
                  if(attendanceDate[index].attendanceStatus=="AB"){
                    workingHourColor=Colors.red;
                  }else{
                    workingHourColor=AppTheme.greyColor;
                  }
                }else{
                  workingHourText=attendanceDate[index].totalTime;
                  if(attendanceDate[index].attendanceStatus=="AB"){
                    workingHourColor=Colors.red;
                  }else{
                    workingHourColor=Colors.black;
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

                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewTeamAttendanceLogs(attendanceDate[index].dateStr,attendanceDate[index].firstCheckIn,attendanceDate[index].lastCheckOut,attendanceDate[index].totalTime,widget.empId)),);

                      },
                        child: Container(
                          height: 55,
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
                                  children: [
                                    Text("Check In",style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
                                    Text(firstHalfText,style: TextStyle(color: firstHalfColor,fontSize: 14.5,fontWeight: FontWeight.w900),)
                                  ],
                                )),
                                const SizedBox(width: 1,),
                                Container(width: 1,color: AppTheme.at_details_divider,),
                                const SizedBox(width: 1,),
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Check Out",style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
                                    Text(secondHalfText,style: TextStyle(color: secondHalfColor,fontSize: 14.5,fontWeight: FontWeight.w900),)
                                  ],
                                )),
                                const SizedBox(width: 1,),
                                Container(width: 1,color: AppTheme.at_details_divider,),
                                const SizedBox(width: 1,),
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Working Hrs",style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
                                    Text(workingHourText,style: TextStyle(color: workingHourColor,fontSize: 14.5,fontWeight: FontWeight.w900),)
                                  ],
                                )),



                                *//*  attendanceDate[index].firstCheckIn=="00:00:00"?Expanded(child: Align(alignment: Alignment.center,child: Text(firstHalfText,style: TextStyle(color: firstHalfColor,fontWeight: FontWeight.w900,fontSize: 12),),)):
                                      Expanded(child: Align(alignment: Alignment.center,child: RichText(
                                        text: TextSpan(
                                            children: [
                                              WidgetSpan(child: Icon(Icons.arrow_drop_down,color: Colors.green,size: 10,)),
                                              TextSpan(text:firstHalfText,style: TextStyle(color: firstHalfColor,fontSize: 12,fontWeight: FontWeight.w500))
                                            ]
                                        ),
                                      ),) ),
                                      attendanceDate[index].lastCheckOut=="00:00:00"?Expanded(child: Align(alignment: Alignment.center,child: Text(secondHalfText,style: TextStyle(color: secondHalfColor,fontWeight: FontWeight.w900,fontSize: 12),),)):
                                      Expanded(child: Align(alignment: Alignment.center,child: RichText(
                                        text: TextSpan(
                                            children: [
                                              WidgetSpan(child: Icon(Icons.arrow_drop_up,color: Colors.red,size: 10,)),
                                              TextSpan(text:secondHalfText,style: TextStyle(color: secondHalfColor,fontSize: 12,fontWeight: FontWeight.w500))
                                            ]
                                        ),
                                      ),)),
                                      attendanceDate[index].totalTime=="00:00:00"?Expanded(child: Align(alignment: Alignment.center,child: Text(workingHourText,style: TextStyle(color: workingHourColor,fontWeight: FontWeight.w900,fontSize: 12),),)):
                                      Expanded(child: Align(alignment: Alignment.center,child: RichText(
                                        text: TextSpan(
                                            children: [
                                              TextSpan(text:workingHourText,style: TextStyle(color: workingHourColor,fontSize: 12,fontWeight: FontWeight.w500)),
                                              WidgetSpan(child: Icon(Icons.keyboard_arrow_down,color: Colors.black,size: 10,)),
                                            ]
                                        ),
                                      ),)),
*//*

                              ],
                            ),
                          ),
                        ),),
                      const SizedBox(height: 10,)
                    ],
                  ),
                );


              },
            )*/

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


    baseUrl=await MyUtils.getSharedPreferences("base_url")??"";


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

    _getCurrentMonthAttendance();


  }


  _getCurrentMonthAttendance(){
    final now = DateTime.now();
    var date = DateTime(now.year, now.month, 1).toString();
    var dateParse = DateTime.parse(date);
    var firstDayOfMonth=DateFormat("yyyy-MM-dd").format(dateParse);
    var currentDayOfMonth=DateFormat("yyyy-MM-dd").format(now);




    showingmonth=DateFormat.yMMM().format(now);
    print("Showing Month: "+showingmonth);
    print("Current Month: "+currentmonth);


    _getAttendanceDetails(firstDayOfMonth, currentDayOfMonth);

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



    _getAttendanceDetails(firstDayOfMonth, currentDayOfMonth);
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



    _getAttendanceDetails(firstDayOfMonth, currentDayOfMonth);
  }

  _getAttendanceDetails(String startDate,String endDate)async{



    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    var requestModel = {
      "emp_id": widget.empId,
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


}