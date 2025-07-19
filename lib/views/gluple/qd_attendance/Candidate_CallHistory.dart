import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import 'dart:io';

import '../views/login_screen.dart';
import 'package:intl/intl.dart';
import 'package:ChecklistTree/views/login_screen.dart';

class CandidateCallHistory extends StatefulWidget{
  String candidateId;
  CandidateCallHistory(this.candidateId);
  _callHistory createState()=>_callHistory();
}
class _callHistory extends State<CandidateCallHistory>{
  bool isLoading=false;
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;
  late var platform;
  List<dynamic> historyList=[];


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
            "Call History",
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
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              isLoading?const Center(child: SizedBox(height: 2,),):
              historyList.isEmpty?
              const Align(alignment: Alignment.center,child: Text("Call History Not Available",style: TextStyle(fontSize: 17.5,color: AppTheme.orangeColor,fontWeight: FontWeight.w900),),):
              ListView.builder(
                  itemCount: historyList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (contx,indx){
                    print("Candidate Name: ${historyList[indx]['name']}");
                    String id="";
                    if(historyList[indx]['id']!=null){
                      id=historyList[indx]['id'].toString();
                    }
                    String trans_id="";
                    if(historyList[indx]['trans_id']!=null){
                      trans_id=historyList[indx]['trans_id'].toString();
                    }
                    String msg_type="";
                    if(historyList[indx]['msg_type']!=null){
                      msg_type=historyList[indx]['msg_type'].toString();
                    }
                    String sb_tag="";
                    if(historyList[indx]['sb_tag']!=null){
                      sb_tag=historyList[indx]['sb_tag'].toString();
                    }
                    String cli="";
                    if(historyList[indx]['cli']!=null){
                      cli=historyList[indx]['cli'].toString();
                    }
                    String svr="";
                    if(historyList[indx]['svr']!=null){
                      svr=historyList[indx]['svr'].toString();
                    }
                    String dest_count="";
                    if(historyList[indx]['dest_count']!=null){
                      dest_count=historyList[indx]['dest_count'].toString();
                    }
                    String digits_1="";
                    if(historyList[indx]['digits_1']!=null){
                      digits_1=historyList[indx]['digits_1'].toString();
                    }
                    String name_1="";
                    if(historyList[indx]['name_1']!=null){
                      name_1=historyList[indx]['name_1'].toString();
                    }
                    String digits_2="";
                    if(historyList[indx]['digits_2']!=null){
                      digits_2=historyList[indx]['digits_2'].toString();
                    }
                    String name_2="";
                    if(historyList[indx]['name_2']!=null){
                      name_2=historyList[indx]['name_2'].toString();
                    }
                    String json_data_result="";
                    if(historyList[indx]['json_data_result']!=null){
                      json_data_result=historyList[indx]['json_data_result'].toString();
                    }
                    String json_data_cdr="";
                    if(historyList[indx]['json_data_cdr']!=null){
                      json_data_cdr=historyList[indx]['json_data_cdr'].toString();
                    }
                    String access_number="";
                    if(historyList[indx]['access_number']!=null){
                      access_number=historyList[indx]['access_number'].toString();
                    }
                    String access_number_id="";
                    if(historyList[indx]['access_number_id']!=null){
                      access_number_id=historyList[indx]['access_number_id'].toString();
                    }
                    String agent_id="";
                    if(historyList[indx]['agent_id']!=null){
                      agent_id=historyList[indx]['agent_id'].toString();
                    }
                    String candidate_id="";
                    if(historyList[indx]['candidate_id']!=null){
                      candidate_id=historyList[indx]['candidate_id'].toString();
                    }
                    String created_at="";
                    String dateToShow="";
                    String showRecording="0";
                    String fileUrl="";
                    String callType="INITIATED";
                    String callDuration="0";

                    if(json_data_cdr.isNotEmpty){
                      final data=json.decode(json_data_cdr);
                      callType=data['direction'].toString();
                      callDuration=data['duration'].toString();
                      if(data['recording_url']!=null){
                        showRecording="1";
                        fileUrl=data['recording_url'].toString();
                      }
                    }



                    if(historyList[indx]['created_at']!=null){
                      created_at=historyList[indx]['created_at'].toString();
                      var deliveryTime=DateTime.parse(created_at);
                      var delLocal=deliveryTime.toLocal();
                      dateToShow=DateFormat('E, dd MMM yyyy hh:mm a').format(delLocal);
                    }




                    return Padding(padding: EdgeInsets.all(5),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.otpColor
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                                  color: AppTheme.orangeColor
                              ),
                              child: Text("$name_1($id)",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.white,fontSize: 14),),
                            ),
                            SizedBox(height: 10,),
                            Padding(padding: EdgeInsets.only(left: 10,right: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    children: [
                                      Text("Access No : ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                                      SizedBox(width: 5,),
                                      Expanded(child: Text(access_number,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.black),),),
                                    ],
                                  ),


                                  SizedBox(height: 10,),

                                  Row(
                                    children: [
                                      Expanded(child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Call From",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                                          SizedBox(height: 3,),
                                          Text(cli,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700,color: Colors.black),),
                                        ],
                                      )),
                                      SizedBox(width: 5,),
                                      Expanded(child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,

                                        children: [
                                          Text("Call To",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                                          SizedBox(height: 3,),
                                          Text(digits_1,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700,color: Colors.black),),
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
                                          Text("Call Type",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                                          SizedBox(height: 3,),
                                          Text(callType,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700,color: Colors.black),),
                                        ],
                                      )),
                                      SizedBox(width: 5,),
                                      Expanded(child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,

                                        children: [
                                          Text("Call Duration",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                                          SizedBox(height: 3,),
                                          Text(callDuration,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700,color: Colors.black),),
                                        ],
                                      )),
                                    ],
                                  ),
                                  SizedBox(height: 10,),

                                  Row(
                                    children: [
                                      Text("Date",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                                      SizedBox(width: 5,),
                                      Expanded(child: Text(dateToShow,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700,color: Colors.black),),),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      /*InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => CandidateFeedback(name_1,widget.candidateId,cli,digits_1,access_number,dateToShow)),);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(5),
                                              color: AppTheme.at_details_date_back
                                          ),
                                          child: Center(child: Text("Add Feedback",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12,color: Colors.white),),),
                                        ),
                                      ),*/
                                      SizedBox(width: 5,),
                                      InkWell(
                                        onTap: (){

                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(5),
                                              color: AppTheme.at_purple
                                          ),
                                          child: Center(child: Text("Play Recording",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12,color: Colors.white),),),
                                        ),
                                      ),

                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),),






                          ],
                        ),
                      ),);
                  }
              ),
            ],
          ),
        )

    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _getUserData();
    });
  }
  _getUserData() async {


    APIDialog.showAlertDialog(context, 'Please Wait...');
    userIdStr=await MyUtils.getSharedPreferences("user_id")??"";
    fullNameStr=await MyUtils.getSharedPreferences("full_name")??"";
    token=await MyUtils.getSharedPreferences("token")??"";
    designationStr=await MyUtils.getSharedPreferences("designation")??"";
    empId=await MyUtils.getSharedPreferences("emp_id")??"";
    baseUrl=await MyUtils.getSharedPreferences("base_url")??"";



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
    setState(() {

    });
    Navigator.of(context).pop();


    getHistoryList();



  }
  getHistoryList() async {
    FocusScope.of(context).unfocus();
    isLoading=true;
    setState(() {

    });

    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper = ApiBaseHelper();
    String b4Url="https://glueple.com:3001/ats/";
    var response = await helper.getWithBase(b4Url, 'get-call-history-by-candidate?candidate_id=${widget.candidateId}',context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      historyList.clear();
      historyList=responseJSON['data'];
    }
    else if(responseJSON['code']==401 || responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

      _logOut(context);
    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    isLoading=false;
    setState(() {

    });
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