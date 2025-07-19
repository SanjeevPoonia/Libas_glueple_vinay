import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ChecklistTree/views/gluple/utils/app_theme.dart';
import 'package:ChecklistTree/views/gluple/views/RequestSeparationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../network/Utils.dart';
import '../network/api_dialog.dart';
import 'dart:io';

import '../network/api_helper.dart';
import '../../login_screen.dart';

class SaparationScreen extends StatefulWidget{
  _saparationState createState()=>_saparationState();
}
class _saparationState extends State<SaparationScreen>{
  bool isLoading=false;
  var userIdStr="";
  var designationStr="";
  var token="";
  var fullNameStr="";
  var empId="";
  var baseUrl="";
  var clientCode="";
  var platform="";
  List<dynamic> saparationList=[];
  @override
  Widget build(BuildContext context) {
   ToastContext().init(context);
   return Stack(
     children: [

       isLoading?const SizedBox():saparationList.isEmpty?const Center(
         child: Text("No Separation Request Found!",textAlign: TextAlign.center,style: TextStyle(
           fontWeight: FontWeight.w500,
           fontSize: 18.5,
           color: AppTheme.orangeColor
         ),),
       ):
       ListView.builder(
           itemCount: saparationList.length,
           itemBuilder: (BuildContext cntx,int indx){
             String empId="";
             String actualRelievingDate="";
             String requestedRelievingDate="";
             String approvedRelievingDate="";
             String status="";
             String approvalStatus="";
             String reason="";
             String saperationType="";

             if(saparationList[indx]['emp_id']!=null){
               empId=saparationList[indx]['emp_id'].toString();
             }
             if(saparationList[indx]['actual_relieving_date']!=null){
               actualRelievingDate=saparationList[indx]['actual_relieving_date'].toString();
             }
             if(saparationList[indx]['request_relieving_date']!=null){
               requestedRelievingDate=saparationList[indx]['request_relieving_date'].toString();
             }
             if(saparationList[indx]['releaving_date']!=null){
               approvedRelievingDate=saparationList[indx]['releaving_date'].toString();
             }
             if(saparationList[indx]['status']!=null){
               status=saparationList[indx]['status'].toString();
             }
             if(saparationList[indx]['is_approved_by_manager']!=null){
               if(saparationList[indx]['is_approved_by_manager']==1){
                 approvalStatus="Approved";
               }else if(saparationList[indx]['is_reject_by_manager']==1){
                 approvalStatus="Rejected";
               }else{
                 approvalStatus="Pending";
               }

             }
             if(saparationList[indx]['resignation_reason']!=null){
               reason=saparationList[indx]['resignation_reason'].toString();
             }
             if(saparationList[indx]['separation_type']!=null){
               saperationType=saparationList[indx]['separation_type'].toString();
             }

             return Stack(
               children: [
                 Padding(padding: const EdgeInsets.only(top: 15),
                   child: Column(

                     children: [
                       Container(
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(4),
                             color: Colors.white,
                             border: Border.all(color: AppTheme.orangeColor,width: 1.0)
                         ),
                         child: Padding(
                           padding: EdgeInsets.only(left: 7,right: 10,bottom: 10),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               const SizedBox(height: 5,),
                               Text(saperationType,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),),
                               const SizedBox(height: 10,),
                               Row(
                                 children: [
                                   Expanded(child: Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text("Actual Relieving Date",style: TextStyle(color: AppTheme.themeColor,fontSize: 12,fontWeight: FontWeight.w500),),
                                       SizedBox(height: 5,),
                                       Row(
                                         children: [
                                           SvgPicture.asset('assets/at_calendar.svg',height: 21,width: 18,),
                                           SizedBox(width: 5,),
                                           Text(actualRelievingDate,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                                         ],
                                       )
                                     ],
                                   ),),
                                   SizedBox(width: 5,),
                                   Expanded(child: Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text("Request Relieving Date",style: TextStyle(color: AppTheme.themeColor,fontSize: 12,fontWeight: FontWeight.w500),),
                                       SizedBox(height: 5,),
                                       Row(
                                         children: [
                                           SvgPicture.asset('assets/at_calendar.svg',height: 21,width: 18,),
                                           SizedBox(width: 5,),
                                           Text(requestedRelievingDate,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                                         ],
                                       )
                                     ],
                                   ))
                                 ],
                               ),
                               const SizedBox(height: 10,),
                               approvedRelievingDate.isEmpty?SizedBox():Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text("Approved Relieving Date",style: TextStyle(color: AppTheme.themeColor,fontSize: 12,fontWeight: FontWeight.w500),),
                                   SizedBox(height: 5,),
                                   Row(
                                     children: [
                                       SvgPicture.asset('assets/at_calendar.svg',height: 21,width: 18,),
                                       SizedBox(width: 5,),
                                       Text(requestedRelievingDate,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                                     ],
                                   ),
                                   const SizedBox(height: 10,),
                                 ],
                               ),
                               const Text("Reason",style: TextStyle(
                                   color: AppTheme.themeColor,
                                   fontSize: 12,
                                   fontWeight: FontWeight.w500
                               ),),
                               Text(reason,style: TextStyle(color: AppTheme.orangeColor,fontSize: 12,fontWeight: FontWeight.w500),),
                               const SizedBox(height: 10,),

                               const Text("Status",style: TextStyle(
                                   color: AppTheme.themeColor,
                                   fontSize: 12,
                                   fontWeight: FontWeight.w500
                               ),),
                               Text(status,style: TextStyle(color: AppTheme.orangeColor,fontSize: 12,fontWeight: FontWeight.w500),),


                             ],
                           ),
                         ),
                         margin: EdgeInsets.all(10),

                       ),
                       const SizedBox(height: 25,),
                     ],

                   ) ,),
                 Positioned(
                   right: 10,
                   top:10,
                   child:  Container(
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(1),
                         color: AppTheme.task_progress_back),
                     width: 80,
                     height: 30,
                     child: Align(
                       alignment: Alignment.center,
                       child: Text(approvalStatus,
                           style: const TextStyle(
                               color: Colors.black,
                               fontWeight: FontWeight.w900,
                               fontSize: 12)),
                     ),

                   ),),
               ],
             );




           }),
       Positioned(bottom: 10,right: 10,child: InkWell(
         onTap: (){
           Navigator.push(context, MaterialPageRoute(builder: (context) => RequestSeparationScreen()),).then((value) => getSaparationList());
         },
         child: Container(
           height: 40,
           width: 150,
           decoration: const BoxDecoration(
               shape: BoxShape.rectangle,
               borderRadius: BorderRadius.all(Radius.circular(10)),
               color: AppTheme.orangeColor
           ),
           child: const Center(child: Text("Request Separation",textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 14),),),
         ),
       ),)
     ],
   );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _getProfile();
    });


  }
  _getProfile() async {
    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    userIdStr=await MyUtils.getSharedPreferences("user_id")??"";
    fullNameStr=await MyUtils.getSharedPreferences("full_name")??"";
    token=await MyUtils.getSharedPreferences("token")??"";
    designationStr=await MyUtils.getSharedPreferences("designation")??"";
    empId=await MyUtils.getSharedPreferences("emp_id")??"";
    baseUrl=await MyUtils.getSharedPreferences("base_url")??"";
    clientCode=await MyUtils.getSharedPreferences("client_code")??"";
    if(Platform.isAndroid){
      platform="Android";
    }else if(Platform.isIOS){
      platform="iOS";
    }else{
      platform="Other";
    }
    Navigator.of(context).pop();

    getSaparationList();

  }
  getSaparationList() async {

    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl, 'employee_separation/getAppliedEmpSaperationReq', token, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      saparationList.clear();
      saparationList=responseJSON['data'];
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

}