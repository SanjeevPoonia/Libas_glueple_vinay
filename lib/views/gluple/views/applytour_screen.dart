import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import 'package:intl/intl.dart';


class ApplyTourScreen extends StatefulWidget{
  _applyTourScreen createState()=>_applyTourScreen();
}
class _applyTourScreen extends State<ApplyTourScreen>{
  String dateRageStr="Please Select Date Range";
  String fromDate="";
  String fromDateStr="Select From Date";
  String toDateStr="Select To Date";
  String toDate="";
  var reasonController = TextEditingController();
  var visitingPalaceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading=false;
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;

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
          "Apply Tour",
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Row(
                    children: [
                      Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("From Date",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                          SizedBox( height: 5,),
                          InkWell(
                            onTap: (){
                              _showFromDatePicker();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(color: AppTheme.greyColor,width: 2.0),

                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(child: Text(fromDateStr,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),)),
                                  SizedBox(width: 5,),
                                  SvgPicture.asset('assets/at_calendar.svg',height: 21,width: 18,),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                      SizedBox(width: 5,),
                      Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("To Date",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                          SizedBox( height: 5,),
                          InkWell(
                            onTap: (){
                              _showEndValidation();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(color: AppTheme.greyColor,width: 2.0),

                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(child: Text(toDateStr,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),)),
                                  SizedBox(width: 5,),
                                  SvgPicture.asset('assets/at_calendar.svg',height: 21,width: 18,),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),



                  SizedBox(height: 10,),
                  Text("Reason",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                  SizedBox( height: 5,),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: AppTheme.greyColor,width: 2.0),

                    ),
                    child: TextField(
                      controller: reasonController,
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      maxLength: 500,
                      decoration: InputDecoration(
                          border: InputBorder.none
                      ),
                    ),

                  ),
                  SizedBox(height: 10,),

                  Text("Visiting Destination",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                  SizedBox( height: 5,),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: AppTheme.greyColor,width: 2.0),

                    ),
                    child: TextField(
                      controller: visitingPalaceController,
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          border: InputBorder.none
                      ),
                    ),

                  ),
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
              ),
            ),),
        ],
      ),
    );

  }
  _showFromDatePicker() async{
    var nowDate=DateTime.now();
    var lastDate=DateTime(nowDate.year,nowDate.month+2,1);
    var firstDate=DateTime(nowDate.year,nowDate.month-1,1);

    DateTime? pickedDate=await showDatePicker(context: context, firstDate: firstDate, lastDate: lastDate);
    if(pickedDate !=null){
      fromDate= DateFormat("yyyy-MM-dd").format(pickedDate);
      fromDateStr=DateFormat("dd MMM yyyy").format(pickedDate);
      setState(() {

      });

      //_showEndDatePicker();
    }
  }

  _showEndValidation(){
    if(fromDate.isNotEmpty){
      _showEndDatePicker();
    }else{
      Toast.show("Please Select From Date First!!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  _showEndDatePicker() async{
    var nowDate=DateFormat("yyyy-MM-dd").parse(fromDate);
    var lastDate=DateTime(nowDate.year,nowDate.month,nowDate.day+6);

    DateTime? pickedDate=await showDatePicker(context: context, firstDate: nowDate, lastDate: lastDate);
    if(pickedDate !=null){
      toDate= DateFormat("yyyy-MM-dd").format(pickedDate);
      toDateStr= DateFormat("dd MMM yyyy").format(pickedDate);

      setState(() {

      });
    }
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
    Navigator.pop(context);
    setState(() {
      isLoading=false;
    });
  }

  _checkValidation(){
    if(fromDate.isEmpty || toDate.isEmpty){
      Toast.show("Please Select From Date And To Date",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(reasonController.text.isEmpty || reasonController.text.length<5){
      Toast.show("Please Enter a valid reason of Applying Tour",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(visitingPalaceController.text.isEmpty || visitingPalaceController.text.length<3){
      Toast.show("Please Enter a valid Visiting Destination",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else{
      _submitTourOnServer();
    }
  }

  _submitTourOnServer()async{
    APIDialog.showAlertDialog(context, 'Please Wait...');
    var requestModel = {
      "emp_id": empId,
      "from_date":fromDate,
      "to_date":toDate,
      "reason_for_tour":reasonController.text.toString(),
      "visiting_destination":visitingPalaceController.text.toString()
    };
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(baseUrl, 'attendance_management/applyTourApplication',requestModel,context, token);
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
  _finishTheScreen(){
    Navigator.of(context).pop();
  }

}