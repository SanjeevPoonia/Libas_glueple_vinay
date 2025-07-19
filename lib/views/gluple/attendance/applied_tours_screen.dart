import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import 'package:intl/intl.dart';

class AppliedToursScreen extends StatefulWidget{
  _appliedTours createState()=>_appliedTours();
}
class _appliedTours extends State<AppliedToursScreen>{
  bool isLoading=false;
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;
  List<dynamic> leavesList=[];
  var filterList=['All','Pending','Approved','Rejected'];
  String filterDropDown = 'All';
  List<dynamic>allList=[];



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
          "Applied Tours",
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
            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Show Tours",
                style: TextStyle(fontSize: 14.5,
                    color: AppTheme.themeColor,
                    fontWeight: FontWeight.w500),),),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: double.infinity,
                height: 45,
                padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: AppTheme.greyColor,width: 2.0),

                ),
                child: DropdownButton(
                  items: filterList.map((String items) {return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );}).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      filterDropDown = newValue!;
                    });
                    _filterData();
                  },
                  value: filterDropDown,
                  icon: Icon(Icons.keyboard_arrow_down,color: AppTheme.themeColor,size: 15,),
                  isExpanded: true,
                  underline: SizedBox(),
                ),
              ),),
            SizedBox(height: 10,),
            leavesList.length==0?Align(alignment: Alignment.center,child: Text("No Tour Application Available",style: TextStyle(fontSize: 17.5,color: AppTheme.orangeColor,fontWeight: FontWeight.w900),),):
            ListView.builder(
                shrinkWrap: true,
                itemCount: leavesList.length,
                itemBuilder: (BuildContext cntx, int index){
                  String dStr="";
                  String titleStr="";
                  String reasonStr="";
                  String statusStr="";
                  String visitingDestination="";
                  var backColor=AppTheme.task_Done_back;
                  var textColor= AppTheme.task_Done_text;

                  String isApproved="0";
                  String isRejected="0";
                  bool showCancel=false;

                  String leaveId=leavesList[index]['id'].toString();



                  if(leavesList[index]['created_at']!=null){
                    var deliveryTime=DateTime.parse(leavesList[index]['created_at']);
                    var delLocal=deliveryTime.toLocal();
                    dStr=DateFormat('MMM d,yyyy').format(delLocal);
                  }
                  if(leavesList[index]['applied_from']!=null && leavesList[index]['applied_to']!=null&& leavesList[index]['no_of_days']!=null){
                    titleStr=leavesList[index]['applied_from']+" - "+leavesList[index]['applied_to']+" ("+leavesList[index]['no_of_days']+" days)";
                  }
                  if(leavesList[index]['reason']!=null){
                    reasonStr=leavesList[index]['reason'];
                  }
                  if(leavesList[index]['visiting_destination']!=null){
                    visitingDestination=leavesList[index]['visiting_destination'];
                  }

                  if(leavesList[index]['is_approve_status']!=null){
                    isApproved=leavesList[index]['is_approve_status'];
                  }
                  if(leavesList[index]['rejection_status']!=null){
                    isRejected=leavesList[index]['rejection_status'];
                  }

                  if(isApproved=="1"){
                    statusStr="Approved";
                    if(leavesList[index]['approval_comment']!=null){
                      reasonStr=leavesList[index]['approval_comment'];
                    }
                    backColor=AppTheme.task_Done_back;
                    textColor=AppTheme.task_Done_text;

                  }else if(isRejected=="1"){
                    statusStr="Rejected";
                    if(leavesList[index]['rejection_comment']!=null){
                      reasonStr=leavesList[index]['rejection_comment'];
                    }
                    backColor=AppTheme.task_Rejected_back;
                    textColor=AppTheme.task_Rejected_text;
                  }else{
                    statusStr="Pending";
                    backColor=AppTheme.task_progress_back;
                    textColor=AppTheme.task_progress_text;
                    showCancel=true;
                  }

                  return Stack(children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(

                        children: [
                          const SizedBox(height: 10,),
                          Container(

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
                                  const SizedBox(height: 5,),
                                  Text(titleStr,style: TextStyle(color: AppTheme.task_description,fontSize: 16,fontWeight: FontWeight.w500),),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      SvgPicture.asset('assets/at_calendar.svg',height: 21,width: 18,),
                                      SizedBox(width: 5,),
                                      Text(dStr,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
                                      Expanded(child: Text("Destination:- $visitingDestination",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppTheme.themeColor),)),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(child: Text(reasonStr,style: TextStyle(color: AppTheme.leave_type,fontSize: 12,fontWeight: FontWeight.w500),),),
                                      SizedBox(width: 5,),
                                    ],
                                  ),

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
                          child: Text(statusStr,
                              style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ),

                      ),),
                  ],);

                }
            ),
          ],
        ),
      )

    );
  }
  _filterData(){
    APIDialog.showAlertDialog(context, "Please Wait....");
    leavesList.clear();
    if(filterDropDown=="All"){
      leavesList.addAll(allList);
    }
    else if(filterDropDown=="Pending"){
      for(int i=0;i<allList.length;i++){
        String isApproved="0";
        String isRejected="0";
        if(allList[i]['is_approve_status']!=null){
          isApproved=allList[i]['is_approve_status'];
        }
        if(allList[i]['rejection_status']!=null){
          isRejected=allList[i]['rejection_status'];
        }
        if(isApproved!="1"&&isRejected!="1"){
          leavesList.add(allList[i]);
        }
      }
    }
    else if(filterDropDown=="Approved"){
      for(int i=0;i<allList.length;i++){
        String isApproved="0";
        String isRejected="0";
        if(allList[i]['is_approve_status']!=null){
          isApproved=allList[i]['is_approve_status'];
        }
        if(allList[i]['rejection_status']!=null){
          isRejected=allList[i]['rejection_status'];
        }
        if(isApproved=="1"){
          leavesList.add(allList[i]);
        }
      }
    }
    else if(filterDropDown=="Rejected"){
      for(int i=0;i<allList.length;i++){
        String isApproved="0";
        String isRejected="0";
        if(allList[i]['is_approve_status']!=null){
          isApproved=allList[i]['is_approve_status'];
        }
        if(allList[i]['rejection_status']!=null){
          isRejected=allList[i]['rejection_status'];
        }
        if(isRejected=="1"){
          leavesList.add(allList[i]);
        }
      }
    }
    Navigator.of(context).pop();
    setState(() {

    });

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
    var response = await helper.getWithToken(baseUrl, 'attendance_management/getEmpAppliedApplication?type=tour&request_for=applied', token, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      allList.clear();
      leavesList.clear();
      List<dynamic> templist=[];
      templist=responseJSON['data'];
      if(templist.isNotEmpty){
        for(int i=templist.length-1;i>=0;i--){
          allList.add(templist[i]);
        }
      }
      leavesList.addAll(allList);
      filterDropDown = 'All';
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