import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ChecklistTree/views/gluple/network/Utils.dart';
import 'package:ChecklistTree/views/gluple/views/ChangeOnBoarding_PasswordScreen.dart';
import 'package:ChecklistTree/views/gluple/views/ForgotPassword_Screen.dart';
import 'package:ChecklistTree/views/gluple/views/otp_verification_screen.dart';
import 'package:ChecklistTree/views/sidemenu/SideMenuHomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';

class LoginScreenGluple extends StatefulWidget{
  loginState createState()=> loginState();
}
class loginState extends State<LoginScreenGluple>{
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible=true;
  var emailId = "";

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
  return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppTheme.themeColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset("assets/logo_main_wh.png",height: 50,width: 150,),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/back_img.png'),
                            fit: BoxFit.cover,
                          )
                      ),
                    )
                  ],
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 18),
                      Container(
                        height: 450,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView(
                            children: [
                              const SizedBox(height: 25),
                              const Center(
                                child: Text('Hello',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.orangeColor,
                                    )),
                              ),
                              const SizedBox(height: 10),
                              const Center(
                                child: Text('Login to your Account.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                              ),
                              const SizedBox(height: 25),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 18),
                                child: TextFormField(
                                  controller: usernameController,
                                  validator: checkEmptyString,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Email / Employee Code",
                                    label: Text("Email / Employee Code"),
                                    /*suffixIcon: Icon(Icons.mail_rounded,color: AppTheme.themeColor,),*/
                                    enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color:AppTheme.orangeColor)),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 18),
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: passwordVisible,
                                  decoration: InputDecoration(
                                    hintText: "Enter Password",
                                    label: const Text("Password"),
                                    suffixIcon: IconButton(
                                      icon: Icon(passwordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility, color: AppTheme.themeColor,),
                                      onPressed: () {
                                        setState(
                                              () {
                                            passwordVisible = !passwordVisible;
                                          },
                                        );
                                      },
                                    ),
                                    alignLabelWithHint: false,
                                    filled: false,
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,

                                ),
                              ),
                              const SizedBox(height: 10,),
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword_Screen()),);
                                },
                                child: Padding(padding: EdgeInsets.only(left: 10,right: 10),
                                  child: Text("Forgot Password", textAlign: TextAlign.end,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.themeColor
                                    ),),),
                              ),


                              const SizedBox(height: 35),
                              InkWell(
                                onTap: () {
                                  _submitHandler();

                                },
                                child: Container(
                                    margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: AppTheme.themeColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    height: 50,
                                    child: const Center(
                                      child: Text('Login',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                    )),
                              ),
                              const SizedBox(height: 40,),
                              SvgPicture.asset("assets/powered_by.svg"),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height:MediaQuery.of(context).viewInsets.bottom)
                    ],
                  ))

            ],
          ),
        ),
    );
  }

  void initState(){
    super.initState();
    setEmailId();
  }
  void setEmailId() async{
    String ? emd = await MyUtils.getSharedPreferences("emailId");
    print(emd);
    if (emd != "" && emd!=null) {
      usernameController.text = emd!; // Clear email field when login page initializes
    }
  }

  String? checkEmptyString(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);
    //if (value!.isEmpty || !regex.hasMatch(value)) {
    if (value!.isEmpty) {
      return 'Please enter Your Email or Employee Code';
    }
    return null;
  }
  bool checkPassword(String? value){
    if(value!.isEmpty){
      Toast.show("Please enter Valid Password",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      return false;
    }
    return true;
  }
  void _submitHandler() async {
    if (!_formKey.currentState!.validate() || !checkPassword(passwordController.text)) {
      return;
    }
    _formKey.currentState!.save();

    loginUser();
    //
  }
  loginUser() async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Please Wait...');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl=prefs.getString('base_url')??'';

    print(baseUrl);

    var requestModel = {
      "email": usernameController.text,
      "password":passwordController.text,
      "verifiedLogin":false,
      "platform":"web",
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();

    var response = await helper.postAPI(baseUrl,'employee/emplogin', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      String token=responseJSON['data']['token'].toString();
      String id="";
      String email="";
      String employee_designation="";
      String employee_department="";
      String employee_reporting_manager="";
      String location="";
      String first_name="";
      String last_name="";
      String panel_role="";
      String fullName="";
      String emp_id="";
      String isAttendanceAccess="1";
      List<dynamic> tempUserList=[];
      String authOTP="0";
      String isPasswordChanged="1";

      tempUserList=responseJSON['data']['user'];
      for(int i=0;i<tempUserList.length;i++){
          id=tempUserList[i]['id'].toString();
          email=tempUserList[i]['email'].toString();
          employee_designation=tempUserList[i]['employee_designation'].toString();
          employee_department=tempUserList[i]['employee_department'].toString();
          employee_reporting_manager=tempUserList[i]['employee_reporting_manager'].toString();
          location=tempUserList[i]['location'].toString();
          first_name=tempUserList[i]['first_name'].toString();
          last_name=tempUserList[i]['last_name'].toString();
          panel_role=tempUserList[i]['panel_role'].toString();
          emp_id=tempUserList[i]['emp_id'].toString();
          isPasswordChanged=tempUserList[i]['is_password_changed'].toString();

          if(tempUserList[i]['is_mark_attendance_app']!=null){
            isAttendanceAccess=tempUserList[i]['is_mark_attendance_app'].toString();
          }

          fullName="$first_name $last_name";

          if(tempUserList[i]['otp_auth']!=null){
            authOTP=tempUserList[i]['otp_auth'].toString();
          }
      }


      if(authOTP=="1"){
        Navigator.push(context, MaterialPageRoute(builder: (context) => OtpVerificationScreen(usernameController.text, passwordController.text, fullName)),);
      }else{
          print("Attendance Access By App:- $isAttendanceAccess");
          MyUtils.saveSharedPreferences("user_id", id);
          MyUtils.saveSharedPreferences("email", email);
          MyUtils.saveSharedPreferences("emailId", usernameController.text);
          MyUtils.saveSharedPreferences("designation", employee_designation);
          MyUtils.saveSharedPreferences("department", employee_department);
          MyUtils.saveSharedPreferences("manager", employee_reporting_manager);
          MyUtils.saveSharedPreferences("location", location);
          MyUtils.saveSharedPreferences("first_name", first_name);
          MyUtils.saveSharedPreferences("last_name", last_name);
          MyUtils.saveSharedPreferences("role", panel_role);
          MyUtils.saveSharedPreferences("full_name", fullName);
          MyUtils.saveSharedPreferences("token", token);
          MyUtils.saveSharedPreferences("emp_id", emp_id);
          MyUtils.saveSharedPreferences("at_access", isAttendanceAccess);
          MyUtils.saveSharedPreferences("is_password_changed", isPasswordChanged);
          if(isPasswordChanged=="0"){
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => ChangeOnBoardingPasswordScreen()),
                    (Route<dynamic> route) => false);
          }else if(panel_role=="onboarding_employee"){
            getUserProfile(token);
          }else{
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SideMenuHomeScreen()),
                    (Route<dynamic> route) => false);
          }
      }

    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }


  getUserProfile(String token) async{
    APIDialog.showAlertDialog(context, "Please wait...");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? orgDetails=prefs.getString('base_url')??'';

    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithToken(orgDetails,"employee/getEmployeeProfileDetailStatus",token, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      List<dynamic> tempUserList=[];
      tempUserList=responseJSON['data'];

      if(tempUserList.isNotEmpty){
        String isOfferAccepted=tempUserList[0]['offer_letter_status'].toString();
        MyUtils.saveSharedPreferences("offer_accepted", isOfferAccepted);
      }
      //redirectToOnBoarding();
      getAdharStatus(token);


    }else if(responseJSON['code']==401|| responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      //redirectToOnBoarding();
      getAdharStatus(token);
    }

  }

  getAdharStatus(String token)async{
    APIDialog.showAlertDialog(context, "Please wait...");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? orgDetails=prefs.getString('base_url')??'';
    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithToken(orgDetails,"employee/getDocuumentStatus",token, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    if (responseJSON['error'] == false) {

      if(responseJSON['data'] is List){
        List<dynamic> tempUserList=[];
        tempUserList=responseJSON['data'];
        if(tempUserList.isNotEmpty){
          String isAdharAcc=tempUserList[0]['aadhar_verification_status'].toString();
          MyUtils.saveSharedPreferences("aadhar_verify", isAdharAcc);
        }
      }else{
        String uploadStatus=responseJSON['data']['upload_status'].toString();
        MyUtils.saveSharedPreferences("aadhar_verify", "0");

      }




     // redirectToOnBoarding();


    }else if(responseJSON['code']==401|| responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
     // redirectToOnBoarding();
    }

  }

/*  redirectToOnBoarding()async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? panelRole=prefs.getString('role')??'';
    String? offerAccepted=prefs.getString('offer_accepted')??'';
    String? AadharVerify=prefs.getString('aadhar_verify')??'';
    String? OfferLetter=prefs.getString('offer_letter')??'';
    String? aadharverification=prefs.getString('aadhar_verification')??'';

    if(OfferLetter=='1'&&offerAccepted=='0'){
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => OfferLetterScreen()),
              (Route<dynamic> route) => false);

    }else if(aadharverification=='1'&&AadharVerify=='0'){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => AadhaarVerificationScreen()));

    }else{
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => OnBoardingDashboardScreen()),
              (Route<dynamic> route) => false);
    }




  }*/





}