
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ChecklistTree/views/gluple/views/ChangeOnBoarding_PasswordScreen.dart';
import 'package:ChecklistTree/views/gluple/views/HomeScreen.dart';
import 'package:ChecklistTree/views/gluple/views/landing_screen.dart';
import '../../login_screen.dart';
import 'package:ChecklistTree/views/sidemenu/SideMenuHomeScreen.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import 'dart:io';

class SplashScreen extends StatefulWidget{
  final String token;
  const SplashScreen(this.token, {super.key});
  splashState createState()=>splashState();
}
class splashState extends State<SplashScreen>
{
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              //color: AppTheme.bottomDisabledColor,
              color: Colors.white,
              /*image: DecorationImage(
                image: AssetImage('assets/login_bg.png'),
                fit: BoxFit.contain,
              ),*/
            ),
          ),

          Center(
            child: Container(
              height: 200,
              margin: const EdgeInsets.only(top: 30),
              child: Center(
                /*child: SvgPicture.asset(
                  'assets/app_logo.svg',
                ),*/
                child: Lottie.asset("assets/splash_loader.json"),
              ),
            ),
          )
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    //checkForUpdate();
    redirectFun();
  }
  checkForUpdate() async{
    if(Platform.isAndroid){
      try {
        InAppUpdate.checkForUpdate().then((info) =>
        {
          if(info.updateAvailability == UpdateAvailability.updateAvailable){
            InAppUpdate.performImmediateUpdate().catchError(
                redirectFun()
            )
          } else
            {
              redirectFun()
            }
        });
      }on Exception catch(e){
        print(e);
        redirectFun();
      }
    }else{
      redirectFun();
    }
  }
  redirectFun() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? orgDetails=prefs.getString('base_url')??'';
    String? panelRole=prefs.getString('role')??'';
    String? isPassChange=prefs.getString('is_password_changed')??'1';


    print("Organization Details"+orgDetails);
    print("Password Change"+isPassChange);
    if(orgDetails==''){
      Timer(
          const Duration(seconds: 4),
              () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LandingScreen())));
    }else{
      if(widget.token!='')
      {

        print(widget.token);
        if(isPassChange=='0'){
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => ChangeOnBoardingPasswordScreen()));
        }else if(panelRole=='onboarding_employee'){
          getUserProfile();
        }else{
          Timer(
              const Duration(seconds: 4),
                  () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => SideMenuHomeScreen())));
        }
      }
      else
      {
        Timer(
            const Duration(seconds: 4),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen())));
      }
    }

  }
  getUserProfile() async{
    APIDialog.showAlertDialog(context, "Please wait...");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? orgDetails=prefs.getString('base_url')??'';

    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithToken(orgDetails,"employee/getEmployeeProfileDetails",widget.token, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      String panel_role="";
      List<dynamic> tempUserList=[];
      tempUserList=responseJSON['data'];
      for(int i=0;i<tempUserList.length;i++){
        panel_role=tempUserList[i]['panel_role'].toString();
      }
      if(panel_role=="onboarding_employee"){
        getUserProfileStatus();
      }else{
        prefs.setString("role", panel_role);
        /*Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false);*/
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SideMenuHomeScreen()),
                (Route<dynamic> route) => false);
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
      getUserProfileStatus();
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
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => OfferLetterScreen()));

    }else if(aadharverification=='1'&&AadharVerify=='0'){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => AadhaarVerificationScreen()));

    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => OnBoardingDashboardScreen()));
    }




  }*/
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
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
  }
  getUserProfileStatus() async{
    APIDialog.showAlertDialog(context, "Please wait...");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? orgDetails=prefs.getString('base_url')??'';

    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithToken(orgDetails,"employee/getEmployeeProfileDetailStatus",widget.token, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      List<dynamic> tempUserList=[];
      tempUserList=responseJSON['data'];

      if(tempUserList.isNotEmpty){
        String isOfferAccepted=tempUserList[0]['offer_letter_status'].toString();
        String isOfferRejected=tempUserList[0]['offer_letter_rejection_status'].toString();
        MyUtils.saveSharedPreferences("offer_accepted", isOfferAccepted);
      }
      //redirectToOnBoarding();
      getAdharStatus(widget.token);


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
      getAdharStatus(widget.token);
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
      /*List<dynamic> tempUserList=[];
      tempUserList=responseJSON['data'];

      if(tempUserList.isNotEmpty){
        String isAdharAcc=tempUserList[0]['aadhar_verification_status'].toString();
        MyUtils.saveSharedPreferences("aadhar_verify", isAdharAcc);
      }*/
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
}