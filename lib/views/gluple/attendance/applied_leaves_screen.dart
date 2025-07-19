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

class AppliedLeavesScreen extends StatefulWidget{
  _appliedLeaved createState()=> _appliedLeaved();
}
class _appliedLeaved extends State<AppliedLeavesScreen>{
  bool isLoading=false;
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;
  List<dynamic> leavesList=[];

  var reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<dynamic>allList=[];
  var filterList=['All','Pending','Approved','Rejected','Canceled'];
  String filterDropDown = 'All';



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
          "Applied Leaves",
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
              child: Text("Show Leaves",
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
            leavesList.length==0?Align(alignment: Alignment.center,child: Text("No Leave Application Available",style: TextStyle(fontSize: 17.5,color: AppTheme.orangeColor,fontWeight: FontWeight.w900),),):
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: leavesList.length,
                itemBuilder: (BuildContext cntx, int index){
                  String dStr="";
                  String titleStr="";
                  String reasonStr="";

                  String statusStr="";
                  var backColor=AppTheme.task_Done_back;
                  var textColor= AppTheme.task_Done_text;

                  var isApproved=0;
                  var isCancel=0;
                  var isRejected=0;
                  bool showCancel=false;

                  String leaveId=leavesList[index]['id'].toString();



                  if(leavesList[index]['leave_date']!=null){
                    var deliveryTime=DateTime.parse(leavesList[index]['leave_date']);
                    var delLocal=deliveryTime.toLocal();
                    dStr=DateFormat('MMM d,yyyy').format(delLocal);
                  }
                  if(leavesList[index]['leave_status']!=null && leavesList[index]['leave_type']!=null){
                    titleStr=leavesList[index]['leave_status']+" | "+leavesList[index]['leave_type'];
                  }
                  if(leavesList[index]['reason']!=null){
                    reasonStr=leavesList[index]['reason'];
                  }

                  if(leavesList[index]['is_approve_status']!=null){
                    isApproved=leavesList[index]['is_approve_status'];
                  }
                  if(leavesList[index]['is_rejected_status']!=null){
                    isRejected=leavesList[index]['is_rejected_status'];
                  }
                  if(leavesList[index]['is_cancel']!=null){
                    isCancel=leavesList[index]['is_cancel'];
                  }

                  if(isApproved==1){
                    statusStr="Approved";
                    backColor=AppTheme.task_Done_back;
                    textColor=AppTheme.task_Done_text;

                  }else if(isRejected==1){
                    statusStr="Rejected";
                    backColor=AppTheme.task_Rejected_back;
                    textColor=AppTheme.task_Rejected_text;
                  }else if(isCancel==1){
                    statusStr="Canceled";
                    if(leavesList[index]['cancel_reason']!=null){
                      reasonStr=leavesList[index]['cancel_reason'];
                    }
                    backColor=AppTheme.task_CodeReview_back;
                    textColor=AppTheme.task_CodeReview_text;
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
                                    ],
                                  ),
                                  const SizedBox(height: 10,),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(child: Text(reasonStr,style: TextStyle(color: AppTheme.leave_type,fontSize: 12,fontWeight: FontWeight.w500),),),
                                      SizedBox(width: 5,),
                                      showCancel?
                                      InkWell(
                                        onTap: (){
                                          _showAttendanceBottomDialog(leaveId);
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 80,
                                          color: AppTheme.orangeColor,
                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.cancel_outlined,color: Colors.white,size: 20,),
                                              SizedBox(width: 5,),
                                              Expanded(child: Text("Cancel",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),)),
                                            ],
                                          ),
                                        ),
                                      ):SizedBox(),
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
        var isApproved=0;
        var isCancel=0;
        var isRejected=0;


        if(allList[i]['is_approve_status']!=null){
          isApproved=allList[i]['is_approve_status'];
        }
        if(allList[i]['is_rejected_status']!=null){
          isRejected=allList[i]['is_rejected_status'];
        }
        if(allList[i]['is_cancel']!=null){
          isCancel=allList[i]['is_cancel'];
        }
        if(isApproved!=1&&isRejected!=1&&isCancel!=1){
          leavesList.add(allList[i]);
        }
      }
    }
    else if(filterDropDown=="Approved"){
      for(int i=0;i<allList.length;i++){
        var isApproved=0;
        var isCancel=0;
        var isRejected=0;


        if(allList[i]['is_approve_status']!=null){
          isApproved=allList[i]['is_approve_status'];
        }
        if(allList[i]['is_rejected_status']!=null){
          isRejected=allList[i]['is_rejected_status'];
        }
        if(allList[i]['is_cancel']!=null){
          isCancel=allList[i]['is_cancel'];
        }
        if(isApproved==1){
          leavesList.add(allList[i]);
        }
      }
    }
    else if(filterDropDown=="Rejected"){
      for(int i=0;i<allList.length;i++){
        var isApproved=0;
        var isCancel=0;
        var isRejected=0;


        if(allList[i]['is_approve_status']!=null){
          isApproved=allList[i]['is_approve_status'];
        }
        if(allList[i]['is_rejected_status']!=null){
          isRejected=allList[i]['is_rejected_status'];
        }
        if(allList[i]['is_cancel']!=null){
          isCancel=allList[i]['is_cancel'];
        }
        if(isRejected==1){
          leavesList.add(allList[i]);
        }
      }
    }
    else if(filterDropDown=="Canceled"){
      for(int i=0;i<allList.length;i++){
        var isApproved=0;
        var isCancel=0;
        var isRejected=0;


        if(allList[i]['is_approve_status']!=null){
          isApproved=allList[i]['is_approve_status'];
        }
        if(allList[i]['is_rejected_status']!=null){
          isRejected=allList[i]['is_rejected_status'];
        }
        if(allList[i]['is_cancel']!=null){
          isCancel=allList[i]['is_cancel'];
        }
        if(isCancel==1){
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
    var response = await helper.getWithToken(baseUrl, 'attendance_management/getEmpAppliedApplication?type=leave&request_for=applied', token, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      allList.clear();
      leavesList.clear();
      List<dynamic> templist=[];
      templist=responseJSON['data'];
      /*if(templist.isNotEmpty){
        for(int i=templist.length-1;i>=0;i--){
          allList.add(templist[i]);
        }
      }*/
      allList.addAll(templist);
      leavesList.addAll(allList);
      filterDropDown = 'All';


      //leavesList=responseJSON['data'];
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

  _showAttendanceBottomDialog(String leaveId){
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        builder: (BuildContext contx){
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SizedBox(height: 20,),
                Align(alignment: Alignment.center, child: Container(height: 5,width: 30,color: AppTheme.greyColor,),),
                SizedBox(height: 10,),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(child: Text("Cancel Leave",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black,fontSize: 18.5),)),
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

                SizedBox(height: 20,),
                Text("Reason",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                SizedBox( height: 5,),
                Form(
                    key: _formKey,
                    child:  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: AppTheme.greyColor,width: 2.0),

                      ),
                      child: TextField(
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        controller: reasonController,
                        maxLength: 500,
                      ),

                    )),
                TextButton(
                    onPressed: (){

                      _submitCancelHandler(leaveId);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppTheme.orangeColor,
                      ),
                      height: 40,
                      padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                      child: const Center(child: Text("Submit",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                    )
                ),


              ],
            ),
          );
        });
  }

  _submitCancelHandler(String leaveId){
    if(reasonController.text.isEmpty){
      Toast.show("Please Enter Reason for Cancel",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else{
      Navigator.of(context).pop();
      _cancelAppliedLeave(leaveId,reasonController.text.toString());
    }
  }
  _cancelAppliedLeave(String leaveId,String reason)async{
    APIDialog.showAlertDialog(context, 'Please Wait...');
    var requestModel = {
      "id": leaveId,
      "is_approved":"cancel",
      "type":"undefined",
      "comment":reason,
    };
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(baseUrl, 'attendance_management/remove_applied_leave', requestModel, context,token);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {

      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      getLeaveList();

    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }



  }

}