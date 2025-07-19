import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:ChecklistTree/views/gluple/network/loader.dart';
import 'package:ChecklistTree/views/gluple/utils/payslip_series.dart';
import 'package:ChecklistTree/views/gluple/views/ShowPayslip_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../network/Utils.dart';
import '../network/api_dialog.dart';
import 'dart:io';
import 'package:intl/intl.dart';

import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import '../../login_screen.dart';

class RequestPayslip extends StatefulWidget{
  _requestPayslip createState()=>_requestPayslip();
}
class _requestPayslip extends State<RequestPayslip>{
  List<PayslipSeries> monthsList=[];
  var userIdStr="";
  var designationStr="";
  var token="";
  var fullNameStr="";
  var empId="";
  var baseUrl="";
  var clientCode="";
  var platform="";
  bool isLoading=false;

  String selectedMonthStr="";
  String selectedMonthShow="";
  List<dynamic> payslipList=[];

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(

            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppTheme.at_title,
                border: Border.all(color: AppTheme.orangeColor,width: 1.0)
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10,right: 10),
              child: Row(
                children: [
                  Expanded(child: Text(selectedMonthShow,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.black),)),
                  TextButton(
                      onPressed: (){
                        _selectMonth();
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppTheme.themeColor,
                        ),
                        height: 45,
                        child: const Center(child: Text("Select Month",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 13,color: Colors.white),),),
                      )
                  )
                ],
              ),
            ),

          ),
          payslipList.isEmpty?Center(child: Text("Payslip for $selectedMonthShow is not available.",textAlign:TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: AppTheme.orangeColor),),):
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: payslipList.length,
              itemBuilder: (BuildContext btx,int index){

                String id=payslipList[index]['id'].toString();
                String company=payslipList[index]['company'].toString();
                String sub_company=payslipList[index]['sub_company'].toString();
                return Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                      border: Border.all(color: AppTheme.orangeColor,width: 1.0)
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10,right: 10),
                    child: Row(
                      children: [
                        Expanded(child: Column(

                          children: [
                            Text(company,style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: AppTheme.themeColor
                            ),),
                            const SizedBox(height: 10,),
                            Text(sub_company,style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.black
                            ),),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        )),
                        TextButton(
                            onPressed: (){
                              _getPayslipUrl(selectedMonthStr, id, selectedMonthShow);

                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppTheme.themeColor,
                              ),
                              height: 45,
                              child: const Center(child: Text("View Payslip",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 13,color: Colors.white),),),
                            )
                        )
                      ],
                    ),
                  ),

                );
              })
        ],
      ),
    );

  }
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _getPayslipData();
    });


  }

  _getPayslipData() async {


    APIDialog.showAlertDialog(context, 'Please Wait...');
    userIdStr=await MyUtils.getSharedPreferences("user_id")??"";
    fullNameStr=await MyUtils.getSharedPreferences("full_name")??"";
    token=await MyUtils.getSharedPreferences("token")??"";
    designationStr=await MyUtils.getSharedPreferences("designation")??"";
    empId=await MyUtils.getSharedPreferences("emp_id")??"";
    baseUrl=await MyUtils.getSharedPreferences("base_url")??"";
    clientCode=await MyUtils.getSharedPreferences("client_code")??"";
    String? access=await MyUtils.getSharedPreferences("at_access")??'1';


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


    final now = DateTime.now();
    var date = DateTime(now.year, now.month-1, 1).toString();
    var dateParse = DateTime.parse(date);
    selectedMonthShow=DateFormat("MMM yyyy").format(dateParse);
    selectedMonthStr=DateFormat("yyyy-MM").format(dateParse);
    setState(() {

    });
    Navigator.of(context).pop();

    getPaySlip(selectedMonthStr, selectedMonthShow);


  }
  getPaySlip(String requestedMonth,String showMnth) async {

    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper = ApiBaseHelper();
    //var response = await helper.getWithToken(baseUrl, 'admin/get-employee-salaryslip-ids?emp_id=UB0003&month=$requestedMonth', token, context);
    var response = await helper.getWithToken(baseUrl, 'admin/get-employee-salaryslip-ids?emp_id=$empId&month=$requestedMonth', token, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {

      payslipList.clear();
      payslipList=responseJSON['data'];


     if(payslipList.isEmpty){
       Toast.show("Payslip for $showMnth is not available.",
           duration: Toast.lengthLong,
           gravity: Toast.bottom,
           backgroundColor: Colors.red);
     }

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

    setState(() {

    });
  }
  _getPayslipUrl(String month,String id,String showMonth) async{
    APIDialog.showAlertDialog(context, 'Please Wait generating Payslip...');
    var requestModel = {
      "month": month,
      "autoId":id

    };
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        baseUrl, 'admin/shareSalarySlip', requestModel, context,token);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {

      String payslipUrl=responseJSON['data']['filePath'];

   /*   Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ShowPaySlipScreen(
                    payslipUrl, showMonth,id
                  )));
*/
    }
    else if(responseJSON['code']==401|| responseJSON['message']=='Invalid token.'){
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
  _selectMonth(){
    showMonthPicker(context,
      onSelected: (month,year){
        print("selected Month year $year-$month");
        var date = DateTime(year, month, 1).toString();
        var dateParse = DateTime.parse(date);
        setState(() {
          selectedMonthShow=DateFormat("MMM yyyy").format(dateParse);
          selectedMonthStr=DateFormat("yyyy-MM").format(dateParse);
        });

        getPaySlip(selectedMonthStr, selectedMonthShow);

    },
      initialSelectedMonth: DateTime.now().month-1,
      initialSelectedYear: DateTime.now().year,
      firstYear: 2024,
      lastYear: DateTime.now().year,
      lastEnabledMonth: DateTime.now().month-1,
      selectButtonText: 'Select',
      cancelButtonText: 'Cancel',
      highlightColor: AppTheme.orangeColor,
      textColor: Colors.white,
    );
  }


}