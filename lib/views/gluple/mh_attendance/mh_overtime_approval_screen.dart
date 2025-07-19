import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import 'dart:io';

import '../network/api_helper.dart';
import '../utils/app_theme.dart';

class OverTimeApprovalScreen extends StatefulWidget{
  _overTimeApproval createState()=> _overTimeApproval();
}
class _overTimeApproval extends State<OverTimeApprovalScreen>{
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
        title:  const Text(
          "Over Time",
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
      body: ListView.builder(
          itemCount: approvalRequestList.length,
          physics: const ScrollPhysics(),
          itemBuilder: (BuildContext cntx,int indx){
            String empImage="";
            if(approvalRequestList[indx]['emp_img']!=null){
              empImage=baseUrl+'employee_profile_picture/'+approvalRequestList[indx]['emp_img'];
            }
            String empFullName="";
            if(approvalRequestList[indx]['emp_name']!=null){
              empFullName=approvalRequestList[indx]['emp_name'].toString();
            }
            String queryMsg="";
            if(approvalRequestList[indx]['query_type']!=null){
              queryMsg=approvalRequestList[indx]['query_type'].toString();
            }

            String attendanceId="0";
            if(approvalRequestList[indx]['attendance_id']!=null){
              attendanceId=approvalRequestList[indx]['attendance_id'].toString();
            }
            String overTimeHours="0";
            if(approvalRequestList[indx]['ot_hours']!=null){
              overTimeHours=approvalRequestList[indx]['ot_hours'].toString();
            }
            String overTimeId="0";
            if(approvalRequestList[indx]['otId']!=null){
              overTimeId=approvalRequestList[indx]['otId'].toString();
            }
            String userId="0";
            if(approvalRequestList[indx]['emp_user_id']!=null){
              userId=approvalRequestList[indx]['emp_user_id'].toString();
            }
            String generatedTime="";



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
                      children: [
                        Text("Over Time Hours:-",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
                        SizedBox(width: 5,),
                        Expanded(child: Text(overTimeHours,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: AppTheme.themeColor),),)
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            _showAttendanceBottomDialogForApprove( overTimeId, 1, "Over Time",indx);
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
                            _showAttendanceBottomDialogForApprove(overTimeId, 0, "Over Time",indx);
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
            );

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
        templist=responseJSON['data']['values']['over_time'];
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
    }

    setState(() {
      isLoading=false;
    });
  }
  _showAttendanceBottomDialogForApprove(String id,int status,String titles,int position){

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
                              _validationCheckForApproval(id, status,position);
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
  _validationCheckForApproval(String id,int status,int position){
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
      _updateAttendanceStatusForApproval(id, status, position, reasonStr);


    }else{
      Toast.show("Please Enter a valid Reason for $statusStr",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  _updateAttendanceStatusForApproval(String id,int status,int position,String reason) async{
    APIDialog.showAlertDialog(context, 'Please Wait...');
    String statusStr="";
    if(status==1){
      statusStr="approve";
    }else{
      statusStr="reject";
    }
    List<dynamic> detailArray=[];
    var requestModelfrom;

    requestModelfrom = {
      "id": id,
      "comment":reason,
    };

    detailArray.add(requestModelfrom);


    var requestModel = {
      "type": 'over_time',
      "is_approved":statusStr,
      "id":id,
      "comment":reason,
      "correction_data":jsonEncode(detailArray),
    };
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(baseUrl, 'common_api/otApproveReject',requestModel,context, token);
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