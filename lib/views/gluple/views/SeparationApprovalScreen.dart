import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import 'dart:io';

import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import 'package:intl/intl.dart';

class SeparationApprovalScreen extends StatefulWidget{
  _separationState createState()=>_separationState();
}
class _separationState extends State<SeparationApprovalScreen>{
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
          "Separation Request",
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
      body: isLoading?Center():ListView.builder(
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
            if(approvalRequestList[indx]['seperation_applied_at']!=null){
              DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(approvalRequestList[indx]['seperation_applied_at'].toString());
              var inputDate = DateTime.parse(parseDate.toString());
              var outputFormat = DateFormat('dd MMM,yyyy hh:mm a');
              var outputDate = outputFormat.format(inputDate);
              generatedTime=outputDate;
            }
            String actualRelievingDate="";
            String requestedRelievingDate="";
            if(approvalRequestList[indx]['actual_relieving_date']!=null){
              actualRelievingDate=approvalRequestList[indx]['actual_relieving_date'].toString();
            }
            if(approvalRequestList[indx]['request_relieving_date']!=null){
              actualRelievingDate=approvalRequestList[indx]['request_relieving_date'].toString();
            }
            String noticePeriod="";
            if(approvalRequestList[indx]['notice_period']!=null){
              noticePeriod=approvalRequestList[indx]['notice_period'].toString();
            }
            String resignationReason="";
            if(approvalRequestList[indx]['resignation_reason']!=null){
              resignationReason=approvalRequestList[indx]['resignation_reason'].toString();
            }
            String separationType="";
            if(approvalRequestList[indx]['separation_type']!=null){
              separationType=approvalRequestList[indx]['separation_type'].toString();
            }

            return Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
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
                                "View",
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
            );


          }
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
        templist=responseJSON['data']['values']['separation_approval'];
        for(int i=0;i<templist.length;i++){
          approvalRequestList.add(templist[i]);
        }

      }
    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _finishScreen();
    }

    setState(() {
      isLoading=false;
    });
  }

  _finishScreen(){
    Navigator.of(context).pop();
  }
}