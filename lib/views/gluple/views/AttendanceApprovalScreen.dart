import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../qd_attendance/view_leaveimage_screen.dart';
import '../utils/app_theme.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class AttendaceApprovalScreen extends StatefulWidget{
  String attendaceType;
 final String attendanceTitle;

  AttendaceApprovalScreen(this.attendaceType, this.attendanceTitle, {super.key});

  _attendanceApproval createState()=>_attendanceApproval();
}
class _attendanceApproval extends State<AttendaceApprovalScreen>{
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;
  late var platform;
  bool isLoading=false;
  List<dynamic> approvalRequestList=[];
  final _formKey = GlobalKey<FormState>();
  var reasonController = TextEditingController();
  final _focusNode = FocusNode();

  var fromDateItem=['Full Day','First Half Day','Second Half Day'];
  String fromDropDownValue = 'Full Day';

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
       title:  Text(
         widget.attendanceTitle,
         style: const TextStyle(
             fontSize: 18.5,
             fontWeight: FontWeight.bold,
             color: Colors.black),
       ),
       /*actions: [IconButton(onPressed: (){
          _showAlertDialog();

        }, icon: SvgPicture.asset("assets/logout.svg"))] ,*/
       centerTitle: true,
     ),
     body: ListView.builder(
         itemCount: approvalRequestList.length,
         physics: const ScrollPhysics(),
         itemBuilder: (BuildContext cntx,int indx){
           String empImage="";
           if(approvalRequestList[indx]['emp_img']!=null){
             empImage=baseUrl+'employee_profile_picture/'+approvalRequestList[indx]['emp_img'];
           }
           String empFullName="";
           if(approvalRequestList[indx]['employee_name']!=null){
              empFullName=approvalRequestList[indx]['employee_name'].toString();
           }
           String queryMsg="";
           if(approvalRequestList[indx]['query_type']!=null){
             queryMsg=approvalRequestList[indx]['query_type'].toString();
           }
           String generatedTime="";

           String actualIntime="";
           String actualOutTime="";
           String correctedInTime="";
           String correctedOutTime="";
           String attendanceId=approvalRequestList[indx]['id'].toString();
           String attType=approvalRequestList[indx]['type'].toString();
           String leaveReson="";
           String leaveType="";
           String visitingDestination="";
           String sickLeavefileUrl="";
           bool showFileIcon=false;

           if(approvalRequestList[indx]['type'].toString()=='attendance_correction'){
             if(approvalRequestList[indx]['correction_request_raised_at']!=null){
               DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(approvalRequestList[indx]['correction_request_raised_at'].toString());
               var inputDate = DateTime.parse(parseDate.toString());
               var outputFormat = DateFormat('dd MMM,yyyy hh:mm a');
               var outputDate = outputFormat.format(inputDate);
               generatedTime=outputDate;
             }
             if(approvalRequestList[indx]['actual_check_in_time']!=null){
               if(approvalRequestList[indx]['actual_check_in_time']!="Invalid date"){
                 actualIntime=approvalRequestList[indx]['actual_check_in_time'];
               }else{
                 actualIntime="Not Available";
               }


             }
             if(approvalRequestList[indx]['actual_check_out_time']!=null){
               if(approvalRequestList[indx]['actual_check_out_time']!="Invalid date"){
                 actualOutTime=approvalRequestList[indx]['actual_check_out_time'];
               }else{
                 actualOutTime="Not Available";
               }


             }
             if(approvalRequestList[indx]['corrected_check_in_time']!=null){
               if(approvalRequestList[indx]['corrected_check_in_time']!="Invalid date"){
                 correctedInTime=approvalRequestList[indx]['corrected_check_in_time'];
               }else{
                 correctedInTime="Not Available";
               }


             }
             if(approvalRequestList[indx]['corrected_check_out_time']!=null){
               if(approvalRequestList[indx]['corrected_check_out_time']!="Invalid date"){
                 correctedOutTime=approvalRequestList[indx]['corrected_check_out_time'];
               }else{
                 correctedOutTime="Not Available";
               }


             }
             if(approvalRequestList[indx]['correction_reason']!=null){
               leaveReson=approvalRequestList[indx]['correction_reason'].toString();
             }
           }
           else if(approvalRequestList[indx]['type'].toString()=='web_checkin_without_camera'){
             if(approvalRequestList[indx]['created_at']!=null){
               var deliveryTime=DateTime.parse(approvalRequestList[indx]['created_at']);
               var delLocal=deliveryTime.toLocal();
               generatedTime=DateFormat('dd MMM,yyyy hh:mm a').format(delLocal);
             }

           }
           else if(approvalRequestList[indx]['type'].toString()=='leave'){

             if(approvalRequestList[indx]['created_at']!=null){
               var deliveryTime=DateTime.parse(approvalRequestList[indx]['created_at']);
               var delLocal=deliveryTime.toLocal();
               generatedTime=DateFormat('dd MMM,yyyy hh:mm a').format(delLocal);
             }
             if(approvalRequestList[indx]['reason']!=null){
               leaveReson=approvalRequestList[indx]['reason'].toString();
             }
             if(approvalRequestList[indx]['leave_type']!=null){
               leaveType=approvalRequestList[indx]['leave_type'].toString();
             }

             if(leaveType=="sick_leave"){
               if(approvalRequestList[indx]['file_name']!=null){
                 sickLeavefileUrl=baseUrl+'employee_leave_documents/'+approvalRequestList[indx]['file_name'];
                 print("sick_leav_file_url : $sickLeavefileUrl");
                 if(sickLeavefileUrl.contains('.jpg')||sickLeavefileUrl.contains('.jpeg')||sickLeavefileUrl.contains('.png')||sickLeavefileUrl.contains('.JPG')||sickLeavefileUrl.contains('.JPEG')||sickLeavefileUrl.contains('.PNG')){
                   showFileIcon=true;
                 }else{
                   showFileIcon=false;
                 }

               }else{
                 showFileIcon=false;
               }
             }else{
               showFileIcon=false;
             }


           }
           else if(approvalRequestList[indx]['type'].toString()=='comp_off'){
             if(approvalRequestList[indx]['created_at']!=null){
               var deliveryTime=DateTime.parse(approvalRequestList[indx]['created_at']);
               var delLocal=deliveryTime.toLocal();
               generatedTime=DateFormat('dd MMM,yyyy hh:mm a').format(delLocal);
             }
             if(approvalRequestList[indx]['reason']!=null){
               leaveReson=approvalRequestList[indx]['reason'].toString();
             }

           }
           else if(approvalRequestList[indx]['type'].toString()=='tour'){
             if(approvalRequestList[indx]['created_at']!=null){
               var deliveryTime=DateTime.parse(approvalRequestList[indx]['created_at']);
               var delLocal=deliveryTime.toLocal();
               generatedTime=DateFormat('dd MMM,yyyy hh:mm a').format(delLocal);
             }
             if(approvalRequestList[indx]['reason']!=null){
               leaveReson=approvalRequestList[indx]['reason'].toString();
             }
             if(approvalRequestList[indx]['visiting_destination']!=null){
               visitingDestination=approvalRequestList[indx]['visiting_destination'].toString();
             }
             if(approvalRequestList[indx]['emp_name']!=null){
               empFullName=approvalRequestList[indx]['emp_name'].toString();
             }

           }
           
           return attType=='attendance_correction'? Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                 child: Container(
                   decoration: BoxDecoration(
                     shape: BoxShape.rectangle,
                     borderRadius: BorderRadius.all(Radius.circular(10),),
                     border: Border.all(width: 1,color: AppTheme.themeColor,style: BorderStyle.solid),
                     color: AppTheme.cardColor
                   ),
                   padding: EdgeInsets.all(5),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(queryMsg,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900,color: Colors.black),),
                       SizedBox(height: 10,),
                       Row(
                         children: [
                           empImage==""?
                           const CircleAvatar(
                             backgroundImage: AssetImage("assets/profile.png"),
                             radius: 20,)
                               :
                           ClipRRect(
                             borderRadius: BorderRadius.circular(20.0),
                             child: Image.network(empImage,height: 40,width: 40,fit: BoxFit.cover),),
                           const SizedBox(width: 10,),
                           Expanded(flex: 1,child: Text(empFullName,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: AppTheme.themeColor),),),
                           const SizedBox(width: 10,),
                           Text(generatedTime,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppTheme.themeColor),),
                         ],
                       ),
                       SizedBox(height: 10,),
                       Text("Actual Time",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
                       SizedBox(height: 10,),
                       Row(
                         children: [
                           Expanded(child:
                           Row(
                             children: [
                               Text("IN:-",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: AppTheme.orangeColor),),
                               SizedBox(width: 5,),
                               Text(actualIntime,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: AppTheme.orangeColor),),
                             ],
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.start,
                           )
                           ),
                           SizedBox(width: 10,),
                           Expanded(child:
                           Row(
                             children: [
                               Text("Out:-",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: AppTheme.orangeColor),),
                               SizedBox(width: 5,),
                               Text(actualOutTime,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: AppTheme.orangeColor),),
                             ],
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.start,
                           )
                           ),

                         ],
                       ),

                       SizedBox(height: 10,),
                       Text("Corrected Time",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
                       SizedBox(height: 10,),
                       Row(
                         children: [
                           Expanded(child:
                           Row(
                             children: [
                               Text("IN:-",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: Colors.black),),
                               SizedBox(width: 5,),
                               Text(correctedInTime,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: Colors.black),),
                             ],
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.start,
                           )
                           ),
                           SizedBox(width: 10,),
                           Expanded(child:
                           Row(
                             children: [
                               Text("Out:-",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: Colors.black),),
                               SizedBox(width: 5,),
                               Text(correctedOutTime,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: Colors.black),),
                             ],
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.start,
                           )
                           ),

                         ],
                       ),

                       SizedBox(height: 10,),
                       Text("Correction Reason",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
                       Padding(padding: EdgeInsets.only(left: 10),
                         child: Text(leaveReson,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14,color: AppTheme.orangeColor),),),

                       SizedBox(height: 10,),
                       Row(
                         crossAxisAlignment: CrossAxisAlignment.end,
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                           InkWell(
                             onTap: (){
                               _showAttendanceBottomDialogForApprove(attType, attendanceId, 1, "Correction",indx);
                             },
                             child: Container(
                               height: 25,
                               width: 75,
                               decoration: BoxDecoration(
                                 shape: BoxShape.rectangle,
                                 color: Colors.green,
                                 borderRadius: BorderRadius.all(Radius.circular(7)),
                               ),
                               child: Center(
                                 child: const Text(
                                   "Approve",
                                   textAlign: TextAlign.center,
                                   style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: Colors.white),
                                 ),
                               ),
                             ),
                           ),
                           SizedBox(width: 10,),
                           InkWell(
                             onTap: (){
                               _showAttendanceBottomDialogForApprove(attType, attendanceId, 0, "Correction",indx);
                             },
                             child: Container(
                               height: 25,
                               width: 75,
                               decoration: BoxDecoration(
                                 shape: BoxShape.rectangle,
                                 color: Colors.red,
                                 borderRadius: BorderRadius.all(Radius.circular(7)),
                               ),
                               child: Center(
                                 child: const Text(
                                   "Reject",
                                   textAlign: TextAlign.center,
                                   style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: Colors.white),
                                 ),
                               ),
                             ),
                           ),

                         ],
                       ),
                       SizedBox(height: 10,),
                     ],
                   ),
                 ),
               ):
           attType=='web_checkin_without_camera'? Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
             child: Container(
               decoration: BoxDecoration(
                   shape: BoxShape.rectangle,
                   borderRadius: BorderRadius.all(Radius.circular(10),),
                   border: Border.all(width: 1,color: AppTheme.themeColor,style: BorderStyle.solid),
                   color: AppTheme.cardColor
               ),
               padding: EdgeInsets.all(5),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(queryMsg,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900,color: Colors.black),),
                   SizedBox(height: 10,),
                   Row(
                     children: [
                       empImage==""?
                       const CircleAvatar(
                         backgroundImage: AssetImage("assets/profile.png"),
                         radius: 20,)
                           :
                       ClipRRect(
                         borderRadius: BorderRadius.circular(20.0),
                         child: Image.network(empImage,height: 40,width: 40,fit: BoxFit.cover),),
                       const SizedBox(width: 10,),
                       Expanded(flex: 1,child: Text(empFullName,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: AppTheme.themeColor),),),
                       const SizedBox(width: 10,),
                       Text(generatedTime,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppTheme.themeColor),),
                     ],
                   ),
                   SizedBox(height: 10,),
                   Row(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       InkWell(
                         onTap: (){
                           _showAttendanceBottomDialogForApprove(attType, attendanceId, 1, "Web Attendance",indx);
                         },
                         child: Container(
                           height: 25,
                           width: 75,
                           decoration: BoxDecoration(
                             shape: BoxShape.rectangle,
                             color: Colors.green,
                             borderRadius: BorderRadius.all(Radius.circular(7)),
                           ),
                           child: Center(
                             child: const Text(
                               "Approve",
                               textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: Colors.white),
                             ),
                           ),
                         ),
                       ),
                       SizedBox(width: 10,),
                       InkWell(
                         onTap: (){
                           _showAttendanceBottomDialogForApprove(attType, attendanceId, 0, "Web Attendance",indx);
                         },
                         child: Container(
                           height: 25,
                           width: 75,
                           decoration: BoxDecoration(
                             shape: BoxShape.rectangle,
                             color: Colors.red,
                             borderRadius: BorderRadius.all(Radius.circular(7)),
                           ),
                           child: Center(
                             child: const Text(
                               "Reject",
                               textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: Colors.white),
                             ),
                           ),
                         ),
                       ),

                     ],
                   ),
                   SizedBox(height: 10,),
                 ],
               ),
             ),
           ):
           attType=='leave'? Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
             child: Container(
               decoration: BoxDecoration(
                   shape: BoxShape.rectangle,
                   borderRadius: BorderRadius.all(Radius.circular(10),),
                   border: Border.all(width: 1,color: AppTheme.themeColor,style: BorderStyle.solid),
                   color: AppTheme.cardColor
               ),
               padding: EdgeInsets.all(5),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(queryMsg,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900,color: Colors.black),),
                   SizedBox(height: 10,),
                   Row(
                     children: [
                       empImage==""?
                       const CircleAvatar(
                         backgroundImage: AssetImage("assets/profile.png"),
                         radius: 20,)
                           :
                       ClipRRect(
                         borderRadius: BorderRadius.circular(20.0),
                         child: Image.network(empImage,height: 40,width: 40,fit: BoxFit.cover),),
                       const SizedBox(width: 10,),
                       Expanded(flex: 1,child: Text(empFullName,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: AppTheme.themeColor),),),
                       const SizedBox(width: 10,),
                       Text(generatedTime,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppTheme.themeColor),),
                     ],
                   ),
                   SizedBox(height: 10,),
                   Text("Leave Reason",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
                   Padding(padding: EdgeInsets.only(left: 10),
                   child: Text(leaveReson,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14,color: AppTheme.orangeColor),),),
                   SizedBox(height: 10,),
                   Row(
                     children: [
                       showFileIcon?
                       InkWell(
                         onTap: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context) => ViewLeaveImageScreen(sickLeavefileUrl)),);
                         },
                         child: Container(
                           padding: EdgeInsets.symmetric(horizontal: 5),
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(5),
                               color: AppTheme.themeColor),
                           height: 30,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Icon(Icons.remove_red_eye_outlined,
                                 color: Colors.white,
                                 size: 24,
                               ),
                               SizedBox(width: 2,),
                               Text("File",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12,color: Colors.white),),
                             ],
                           ),

                         ),
                       )
                           :SizedBox(width: 1,),
                       SizedBox(width: 5,),
                       Expanded(child: Row(
                         crossAxisAlignment: CrossAxisAlignment.end,
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                           Text(leaveType,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w900,color: AppTheme.themeColor),),
                           SizedBox(width: 10,),
                           InkWell(
                             onTap: (){
                               _showAttendanceBottomDialogForApprove(attType, attendanceId, 1, "Leave",indx);
                             },
                             child: Container(
                               height: 25,
                               width: 75,
                               decoration: BoxDecoration(
                                 shape: BoxShape.rectangle,
                                 color: Colors.green,
                                 borderRadius: BorderRadius.all(Radius.circular(7)),
                               ),
                               child: Center(
                                 child: const Text(
                                   "Approve",
                                   textAlign: TextAlign.center,
                                   style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: Colors.white),
                                 ),
                               ),
                             ),
                           ),
                           SizedBox(width: 10,),
                           InkWell(
                             onTap: (){
                               _showAttendanceBottomDialogForApprove(attType, attendanceId, 0, "Leave",indx);
                             },
                             child: Container(
                               height: 25,
                               width: 75,
                               decoration: BoxDecoration(
                                 shape: BoxShape.rectangle,
                                 color: Colors.red,
                                 borderRadius: BorderRadius.all(Radius.circular(7)),
                               ),
                               child: Center(
                                 child: const Text(
                                   "Reject",
                                   textAlign: TextAlign.center,
                                   style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: Colors.white),
                                 ),
                               ),
                             ),
                           ),

                         ],
                       ))
                     ],
                   ),
                   SizedBox(height: 10,),
                 ],
               ),
             ),
           ):
           attType=='comp_off'? Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
             child: Container(
               decoration: BoxDecoration(
                   shape: BoxShape.rectangle,
                   borderRadius: BorderRadius.all(Radius.circular(10),),
                   border: Border.all(width: 1,color: AppTheme.themeColor,style: BorderStyle.solid),
                   color: AppTheme.cardColor
               ),
               padding: EdgeInsets.all(5),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(queryMsg,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900,color: Colors.black),),
                   SizedBox(height: 10,),
                   Row(
                     children: [
                       empImage==""?
                       const CircleAvatar(
                         backgroundImage: AssetImage("assets/profile.png"),
                         radius: 20,)
                           :
                       ClipRRect(
                         borderRadius: BorderRadius.circular(20.0),
                         child: Image.network(empImage,height: 40,width: 40,fit: BoxFit.cover),),
                       const SizedBox(width: 10,),
                       Expanded(flex: 1,child: Text(empFullName,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: AppTheme.themeColor),),),
                       const SizedBox(width: 10,),
                       Text(generatedTime,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppTheme.themeColor),),
                     ],
                   ),
                   SizedBox(height: 10,),
                   Text("Comp-Off Reason",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
                   Padding(padding: EdgeInsets.only(left: 10),
                     child: Text(leaveReson,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14,color: AppTheme.orangeColor),),),
                   SizedBox(height: 10,),
                   Row(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       InkWell(
                         onTap: (){
                           _showAttendanceBottomDialogForApprove(attType, attendanceId, 1, "Comp-Off",indx);
                         },
                         child: Container(
                           height: 25,
                           width: 75,
                           decoration: BoxDecoration(
                             shape: BoxShape.rectangle,
                             color: Colors.green,
                             borderRadius: BorderRadius.all(Radius.circular(7)),
                           ),
                           child: Center(
                             child: const Text(
                               "Approve",
                               textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: Colors.white),
                             ),
                           ),
                         ),
                       ),
                       SizedBox(width: 10,),
                       InkWell(
                         onTap: (){
                           _showAttendanceBottomDialogForApprove(attType, attendanceId, 0, "Comp-Off",indx);
                         },
                         child: Container(
                           height: 25,
                           width: 75,
                           decoration: BoxDecoration(
                             shape: BoxShape.rectangle,
                             color: Colors.red,
                             borderRadius: BorderRadius.all(Radius.circular(7)),
                           ),
                           child: Center(
                             child: const Text(
                               "Reject",
                               textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: Colors.white),
                             ),
                           ),
                         ),
                       ),

                     ],
                   ),
                   SizedBox(height: 10,),
                 ],
               ),
             ),
           ):
           attType=='tour'? Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
             child: Container(
               decoration: BoxDecoration(
                   shape: BoxShape.rectangle,
                   borderRadius: BorderRadius.all(Radius.circular(10),),
                   border: Border.all(width: 1,color: AppTheme.themeColor,style: BorderStyle.solid),
                   color: AppTheme.cardColor
               ),
               padding: EdgeInsets.all(5),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(queryMsg,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900,color: Colors.black),),
                   SizedBox(height: 10,),
                   Row(
                     children: [
                       empImage==""?
                       const CircleAvatar(
                         backgroundImage: AssetImage("assets/profile.png"),
                         radius: 20,)
                           :
                       ClipRRect(
                         borderRadius: BorderRadius.circular(20.0),
                         child: Image.network(empImage,height: 40,width: 40,fit: BoxFit.cover),),
                       const SizedBox(width: 10,),
                       Expanded(flex: 1,child: Text(empFullName,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: AppTheme.themeColor),),),
                       const SizedBox(width: 10,),
                       Text(generatedTime,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppTheme.themeColor),),
                     ],
                   ),
                   SizedBox(height: 10,),
                   Text("Tour Reason",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
                   Padding(padding: EdgeInsets.only(left: 10),
                     child: Text(leaveReson,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14,color: AppTheme.orangeColor),),),
                   SizedBox(height: 10,),
                   Text("Visiting Destination",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
                   Padding(padding: EdgeInsets.only(left: 10),
                     child: Text(visitingDestination,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14,color: AppTheme.themeColor),),),

                   SizedBox(height: 10,),
                   Row(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       InkWell(
                         onTap: (){

                           _showAttendanceBottomDialogForApprove(attType, attendanceId, 1, "Tour",indx);
                          // _showAttendanceBottomDialog(attType, attendanceId, 1, "Tour",indx);
                         },
                         child: Container(
                           height: 25,
                           width: 75,
                           decoration: BoxDecoration(
                             shape: BoxShape.rectangle,
                             color: Colors.green,
                             borderRadius: BorderRadius.all(Radius.circular(7)),
                           ),
                           child: Center(
                             child: const Text(
                               "Approve",
                               textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: Colors.white),
                             ),
                           ),
                         ),
                       ),
                       SizedBox(width: 10,),
                       InkWell(
                         onTap: (){
                           _showAttendanceBottomDialogForApprove(attType, attendanceId, 0, "Tour",indx);
                          // _showAttendanceBottomDialog(attType, attendanceId, 0, "Tour",indx);
                         },
                         child: Container(
                           height: 25,
                           width: 75,
                           decoration: BoxDecoration(
                             shape: BoxShape.rectangle,
                             color: Colors.red,
                             borderRadius: BorderRadius.all(Radius.circular(7)),
                           ),
                           child: Center(
                             child: const Text(
                               "Reject",
                               textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: Colors.white),
                             ),
                           ),
                         ),
                       ),

                     ],
                   ),
                   SizedBox(height: 10,),
                 ],
               ),
             ),
           ):Container();
               
         }),
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


    getTaskBox();
  }
  getTaskBox() async {

    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl, 'common_api/getTaskBox', token, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      approvalRequestList.clear();
      if(responseJSON['data']['values']!=null){
        List<dynamic> templist=[];
        templist=responseJSON['data']['values']['attendance'];
        for(int i=0;i<templist.length;i++){
          if(templist[i]['type']!=null){
            String type=templist[i]['type'].toString();
            if(widget.attendaceType==type){
              approvalRequestList.add(templist[i]);
            }
          }
        }

      }
    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {
      isLoading=false;
    });
  }
  _showAttendanceBottomDialogForApprove(String type,String id,int status,String titles,int position){

    String title="";
    String btnText="";
    var btnColor=Colors.green;
    if(status==1){
      title= "Approve $titles";
      btnText="Approve";
      btnColor=Colors.green;
    }else{
      title= "Reject $titles";
      btnText="Reject";
      btnColor=Colors.red;
    }

    reasonController.text="";
    fromDropDownValue = 'Full Day';


    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext contx){
          return StatefulBuilder(builder: (ctx,setDialogState){
            return Padding(padding: MediaQuery.of(context).viewInsets,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
                ),
                child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20,),
                        Align(alignment: Alignment.center, child: Container(height: 5,width: 30,color: AppTheme.greyColor,),),
                        const SizedBox(height: 10,),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(child: Text(title,style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black,fontSize: 18.5),)),
                              const SizedBox(width: 5,),
                              InkWell(
                                onTap: (){
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(Icons.close_rounded,color: AppTheme.greyColor,size: 32,),
                              ),
                              const SizedBox(width: 5,),

                            ],
                          ),),

                        const SizedBox(height: 10,),
                        widget.attendaceType=='attendance_correction'?
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Text("Approve For",
                                style: TextStyle(fontSize: 14.5,
                                    color: AppTheme.themeColor,
                                    fontWeight: FontWeight.w500),),
                              SizedBox(width: 10,),
                              Expanded(child: Container(
                                width: double.infinity,
                                height: 45,
                                padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: AppTheme.greyColor,width: 2.0),

                                ),
                                child:

                                DropdownButton(
                                  items: fromDateItem.map((String items) {return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );}).toList(),
                                  onChanged: (String? newValue) {
                                    setDialogState(() {
                                      fromDropDownValue = newValue!;
                                    });
                                  },
                                  value: fromDropDownValue,
                                  icon: Icon(Icons.keyboard_arrow_down,color: AppTheme.themeColor,size: 15,),
                                  isExpanded: true,
                                  underline: SizedBox(),
                                ),
                              )),
                            ],
                          ),):
                            SizedBox(height: 1,),

                        SizedBox(height: 10,),




                        const Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("Enter Reason",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900,color: AppTheme.themeColor),),),
                        Form(
                            key: _formKey,
                            child:  Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black,width: 1,style: BorderStyle.solid),
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Center(
                                    child: TextField(
                                      minLines: 1,
                                      maxLines: 5,
                                      keyboardType: TextInputType.multiline,
                                      controller: reasonController,
                                      maxLength: 500,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                          border: InputBorder.none
                                      ),
                                      focusNode: _focusNode,

                                    ),
                                  ),
                                ),

                              ),)),
                        const SizedBox(height: 10,),
                        TextButton(
                            onPressed: (){
                              _validationCheckForApproval(type, id, status,position);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: btnColor,
                              ),
                              height: 40,
                              padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                              child:  Center(child: Text(btnText,style: const TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                            )
                        ),


                      ],
                    )
                ),
              ),);
          });
        });
  }
  _validationCheckForApproval(String type,String id,int status,int position){
    String statusStr="";
    String reasonStr=reasonController.text.toString();
    if(status==1){
      statusStr='Approve';
    }else{
      statusStr="Reject";
    }
    if(reasonStr.isNotEmpty){
      _focusNode.unfocus();
      Navigator.of(context).pop();
      _updateAttendanceStatusForApproval(type, id, status, position, reasonStr);


    }else{
      Toast.show("Please Enter a valid Reason for $statusStr",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  _updateAttendanceStatusForApproval(String type,String id,int status,int position,String reason) async{
    APIDialog.showAlertDialog(context, 'Please Wait...');
    String statusStr="";
    if(status==1){
      statusStr="approve";
    }else{
      statusStr="reject";
    }
    String approveFor="full_day";
    if(fromDropDownValue=='Full Day'){
      approveFor="full_day";
    }else if(fromDropDownValue=='First Half Day'){
      approveFor="first_half_present";
    }else if(fromDropDownValue=='Second Half Day'){
      approveFor="second_half_present";
    }


    List<dynamic> detailArray=[];
    var requestModelfrom;

    if(widget.attendaceType=="attendance_correction"){
      requestModelfrom = {
        "id": id,
        "approve_for":approveFor,
        "comment":reason,
      };
    }else{
      requestModelfrom = {
        "id": id,
        "approve_for":"",
        "comment":reason,
      };
    }

    detailArray.add(requestModelfrom);


    var requestModel = {
      "type": type,
      "is_approved":statusStr,
      "id":id,
      "comment":reason,
      "correction_data":jsonEncode(detailArray),
    };
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(baseUrl, 'attendance_management/approveRejectAttendance',requestModel,context, token);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      if(responseJSON['code']==200){
        getTaskBox();
      }
    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
}