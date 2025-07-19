import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ChecklistTree/views/gluple/mh_attendance/mh_overtime_approval_screen.dart';
import 'package:ChecklistTree/views/gluple/qd_attendance/QD_Requested_Correction_Screen.dart';
import 'package:ChecklistTree/views/gluple/views/AttendanceApprovalScreen.dart';
import 'package:ChecklistTree/views/gluple/views/SeparationApprovalScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import '../../login_screen.dart';
import 'dart:io';

class TaskBoxScreen extends StatefulWidget{
  _taskboxScreen createState()=> _taskboxScreen();
}
class _taskboxScreen extends State<TaskBoxScreen>{

  String leaveCount="0";
  String tourCount="0";
  String cOffCount="0";
  String correctionCount="0";
  String webCount="0";
  String otCount="0";

  String leaveType="";
  String tourType="";
  String compOffType="";
  String correctionType="";
  String webType="";
  String otType="";

  String separationCount="0";


  bool isLoading=false;
  late var userIdStr;
  late var fullNameStr;
  late var firstNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;
  late var platform;

  var clientCode="";

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Text("Attendance Requests",style: TextStyle(fontWeight: FontWeight.w900,color: AppTheme.themeColor,fontSize: 16),),
                  SizedBox(height: 10,),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [

                        Expanded(child: InkWell(
                          onTap: (){
                            navigateScreen(leaveType);
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/at_details_leave.svg',height: 50,width: 50,),
                                    SizedBox(width: 10,),
                                    Text(leaveCount,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppTheme.orangeColor),)
                                  ],
                                ),

                                SizedBox(height: 5,),
                                Text("Leaves",style: TextStyle(color: Colors.black,fontSize: 16.5,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                        )),
                        SizedBox(width: 10,),

                        Expanded(child: InkWell(
                          onTap: (){
                            navigateScreen(correctionType);
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/at_details_correction.svg',height: 50,width: 50,),
                                    SizedBox(width: 10,),
                                    Text(correctionCount,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppTheme.orangeColor),)
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Text("Corrections",style: TextStyle(color: Colors.black,fontSize: 16.5,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),),

                  clientCode=="MH100"?
                      SizedBox(height: 1,):
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [

                            Expanded(child: InkWell(
                              onTap: (){
                                navigateScreen(tourType);
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/at_details_tour.svg',height: 50,width: 50,),
                                        SizedBox(width: 10,),
                                        Text(tourCount,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppTheme.orangeColor),)
                                      ],
                                    ),

                                    SizedBox(height: 5,),
                                    Text("Tours",style: TextStyle(color: Colors.black,fontSize: 16.5,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),
                            )),
                            SizedBox(width: 10,),
                            Expanded(child: InkWell(
                              onTap: (){
                                navigateScreen(compOffType);
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/at_details_coff.svg',height: 50,width: 50,),
                                        SizedBox(width: 10,),
                                        Text(cOffCount,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppTheme.orangeColor),)
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Text("Comp-Off",style: TextStyle(color: Colors.black,fontSize: 16.5,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),),
                    ],
                  ),

                  SizedBox(height: 10,),


                  clientCode=="MH100"?
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(child: InkWell(
                            onTap: (){
                              navigateScreen(otType);
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/at_details_coff.svg',height: 50,width: 50,),
                                      SizedBox(width: 10,),
                                      Text(otCount,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppTheme.orangeColor),)
                                    ],
                                  ),

                                  SizedBox(height: 5,),
                                  Text("Over Time",style: TextStyle(color: Colors.black,fontSize: 16.5,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          )),
                          SizedBox(width: 10,),
                          Expanded(child: InkWell(
                            onTap: (){
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyCOffScreen()),);
                            },
                            child: Container(
                              height: 125,
                            ),
                          ))
                        ],
                      ),):
                      SizedBox(height: 1,),


                  /*Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [

                        Expanded(child: InkWell(
                          onTap: (){
                            navigateScreen(webType);
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/tbox_web_icon.svg',height: 50,width: 50,),
                                    SizedBox(width: 10,),
                                    Text(webCount,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppTheme.orangeColor),)
                                  ],
                                ),

                                SizedBox(height: 5,),
                                Text("Web Attendance",style: TextStyle(color: Colors.black,fontSize: 16.5,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                        )),
                        SizedBox(width: 10,),
                        Expanded(child: InkWell(
                          onTap: (){
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyCOffScreen()),);
                          },
                          child: Container(
                            height: 125,
                          ),
                        )),

                      ],
                    ),),*/
                  SizedBox(height: 10,),
                ],
              ),
            ),),
          SizedBox(height: 10,),

          Padding(padding: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Text("Separation Requests",style: TextStyle(fontWeight: FontWeight.w900,color: AppTheme.themeColor,fontSize: 16),),
                  SizedBox(height: 10,),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(child: InkWell(
                          onTap: (){
                            _navigateSeparationApproval();
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/separation.svg',height: 50,width: 50,),
                                    SizedBox(width: 10,),
                                    Text(separationCount,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppTheme.orangeColor),)
                                  ],
                                ),

                                SizedBox(height: 5,),
                                Text("Separation",style: TextStyle(color: Colors.black,fontSize: 16.5,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),),
                  SizedBox(height: 10,),
                ],
              ),
            ),),

        ],
      ),
    );

  }
  _showAlertDialog(){
    showDialog(context: context, builder: (ctx)=> AlertDialog(
      title: const Text("Logout",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 18),),
      content: const Text("Are you sure you want to Logout ?",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16,color: Colors.black),),
      actions: <Widget>[
        TextButton(
            onPressed: (){
              Navigator.of(ctx).pop();
              _logOut(context);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.themeColor,
              ),
              height: 45,
              padding: const EdgeInsets.all(10),
              child: const Center(child: Text("Logout",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
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
      ],
    ));
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
    firstNameStr=await MyUtils.getSharedPreferences("first_name");
    token=await MyUtils.getSharedPreferences("token");
    designationStr=await MyUtils.getSharedPreferences("designation");
    empId=await MyUtils.getSharedPreferences("emp_id");
    baseUrl=await MyUtils.getSharedPreferences("base_url");
    clientCode=await MyUtils.getSharedPreferences("client_code")??"";
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
      List<dynamic> tabsList=[];
      if(responseJSON['data']['tabs']!=null){
        tabsList=responseJSON['data']['tabs'];
        if(tabsList.isEmpty){
          tourCount="0";
          leaveCount="0";
          correctionCount="0";
          cOffCount="0";
          webCount="0";
          otCount="0";
          separationCount="0";

        }else{
          for(int i=0;i<tabsList.length;i++){
            if(tabsList[i]['object_key']!=null){
              String object=tabsList[i]['object_key'];
              if(object=='attendance'){
                if(tabsList[i]['is_sub_categories']!=null){
                  int isSub=tabsList[i]['is_sub_categories'];
                  if(isSub==1){
                    if(tabsList[i]['sub_categories']!=null){
                      List<dynamic>subList=[];
                      subList=tabsList[i]['sub_categories'];
                      if(subList.isEmpty){
                        tourCount="0";
                        leaveCount="0";
                        correctionCount="0";
                        cOffCount="0";
                        webCount="0";
                        otCount="0";
                      }else{
                        tourCount="0";
                        leaveCount="0";
                        correctionCount="0";
                        cOffCount="0";
                        webCount="0";

                        for(int j=0;j<subList.length;j++){
                          if(subList[j]['query_type']!=null){
                            String qType=subList[j]['query_type'].toString();
                            if(qType=='tour'){
                              tourType=qType;
                              if(subList[j]['len']!=null){
                                tourCount=subList[j]['len'].toString();
                              }else{
                                tourCount="0";
                              }
                            }
                            if(qType=='leaves'){
                              leaveType=qType;
                              if(subList[j]['len']!=null){
                                leaveCount=subList[j]['len'].toString();
                              }else{
                                leaveCount="0";
                              }
                            }

                            if(qType=='attendance_correction'){
                              correctionType=qType;
                              if(subList[j]['len']!=null){
                                correctionCount=subList[j]['len'].toString();
                              }else{
                                correctionCount="0";
                              }
                            }
                            if(qType=='comp_off'){
                              compOffType=qType;
                              if(subList[j]['len']!=null){
                                cOffCount=subList[j]['len'].toString();
                              }else{
                                cOffCount="0";
                              }
                            }
                            if(qType=='web_attendance'){
                              webType=qType;
                              if(subList[j]['len']!=null){
                                webCount=subList[j]['len'].toString();
                              }else{
                                webCount="0";
                              }
                            }

                          }
                        }
                      }

                    }
                  }
                }
              }
              if(object=='separation_approval'){
                if(tabsList[i]['total_length']!=null){
                  separationCount=tabsList[i]['total_length'].toString();
                }else{
                  separationCount="0";
                }
              }
              if(object=="over_time"){
                otType=object;
                if(tabsList[i]['total_length']!=null){
                  otCount=tabsList[i]['total_length'].toString();
                }else{
                  otCount="0";
                }
              }
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
  navigateScreen(String type){
    if(type==correctionType){
      if(correctionCount!='0'){
        if(clientCode=='QD100'){
          Navigator.push(context, MaterialPageRoute(builder: (context) => QDReuestedCorrectionScreen()),).then((value) => getTaskBox());
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => AttendaceApprovalScreen("attendance_correction", "Correction Requests")),).then((value) => getTaskBox());
        }

      }else{
        Toast.show("You don't have any Correction Request Pending!!!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    }else if(type==webType){

      if(webCount!='0'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AttendaceApprovalScreen("web_checkin_without_camera", "Web Attendance")),).then((value) => getTaskBox());
      }else{
        Toast.show("You don't have any Web Attendance Request Pending!!!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    }else if(type==leaveType){

      if(leaveCount!='0'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AttendaceApprovalScreen("leave", "Leaves")),).then((value) => getTaskBox());
      }else{
        Toast.show("You don't have any Leave Request Pending!!!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    }else if(type==compOffType){

      if(cOffCount!='0'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AttendaceApprovalScreen("comp_off", "Comp-Off")),).then((value) => getTaskBox());
      }else{
        Toast.show("You don't have any Comp-Off Request Pending!!!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    }else if(type==tourType){

      if(tourCount!='0'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AttendaceApprovalScreen("tour", "Tours")),).then((value) => getTaskBox());
      }else{
        Toast.show("You don't have any Tour Request Pending!!!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    }else if(type==otType){

      if(otCount!='0'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => OverTimeApprovalScreen()),).then((value) => getTaskBox());
      }else{
        Toast.show("You don't have any Over Time Request Pending!!!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    }
  }
  _navigateSeparationApproval(){
    if(separationCount!='0'){
      Navigator.push(context, MaterialPageRoute(builder: (context) => SeparationApprovalScreen()),).then((value) => getTaskBox());
    }else{
      Toast.show("You don't have any Separation Request Pending!!!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

}