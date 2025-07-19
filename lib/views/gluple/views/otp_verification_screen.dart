import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ChecklistTree/views/sidemenu/SideMenuHomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import 'ChangeOnBoarding_PasswordScreen.dart';

class OtpVerificationScreen extends StatefulWidget{
  String email;
  String password;
  String fullName;

  OtpVerificationScreen(this.email, this.password, this.fullName, {super.key});

  _otpVerificationScreen createState()=>_otpVerificationScreen();
}
class _otpVerificationScreen extends State<OtpVerificationScreen>{
  TextEditingController loginController = TextEditingController();
  bool termsChecked = false;
  String? userEnteredOTP="";
  int _start = 30;
  Timer? _timer;
  bool clearText=false;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    bool setText=clearText;
    if(clearText){
      clearText=false;
    }
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
            Column(
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
                        Center(
                          child: Text(widget.fullName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                        ),
                        const SizedBox(height: 10),
                        Padding(padding: EdgeInsets.only(left: 10,right: 10),
                        child: const Center(
                          child: Text('Please Enter the OTP that you have Received on your Email or Mobile Number.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                        ),),
                        const SizedBox(height: 25),

                        Container(
                          margin: const EdgeInsets
                              .symmetric(
                              horizontal: 20),
                          height: 45,
                          child: Center(
                            child: OtpTextField(
                              borderRadius: BorderRadius.circular(4),
                              borderColor:AppTheme.otpColor,
                              fillColor: AppTheme.otpColor,
                              filled: true,
                              numberOfFields: 6,
                              clearText: setText,
                              focusedBorderColor: AppTheme.orangeColor,
                              //set to true to show as box or false to show as dash
                              showFieldAsBox: true,
                              //runs when a code is typed in

                              onCodeChanged:
                                  (String code) {

                              },
                              //runs when every textfield is filled
                              onSubmit: (String
                              verificationCode) {
                                userEnteredOTP = verificationCode;
                                setState(() {
                                  // validateMobileotp(verificationCode);
                                });

                              },

                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child:  Center(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 13,
                                  color:
                                  Color(0xFF1A1A1A),
                                ),
                                children: <TextSpan>[
                                  const TextSpan(
                                      text:
                                      'Resend OTP in '),
                                  TextSpan(
                                    text: _start < 10
                                        ? '00:0' +
                                        _start.toString()
                                        : '00:' +
                                        _start.toString(),
                                    style: const TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                  const TextSpan(text: ' seconds '),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children:  [
                            Text(
                                'Didn\'t receive the OTP ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight:
                                  FontWeight.bold,
                                  color:
                                  Color(0xFF1A1A1A),
                                )),
                            _start == 0
                                ? GestureDetector(
                              onTap: () {
                                print(
                                    "resend otp triggered");
                                resendOTP();
                              },
                              child: Text('Resend',
                                  style: TextStyle(
                                      fontSize: 15,
                                      decoration:
                                      TextDecoration
                                          .underline,
                                      fontWeight:
                                      FontWeight.bold,
                                      color: AppTheme
                                          .themeColor)),
                            )
                                : Text('Resend',
                                style: TextStyle(
                                    fontSize: 15,
                                    decoration:
                                    TextDecoration
                                        .underline,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: Colors.grey)),
                          ],
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
                                child: Text('Verify',
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
            )

          ],
        ),
      ),
    );
  }
  _submitHandler() async{

    print(userEnteredOTP);
    if(userEnteredOTP!=""){
      validateMobileotp(userEnteredOTP);
    }else{
      Toast.show("Please Enter OTP",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  validateMobileotp(otpStr) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Verifying OTP...');
    var requestModel = {
      "email": widget.email,
      "otp": otpStr,
    };
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl=prefs.getString('base_url')??'';

    print(baseUrl);

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(baseUrl,'employee/verifyOtp', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['error'] == false) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      loginUser();

    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  resendOTP() async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Please Wait...');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl=prefs.getString('base_url')??'';

    print(baseUrl);

    var requestModel = {
      "email": widget.email,
      "password":widget.password,
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
      Toast.show("OTP has been resend on Your Email or Mobile Number",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      startTimer();

      clearText=true;
      setState(() {

      });

    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  void startTimer() {
    _start = 30;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  loginUser() async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Please Wait...');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl=prefs.getString('base_url')??'';

    print(baseUrl);

    var requestModel = {
      "email": widget.email,
      "password":widget.password,
      "verifiedLogin":true,
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


      print("Attendance Access By App:- $isAttendanceAccess");
      MyUtils.saveSharedPreferences("user_id", id);
      MyUtils.saveSharedPreferences("email", email);
      MyUtils.saveSharedPreferences("emailId", widget.email);
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }
  
  
}