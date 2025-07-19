import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../views/login_screen.dart';
import 'Candidate_CallHistory.dart';
import 'Candidate_FeedbackForm.dart';
import 'package:ChecklistTree/views/login_screen.dart';

class HrDashboardScreen extends StatefulWidget{
  _HrDashboard createState()=>_HrDashboard();
}
class _HrDashboard extends State<HrDashboardScreen>{
  final _formKey = GlobalKey<FormState>();
  final _formKeydialog = GlobalKey<FormState>();
  var searchController = TextEditingController();
  var recController = TextEditingController();
  var canController = TextEditingController();
  String startDate="";
  String endDate="";
  var userIdStr="";
  var designationStr="";
  var token="";
  var fullNameStr="";
  var empId="";
  var baseUrl="";
  var clientCode="";
  var platform="";
  var userMobileNumber="";
  bool isLoading=false;
  List<dynamic> candidateList=[];
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(5),
          child:

          Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 10,right: 5),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.orangeSearch
                ),
                child: Row(children: [
                  Expanded(child:
                  Form(
                      key: _formKey,
                      child:  TextField(
                        onChanged: (text){
                          text.isEmpty?
                          getCandidateList():
                          getBlankMethod();

                        },
                        minLines: 1,
                        keyboardType: TextInputType.name,
                        controller: searchController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Candidate Name"
                        ),
                      )),
                  ),
                  TextButton(
                      onPressed: (){
                        _validateSearch();
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppTheme.themeColor,
                        ),
                        height: 45,
                        child: const Center(child: Icon(Icons.search,color: Colors.white,)),
                      )
                  )

                ],),
              ),
              SizedBox(height: 10,),

              isLoading?const Center(child: SizedBox(height: 2,),):

              candidateList.isEmpty?
              Text("Candidate Not Available!",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),):
              ListView.builder(
                  itemCount: candidateList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (contx,indx){
                    print("Candidate Name: ${candidateList[indx]['name']}");
                    String name="";
                    if(candidateList[indx]['name']!=null){
                      name=candidateList[indx]['name'].toString();
                    }
                    String id="";
                    if(candidateList[indx]['candidate_id']!=null){
                      id=candidateList[indx]['candidate_id'].toString();
                    }
                    String mobile="";
                    if(candidateList[indx]['c_mobile']!=null){
                      mobile=candidateList[indx]['c_mobile'].toString();
                    }
                    String email="";
                    if(candidateList[indx]['c_email']!=null){
                      email=candidateList[indx]['c_email'].toString();
                    }
                    String designation="";
                    if(candidateList[indx]['designation']!=null){
                      designation=candidateList[indx]['designation'].toString();
                    }
                    String experience="";
                    if(candidateList[indx]['experience']!=null){
                      experience=candidateList[indx]['experience'].toString();
                    }
                    String mrfStatus="";
                    if(candidateList[indx]['active_status']!=null){
                      mrfStatus=candidateList[indx]['active_status'].toString();
                    }
                    return Padding(padding: EdgeInsets.only(bottom: 5),
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
                              child: Text("$name($id)",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.white,fontSize: 14),),
                            ),
                            SizedBox(height: 10,),
                            Padding(padding: EdgeInsets.only(left: 10,right: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: Text("Mobile :$mobile",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),)),
                                      mrfStatus=="open"?
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(5),
                                            color: AppTheme.at_blue
                                        ),
                                        child: Center(child: Text("Open",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12,color: Colors.white),),),
                                      ):
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(5),
                                            color: AppTheme.at_red
                                        ),
                                        child: Center(child: Text(mrfStatus,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12,color: Colors.white),),),
                                      )

                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Text("Email :$email",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                                  SizedBox(height: 5,),
                                  Text("Designation :$designation",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                                  SizedBox(height: 5,),
                                  experience.isNotEmpty?
                                  Text("Experience :$experience",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),):
                                  SizedBox(height: 2,),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => CandidateCallHistory(id)),);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(5),
                                              color: AppTheme.at_details_date_back
                                          ),
                                          child: Center(child: Text("View Call History",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12,color: Colors.white),),),
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => CandidateFeedback(name,mobile,email,designation,mrfStatus)),);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(5),
                                              color: AppTheme.task_QAReady_back
                                          ),
                                          child: Center(child: Text("Add Feedback",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12,color: Colors.white),),),
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      InkWell(
                                        onTap: (){
                                          _initiateCall(name,userMobileNumber,mobile,id);
                                         // _showAttendanceBottomDialog(id, mobile,name);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(5),
                                              color: AppTheme.at_purple
                                          ),
                                          child: Center(child: Text("New Call",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12,color: Colors.white),),),
                                        ),
                                      ),

                                    ],
                                  )
                                ],
                              ),),






                          ],
                        ),
                      ),);
                  }
              )
            ],
          ),),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _getUserData();
    });
  }
  getUserProfile() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? orgDetails=prefs.getString('base_url')??'';

    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithToken(orgDetails,"employee/getEmployeeProfileDetails",token, context);

    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      String panel_role="";

      List<dynamic> tempUserList=[];
      tempUserList=responseJSON['data'];
      for(int i=0;i<tempUserList.length;i++){
        panel_role=tempUserList[i]['panel_role'].toString();
        userMobileNumber=tempUserList[i]['mobile'].toString();
      }

    }else if(responseJSON['code']==401|| responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _logOut(context);
    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

  }
  _getUserData() async {


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
    var date = DateTime(now.year, now.month, 1).toString();
    var dateParse = DateTime.parse(date);
    startDate=DateFormat("yyyy-MM-dd").format(dateParse);

    var lDate = DateTime(now.year,now.month+1,0).toString();
    var ldatePar=DateTime.parse(lDate);
    endDate=DateFormat("yyyy-MM-dd").format(ldatePar);

    print("startDate: $startDate");
    print("endDate: $endDate");



    setState(() {

    });
    Navigator.of(context).pop();


    getCandidateList();
    getUserProfile();

  }
  getBlankMethod(){}
  getCandidateList() async {
    FocusScope.of(context).unfocus();
    isLoading=true;
    setState(() {

    });

    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper = ApiBaseHelper();
    String b4Url="https://glueple.com:3001/ats/";
    var response = await helper.getWithBase(b4Url, 'get-candidates?startDate=$startDate&endDate=$endDate',context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      candidateList.clear();
      candidateList=responseJSON['data'];
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
  _validateSearch(){
    FocusScope.of(context).unfocus();
    String searchText=searchController.text;
    if((searchText.trim()).isNotEmpty){
      getCandidateListBySearch(searchText);
    }else{
      Toast.show("Please Enter Candidate Name",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  getCandidateListBySearch(String searchText) async{
    isLoading=true;
    setState(() {

    });

    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper = ApiBaseHelper();
    String b4Url="https://glueple.com:3001/ats/";
    var response = await helper.getWithBase(b4Url, 'get-candidates?search_text=&location=&experience=&education=&recruiter=&candidate_name=$searchText&candidate_mobile=&startDate=&endDate= ',context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      candidateList.clear();
      candidateList=responseJSON['data'];
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
  _showAttendanceBottomDialog(String id,String mobileNumber,String name){

    recController.text=userMobileNumber;
    canController.text=mobileNumber;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext contx){
          return
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(contx).viewInsets.bottom,top: 15,right: 15,left: 15),
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
                  ),
                  child: Form(
                    // key: _formKeydialog,
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        SizedBox(height: 20,),
                        Align(alignment: Alignment.center, child: Container(height: 5,width: 30,color: AppTheme.greyColor,),),
                        SizedBox(height: 10,),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(child: Text("Call Information",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black,fontSize: 18.5),)),
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
                        Text("Recruiter Mobile Number",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                        SizedBox( height: 5,),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: AppTheme.greyColor,width: 2.0),

                          ),
                          child: TextField(
                            minLines: 1,
                            keyboardType: TextInputType.number,
                            controller: recController,
                            maxLength: 10,
                          ),

                        ),

                        SizedBox(height: 10,),
                        Text("Candidate Mobile Number",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                        SizedBox( height: 5,),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: AppTheme.greyColor,width: 2.0),

                          ),
                          child: TextField(
                            minLines: 1,
                            keyboardType: TextInputType.number,
                            controller: canController,
                            maxLength: 10,
                          ),

                        ),

                        TextButton(
                            onPressed: (){

                              _submitCancelHandler(id,name);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppTheme.orangeColor,
                              ),
                              height: 40,
                              padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                              child: const Center(child: Text("Initiate Call",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                            )
                        ),


                      ],
                    ),
                  ),
                ),
              ),
            );
        });
  }
  _showAttendanceBottomDialog1(String id,String mobileNumber,String name){

    recController.text=userMobileNumber;
    canController.text=mobileNumber;

    showModalBottomSheet(
        context: context,
        builder: (BuildContext contx){
          return
            SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 15,right: 15,left: 15,bottom: MediaQuery.of(context).viewInsets.bottom+10),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
                ),
                child: Form(
                  key: _formKeydialog,
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      SizedBox(height: 20,),
                      Align(alignment: Alignment.center, child: Container(height: 5,width: 30,color: AppTheme.greyColor,),),
                      SizedBox(height: 10,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(child: Text("Call Information",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black,fontSize: 18.5),)),
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
                      Text("Recruiter Mobile Number",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                      SizedBox( height: 5,),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(color: AppTheme.greyColor,width: 2.0),

                        ),
                        child: TextField(
                          minLines: 1,
                          keyboardType: TextInputType.number,
                          controller: recController,
                          maxLength: 10,
                        ),

                      ),

                      SizedBox(height: 10,),
                      Text("Candidate Mobile Number",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                      SizedBox( height: 5,),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(color: AppTheme.greyColor,width: 2.0),

                        ),
                        child: TextField(
                          minLines: 1,
                          keyboardType: TextInputType.number,
                          controller: canController,
                          maxLength: 10,
                        ),

                      ),

                      TextButton(
                          onPressed: (){

                            _submitCancelHandler(id,name);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppTheme.orangeColor,
                            ),
                            height: 40,
                            padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                            child: const Center(child: Text("Initiate Call",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                          )
                      ),


                    ],
                  ),
                ),
              ),
            );
        });
  }
  _submitCancelHandler(String id,String name){
    String recNumber=recController.text;
    String canNumber=canController.text;
    if((recNumber.trim()).isNotEmpty && recNumber.length==10){
      if((canNumber.trim()).isNotEmpty && canNumber.length==10){
        Navigator.of(context).pop();
        _initiateCall(name, recNumber, canNumber, id);
      }else{
        Toast.show("Please Enter Valid 10 digit Candidate Mobile Number",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    }else{
      Toast.show("Please Enter Valid 10 digit Recruiter Mobile Number",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }


  }
  _initiateCall(String name,String recMob,String canMob,String id) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper = ApiBaseHelper();

    var requestModel = {
      "candidate_id": id,
      "agent_id":userIdStr,
      "agent_qid":empId,
      "agent_number":recMob,
      "candidate_number_1":canMob,
      "candidate_name_1":name,
      "platform":platform,
    };
    String b4Url="https://glueple.com:3001/ats/";
    var response = await helper.postAPIWithHeader(b4Url, 'get-s2call-access-num',requestModel,context,token);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {

      String accessNumber="+${responseJSON['data']['access_number']}";
      print("Access Number $accessNumber");

      if (await canLaunchUrl(Uri.parse(
          'tel:$accessNumber')))
      {
        launchUrl(Uri.parse(
            'tel:$accessNumber'));
      }
      else
      {throw 'Could not launch call';}

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


  }






}