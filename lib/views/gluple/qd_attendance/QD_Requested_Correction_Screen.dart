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

class QDReuestedCorrectionScreen extends StatefulWidget{
  _qdRequestedCorrection createState()=>_qdRequestedCorrection();
}
class _qdRequestedCorrection extends State<QDReuestedCorrectionScreen>{
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

  int lastMonthLength=0;
  String HODName="";
  int ShowCorrectionCount=0;

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
        title:  const Text(
          'Correction Requests',
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
            String id=approvalRequestList[indx]['id'].toString();
            String empId=approvalRequestList[indx]['emp_id'].toString();
            String empName=approvalRequestList[indx]['employee_name'].toString();
            String date=approvalRequestList[indx]['date'].toString();
            String actual_check_in_time="N/A";
            if(approvalRequestList[indx]['actual_check_in_time']!=null && approvalRequestList[indx]['actual_check_in_time'].toString()!='Invalid date'){
              actual_check_in_time=approvalRequestList[indx]['actual_check_in_time'].toString();
            }
            String actual_check_out_time="N/A";
            if(approvalRequestList[indx]['actual_check_out_time']!=null && approvalRequestList[indx]['actual_check_out_time'].toString()!='Invalid date'){
              actual_check_out_time=approvalRequestList[indx]['actual_check_out_time'].toString();
            }
            String corrected_check_in_time=approvalRequestList[indx]['corrected_check_in_time'].toString();
            String corrected_check_out_time=approvalRequestList[indx]['corrected_check_out_time'].toString();

            int is_approved=approvalRequestList[indx]['is_approved'];
            int is_rejected=approvalRequestList[indx]['is_rejected'];

            String requested_check_in_reason=approvalRequestList[indx]['requested_check_in_reason'].toString();
            String requested_check_out_reason=approvalRequestList[indx]['requested_check_out_reason'].toString();

            String generatedTime="";
            if(approvalRequestList[indx]['correction_request_raised_at']!=null){
              DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(approvalRequestList[indx]['correction_request_raised_at'].toString());
              var inputDate = DateTime.parse(parseDate.toString());
              var outputFormat = DateFormat('dd MMM,yyyy hh:mm a');
              var outputDate = outputFormat.format(inputDate);
              generatedTime=outputDate;
            }

            String titleStr='Kindly approve attendance correction of $empName($empId) for $date';


            bool showButtons=false;

            if(is_approved==0 && is_rejected==0){
              showButtons=true;
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
                    Text(titleStr,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900,color: Colors.black),),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(flex: 1,child: Text(empName,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppTheme.themeColor),),),
                        const SizedBox(width: 10,),
                        Text(generatedTime,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: AppTheme.themeColor),),
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
                            Text(actual_check_in_time,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: AppTheme.orangeColor),),
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
                            Text(actual_check_out_time,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: AppTheme.orangeColor),),
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
                            Text(corrected_check_in_time,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: Colors.black),),
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
                            Text(corrected_check_out_time,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: Colors.black),),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                        )
                        ),

                      ],
                    ),

                    SizedBox(height: 10,),
                    Text("Check In Reason",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
                    Padding(padding: EdgeInsets.only(left: 10),
                      child: Text(requested_check_in_reason,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14,color: AppTheme.orangeColor),),),
                    SizedBox(height: 10,),
                    Text("Check Out Reason",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
                    Padding(padding: EdgeInsets.only(left: 10),
                      child: Text(requested_check_out_reason,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14,color: AppTheme.orangeColor),),),

                    SizedBox(height: 10,),

                    showButtons?
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            getCorrectionCount(date,'attendance_correction', id, 1, "Correction",indx,empId);
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
                            getCorrectionCount(date,'attendance_correction', id, 0, "Correction",indx,empId);
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
                    ):
                        is_approved==1?
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
                                    "Approved",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14,fontWeight: FontWeight.w900,color: Colors.white),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ):
                            is_rejected==1?
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
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(Radius.circular(7)),
                                    ),
                                    child: Center(
                                      child: const Text(
                                        "Rejected",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14,fontWeight: FontWeight.w900,color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ):
                    SizedBox(height: 2,),

                    SizedBox(height: 10,)
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
    var response = await helper.getWithToken(baseUrl, 'attendance_management/getEmpAppliedApplication?type=attendance_correction&request_for=approval&status=all', token, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      approvalRequestList.clear();
      List<dynamic> tempList=responseJSON['data'];
      List<dynamic> pendingList=[];
      List<dynamic> otherList=[];
      for(int i=0;i<tempList.length;i++){
        int is_approved=tempList[i]['is_approved'];
        int is_rejected=tempList[i]['is_rejected'];
        if(is_approved==0 && is_rejected==0){
          pendingList.add(tempList[i]);
        }else{
          otherList.add(tempList[i]);
        }
      }

      approvalRequestList.addAll(pendingList);
      approvalRequestList.addAll(otherList);




     // approvalRequestList=responseJSON['data'];
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

  _showAttendanceBottomDialog(String type,String id,int status,String titles,int position){

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
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: AppTheme.otpColor,width: 2.0),
                            color: AppTheme.themeColor

                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child:
                            Text("Correction Count : $ShowCorrectionCount",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white,fontSize: 17.5,
                                  fontWeight: FontWeight.bold),)),
                          ],
                        ),
                      ),
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
                            _validationCheck(type, id, status,position);
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
  }
  _validationCheck(String type,String id,int status,int position){
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
      _updateAttendanceStatus(type, id, status, position, reasonStr);


    }else{
      Toast.show("Please Enter a valid Reason for $statusStr",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  _updateAttendanceStatus(String type,String id,int status,int position,String reason) async{
    APIDialog.showAlertDialog(context, 'Please Wait...');
    String statusStr="";
    if(status==1){
      statusStr="approve";
    }else{
      statusStr="reject";
    }

    List<dynamic> detailArray=[];
    var requestModelfrom = {
      "id": id,
      "approve_for":"",
      "comment":reason,
    };
    detailArray.add(requestModelfrom);

    var requestModel = {
      "type": type,
      "is_approved":statusStr,
      "id":1,
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


  getCorrectionCount(String date,String type,String id,int status,String titles,int position,String reempId) async{

    APIDialog.showAlertDialog(context, "Please wait...");
    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithBase(baseUrl,"attendance_management/correction-counter?emp_id="+reempId, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {

      List<dynamic> tempList=responseJSON['data']['result'];
      for(int i=0;i<tempList.length;i++){
        String fDate=tempList[i]['date'].toString();
        if(fDate==date){
          ShowCorrectionCount=tempList[i]['correction_count'];
          break;
        }
      }

      if(responseJSON['data']['lastMonthLength']!=null){
        lastMonthLength=responseJSON['data']['lastMonthLength'];
      }
      if(responseJSON['data']['hod']!=null){
        HODName=responseJSON['data']['hod'].toString();
      }
      if(status==1){
        _showAttendanceBottomDialogForApprove(type, id, status, titles, position);
      }else{
        _showAttendanceBottomDialog(type, id, status, titles,position);
      }


    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

      setState(() {

      });

    }

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
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(color: AppTheme.otpColor,width: 2.0),
                              color: AppTheme.themeColor

                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child:
                              Text("Correction Count : $ShowCorrectionCount",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white,fontSize: 17.5,
                                    fontWeight: FontWeight.bold),)),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),

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
                              child: DropdownButton(
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
                        ),),
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
      var requestModelfrom = {
      "id": id,
      "approve_for":approveFor,
      "comment":reason,
    };
      detailArray.add(requestModelfrom);


    var requestModel = {
      "type": type,
      "is_approved":statusStr,
      "id":1,
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