import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class ViewTeamAttendanceLogs extends StatefulWidget
{
  String dateStr;
  String checkIn;
  String checkOut;
  String workingHours;
  String empId;

  ViewTeamAttendanceLogs(this.dateStr,this.checkIn,this.checkOut,this.workingHours,this.empId, {super.key});
  _viewTeamAttendanceLogs createState()=>_viewTeamAttendanceLogs();
}
class _viewTeamAttendanceLogs extends State<ViewTeamAttendanceLogs>{
  String convertedDateStr="";
  bool isLoading=false;
  List<dynamic> attendanceLogsList=[];
  String baseUrl="";
  String platform="";

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
            "",
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
        body: isLoading?Container():
        SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 221,
                        color: AppTheme.at_details_header,
                        child: Padding(padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 20,),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(convertedDateStr,style: const TextStyle(color: Colors.black,fontSize: 18.5,fontWeight: FontWeight.w900),),),
                              SizedBox(height: 10,)
                            ],
                          ),),
                      ),
                      Container(
                        color: Colors.white,
                        height: 71,
                      )
                    ],
                  ),
                  Positioned(
                    child: Container(
                      height: 142,
                      width: MediaQuery.of(context).size.width/1.06,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: AppTheme.at_details_divider,width: 1)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Check In",style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
                                  Text(widget.checkIn,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w900),)
                                ],
                              )),
                              const SizedBox(width: 2,),

                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Check Out",style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
                                  Text(widget.checkOut,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w900),)
                                ],
                              )),
                              const SizedBox(width: 2,),

                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Working Hrs",style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
                                  Text(widget.workingHours,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w900),)
                                ],
                              )),
                            ],
                          )
                        ],

                      ),
                    ),
                    bottom: 0,

                  ),
                  Positioned(child: SvgPicture.asset('assets/at_logs_head.svg',height: 150,width: 50,),right: 5,bottom: 142,)
                ],
              ),
              SizedBox(height: 10,),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("Activity",textAlign:TextAlign.start,style: TextStyle(fontSize: 16.5,color: Colors.black,fontWeight: FontWeight.w900),),),
              SizedBox(height: 10,),
              attendanceLogsList.isEmpty?Center(child: Text("Attendance Events Not Found",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.grey),),):
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: attendanceLogsList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext cntx,int indx){
                    String eventStr="";
                    if(attendanceLogsList[indx]['attendenceStatus']!=null){
                      eventStr=attendanceLogsList[indx]['attendenceStatus'].toString();
                    }
                    String timeStr="";
                    if(attendanceLogsList[indx]['auth_time']!=null){
                      timeStr=attendanceLogsList[indx]['auth_time'].toString();
                    }
                    String checkDevice="";
                    if(attendanceLogsList[indx]['platform']!=null){
                      checkDevice=attendanceLogsList[indx]['platform'].toString();
                      if(checkDevice=='Android'){
                        checkDevice="Android App";
                      }else if(checkDevice=='iOS'){
                        checkDevice="iPhone App";
                      }if(checkDevice=='Web'){
                        checkDevice="Web App";
                      }
                    }
                    if(timeStr.isNotEmpty){
                      DateTime parseDate = DateFormat("hh:mm:ss").parse(timeStr);
                      var inputDate = DateTime.parse(parseDate.toString());
                      var outputFormat = DateFormat('hh:mm a');
                      var outputDate = outputFormat.format(inputDate);
                      timeStr=outputDate.toString();
                    }


                    var tileColor=AppTheme.themeColor;
                    if(eventStr=='IN'){
                      tileColor=AppTheme.themeColor;
                    }else if(eventStr=='OUT'){
                      tileColor=AppTheme.orangeColor;
                    }
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.black
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: 10,),
                          Expanded(child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(checkDevice,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
                              SizedBox(height: 5,),
                              Text(eventStr,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
                            ],
                          ),flex: 1,),
                          Text(timeStr,style: TextStyle(fontSize: 14.5,fontWeight: FontWeight.w900,color: Colors.black),)
                        ],
                      ),
                    );
                  })

            ],
          ),
        )



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
    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, "Please Wait...");


    baseUrl=await MyUtils.getSharedPreferences("base_url")??"";
    if(Platform.isAndroid){
      platform="Android";
    }else if(Platform.isIOS){
      platform="iOS";
    }else{
      platform="Other";
    }

    DateTime parseDate = DateFormat("yyyy-MM-dd").parse(widget.dateStr);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd MMM,yyyy');
    var outputDate = outputFormat.format(inputDate);
    convertedDateStr=outputDate.toString();
    Navigator.pop(context);
    setState(() {
      isLoading=false;
    });


    getAttendanceLogs();
  }
  getAttendanceLogs() async {

    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithBase(baseUrl, 'admin/getAttendanceforHikVision?date=${widget.dateStr}&emp_id=${widget.empId}',context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      attendanceLogsList.clear();
      attendanceLogsList=responseJSON['data'];
    }else{
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      finishScreen();
    }

    setState(() {
      isLoading=false;
    });
  }

  finishScreen(){
    Navigator.of(context).pop();
  }




}