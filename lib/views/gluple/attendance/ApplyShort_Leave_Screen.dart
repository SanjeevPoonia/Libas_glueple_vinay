import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class ApplyShortLeave_Screen extends StatefulWidget{
  final String alDate;

  const ApplyShortLeave_Screen(this.alDate, {super.key});

  _applyShortLeave createState()=>_applyShortLeave();
}
class _applyShortLeave extends State<ApplyShortLeave_Screen>{
  String fromDateStr="Select Date";
  double leaveBalanceStr=0;
  String selectedLeaveTypeKey='';
  String fromDate="";
  var fromDateItem=['First Session','Second Session'];
  String fromDropDownValue = 'First Session';

  bool isLoading=false;
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;
  late var platform;


  List<dynamic> leaveTypeList=[];
  List<dynamic> leaveBalanceList=[];

  final _formKey = GlobalKey<FormState>();
  var reasonController = TextEditingController();

  String checkInTime="";
  String checkOutTime="";
  String selectedInTime="";
  String selectedOutTime="";


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
          "Apply Short Leave",
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
      body: isLoading?const Center():ListView(
        children: [
          Padding(padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date",
                          style: TextStyle(fontSize: 14.5,
                              color: AppTheme.themeColor,
                              fontWeight: FontWeight.w500),),
                        SizedBox(height: 5,),
                        InkWell(
                          onTap: (){
                            _showFromDatePicker();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(color: AppTheme.greyColor,width: 2.0),

                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: Text(fromDateStr,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),)),
                                SizedBox(width: 5,),
                                SvgPicture.asset('assets/at_calendar.svg',height: 21,width: 18,),
                              ],
                            ),
                          ),
                        )

                      ],
                    )),
                    SizedBox(width: 5,),
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text("Leave Status",
                          style: TextStyle(fontSize: 14.5,
                              color: AppTheme.themeColor,
                              fontWeight: FontWeight.w500),),
                        SizedBox(height: 5,),
                        Container(
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
                              setState(() {
                                fromDropDownValue = newValue!;
                              });
                              _changeSelectedTime();
                            },
                            value: fromDropDownValue,
                            icon: Icon(Icons.keyboard_arrow_down,color: AppTheme.themeColor,size: 15,),
                            isExpanded: true,
                            underline: SizedBox(),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),

                SizedBox(height: 20,),

                Row(
                  children: [
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Select Time",
                          style: TextStyle(fontSize: 14.5,
                              color: AppTheme.themeColor,
                              fontWeight: FontWeight.w500),),
                        SizedBox(height: 5,),
                        InkWell(
                          onTap: (){
                           // _showOutTimePicker();
                            _showSelectTime();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(color: AppTheme.greyColor,width: 2.0),

                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: Text("$selectedOutTime - $selectedInTime",style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),)),
                                SizedBox(width: 5,),
                                SvgPicture.asset('assets/ic_clock_icon.svg',height: 21,width: 18,),
                              ],
                            ),
                          ),
                        )

                      ],
                    )),

                  ],
                ),



                SizedBox(height: 30,),
                Row(
                  children: [
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Leave Balance",
                          style: TextStyle(fontSize: 14.5,
                              color: AppTheme.themeColor,
                              fontWeight: FontWeight.w500),),
                        SizedBox(height: 5,),
                        Container(
                          width: double.infinity,
                          height: 45,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: AppTheme.greyColor,width: 2.0),

                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: Text("${leaveBalanceStr.toString()}",style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),)),
                            ],
                          ),
                        )

                      ],
                    )),
                  ],
                ),
                SizedBox( height: 20,),
                Text("Reason",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
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
                        decoration: InputDecoration(
                            border: InputBorder.none
                        ),
                      ),

                    )),

                SizedBox(height: 10,),
                TextButton(
                    onPressed: (){
                      _checkValidation();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppTheme.orangeColor,
                      ),
                      height: 45,
                      padding: const EdgeInsets.all(10),
                      child: const Center(child: Text("Submit For Approval",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                    )
                ),





              ],
            ),),
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      fromDateStr=widget.alDate;
      fromDate=widget.alDate;
      if(fromDropDownValue==fromDateItem[0]){
        selectedOutTime="09:30 AM";
        selectedInTime="02:00 PM";
        checkOutTime="09:30:00";
        checkInTime="14:00:00";
      }else{
        checkOutTime="14:00:00";
        checkInTime="18:30:00";
        selectedOutTime="02:00 PM";
        selectedInTime="06:30 PM";
      }
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


    getLeaveType();
  }
  getLeaveType() async {

    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl, 'attendance_management/getAllLeaveType', token, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {


      leaveTypeList.clear();
      leaveTypeList=responseJSON['data'];


      selectedLeaveTypeKey="short_leave";

      var shortFound=false;
      for(int i=0;i<leaveTypeList.length;i++){
        String leaveType=leaveTypeList[i]['leave_type'].toString();
        String leavekey=leaveTypeList[i]['leave_key'].toString();
        if(leavekey=='short_leave'){
          shortFound=true;
          break;
        }
      }
      setState(() {
        isLoading=false;
      });

      if(!shortFound){
        Toast.show("You are not authorised for apply short leave!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
        _finishTheScreen();
      } else{
        getLeaveBalance();
      }



    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

      setState(() {
        isLoading=false;
      });

      _finishTheScreen();

    }
  }
  _finishTheScreen(){
    Navigator.of(context).pop();
  }
  getLeaveBalance() async {

    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl, 'attendance_management/getTotalLeaveBalanceForEmp', token, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      leaveBalanceList.clear();
      leaveBalanceList=responseJSON['data'];

      String PaidLeaveType="paid_leave";


      for(int i=0;i<leaveBalanceList.length;i++){
        String leaveType=leaveBalanceList[i]['leave_type'].toString();
        if(PaidLeaveType==leaveType){
          leaveBalanceStr=0;
          if(leaveBalanceList[i]['leave_balance']!=null){
            leaveBalanceStr=leaveBalanceList[i]['leave_balance'].toDouble();
          }
          break;
        }
      }
    }

    setState(() {
      isLoading=false;
    });
  }
  _showFromDatePicker() async{
    /*Toast.show("Please Select From Date!!!",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.red);
*/
    var nowDate=DateTime.now();
    var lastDate=DateTime(nowDate.year,nowDate.month+2,1);
    var firstDate=DateTime(nowDate.year,nowDate.month-1,1);

    DateTime? pickedDate=await showDatePicker(context: context, firstDate: firstDate, lastDate: lastDate);
    if(pickedDate !=null){
      fromDate= DateFormat("yyyy-MM-dd").format(pickedDate);
      setState(() {
        fromDateStr=fromDate;
      });
    }
  }
  _changeSelectedTime(){
    if(fromDropDownValue==fromDateItem[0]){
      selectedOutTime="09:00 AM";
      selectedInTime="02:00 PM";
      checkOutTime="09:00:00";
      checkInTime="14:00:00";
    }else{
      checkOutTime="14:00:00";
      checkInTime="18:30:00";
      selectedOutTime="02:00 PM";
      selectedInTime="06:30 PM";
    }
    setState(() {

    });
  }
  _showSelectTime() async{
    TimeRange result=await showTimeRangePicker(context: context,
      start:  TimeOfDay(hour: fromDropDownValue==fromDateItem[0]?09:14, minute: fromDropDownValue==fromDateItem[0]?30:00),
      end: TimeOfDay(hour: fromDropDownValue==fromDateItem[0]?14:18, minute: fromDropDownValue==fromDateItem[0]?00:30),
      disabledTime: TimeRange(startTime: TimeOfDay(hour: fromDropDownValue==fromDateItem[0]?14:18, minute: fromDropDownValue==fromDateItem[0]?01:31),
          endTime: TimeOfDay(hour: fromDropDownValue==fromDateItem[0]?09:13, minute: fromDropDownValue==fromDateItem[0]?29:59)),
      disabledColor: Colors.red.withOpacity(0.5),
      strokeWidth: 4,
      ticks: 24,
      ticksOffset: -7,
      ticksLength: 15,
      ticksColor: Colors.grey,
        labels: [
          "12 am",
          "3 am",
          "6 am",
          "9 am",
          "12 pm",
          "3 pm",
          "6 pm",
          "9 pm"
        ].asMap().entries.map((e) {
          return ClockLabel.fromIndex(
              idx: e.key, length: 8, text: e.value);
        }).toList(),
        labelOffset: 35,
        rotateLabels: false,
        padding: 60
    );
    if(result!=null){
      int startHour=result.startTime.hour;
      int startMint=result.startTime.minute;
      int endHour=result.endTime.hour;
      int endMints=result.endTime.minute;

      var datetime=DateFormat("hh:mm").parse("$startHour:$startMint");
      var selectedtime=DateFormat("hh:mm a").format(datetime);
      checkOutTime=DateFormat("HH:mm:ss").format(datetime);

      selectedOutTime=selectedtime;

      var datetime2=DateFormat("hh:mm").parse("$endHour:$endMints");
      var selectedtime2=DateFormat("hh:mm a").format(datetime2);
      checkInTime=DateFormat("HH:mm:ss").format(datetime2);

      selectedInTime=selectedtime2;

      setState(() {

      });

    }
  }

  _checkValidation(){
    if(fromDate.isNotEmpty){
      if(checkOutTime.isNotEmpty && checkInTime.isNotEmpty){
        if(reasonController.text.isNotEmpty){
          if(0.25<=leaveBalanceStr){
            List<dynamic> detailArray=[];
            List<String> shortTime=[];

            shortTime.add(checkOutTime);
            shortTime.add(checkInTime);
            String leaveSta="";
            if(fromDropDownValue==fromDateItem[0]){
              leaveSta="First Half Day";
            }else{
              leaveSta="Second Half Day";
            }


            var requestModelfrom = {
              "leave_date": fromDate,
              "leave_type":selectedLeaveTypeKey,
              "leave_status":leaveSta,
              "short_time":shortTime
            };
            detailArray.add(requestModelfrom);

            _submitLeaveOnServer(detailArray);
          }else{
            Toast.show("You Don't have 0.25 Leave Balance",
                duration: Toast.lengthLong,
                gravity: Toast.bottom,
                backgroundColor: Colors.red);
          }


        }else{
          Toast.show("Please Enter Reason!!!",
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
        }
      }else{
        Toast.show("Please Select Time!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }


    }else{
      Toast.show("Please Select From Date!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  _submitLeaveOnServer(List<dynamic> leaveDetails)async{
    APIDialog.showAlertDialog(context, 'Please Wait...');
    var requestModel = {
      "emp_id": empId,
      "reason":reasonController.text.toString(),
      "leaveDetails":jsonEncode(leaveDetails),
    };
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(baseUrl, 'attendance_management/applyLeaveApplication',requestModel,context, token);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      if(responseJSON['code']==200){
        _showCustomDialog(responseJSON['message']);
      }
    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

  }
  _showCustomDialog(String msg){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                          _finishTheScreen();
                        },
                        child: Icon(Icons.close_rounded,color: Colors.red,size: 20,),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 100,
                      width: double.infinity,
                      child: Lottie.asset("assets/api_done_anim.json"),
                    ),
                    SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.center,
                      child: Text(msg,style: TextStyle(color: AppTheme.orangeColor,fontWeight: FontWeight.w900,fontSize: 18),),
                    ),
                    SizedBox(height: 20,),
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          _finishTheScreen();
                          //call attendance punch in or out
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.themeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(child: Text("Done",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
                        )
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
  

}