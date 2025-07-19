import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';

class ForgotPassword_Screen extends StatefulWidget{
  _forgotPassword createState()=>_forgotPassword();
}
class _forgotPassword extends State<ForgotPassword_Screen>{
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String emailStr="";
  String otpStr="";
  bool showOTPFields=false;
  bool clearText=false;
  bool isVerified=false;

  bool passwordVisible=true;
  bool confirmVisible=true;

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
            Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 18),
                    Container(

                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 25),
                            const Center(
                              child: Text('Forgot Password',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.orangeColor,
                                  )),
                            ),
                            const SizedBox(height: 25),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 18),
                              child: TextFormField(
                                enabled: !isVerified,
                                controller: emailController,
                                validator: checkEmptyString,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  hintText: "Enter Email",
                                  label: Text("Email"),
                                  /*suffixIcon: Icon(Icons.mail_rounded,color: AppTheme.themeColor,),*/
                                  enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color:AppTheme.orangeColor)),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),

                            showOTPFields?
                            Column(
                              children: [
                                Padding(padding: EdgeInsets.only(left: 10,right: 10),
                                  child: const Center(
                                    child: Text('Please Enter the OTP that you have Received on your Email',
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
                                      enabled: !isVerified,
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
                                        otpStr = verificationCode;
                                        setState(() {
                                          validateMobileotp(verificationCode);
                                        });

                                      },

                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                isVerified?
                                    SizedBox(height: 1,):
                                      InkWell(
                                  onTap: (){
                                    _submitHandler();
                                  },
                                  child: Padding(padding: EdgeInsets.only(left: 10,right: 10),
                                    child: Text("Resend OTP", textAlign: TextAlign.end,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.themeColor
                                      ),),),
                                ),
                                const SizedBox(height: 25),
                              ],
                            ):
                            InkWell(
                              onTap: () {
                                _submitHandler();
                              },
                              child: Center(
                                child: Container(
                                    margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: AppTheme.themeColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    height: 50,
                                    child: const Center(
                                      child: Text('Send OTP',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                    )),
                              ),
                            ),

                            isVerified?
                            Column(
                              children: [
                                const SizedBox(height: 10,),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 18),
                                  child: TextField(
                                    controller: passwordController,
                                    obscureText: passwordVisible,
                                    decoration: InputDecoration(
                                      hintText: "Enter New Password",
                                      label: const Text("New Password"),
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
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 18),
                                  child: TextField(
                                    controller: confirmController,
                                    obscureText: confirmVisible,
                                    decoration: InputDecoration(
                                      hintText: "Enter Confirm Password",
                                      label: const Text("Confirm Password"),
                                      suffixIcon: IconButton(
                                        icon: Icon(confirmVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility, color: AppTheme.themeColor,),
                                        onPressed: () {
                                          setState(
                                                () {
                                              confirmVisible = !confirmVisible;
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
                                const SizedBox(height: 25,),
                                InkWell(
                                  onTap: () {
                                    submitNewPassword();

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
                              ],
                            ):
                            SizedBox(height: 5,),

                            const SizedBox(height: 20,),
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

  bool checkPassword(){
    String newPassword=passwordController.text;
    String confirmPassword=confirmController.text;
    if(newPassword.isEmpty){
      Toast.show("Please enter Valid New  Password",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      return false;
    }else if(confirmPassword.isEmpty){
      Toast.show("Please enter Valid Confirm Password",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      return false;
    }else if(newPassword!=confirmPassword){
      Toast.show("New Password and Confirm Password Must be Same",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      return false;
    }else{
      return true;
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
    if (value!.isEmpty || !regex.hasMatch(value)) {
      return 'Please Enter valid Email Address!!!';
    }
    return null;
  }
  void _submitHandler() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    sendOtpForVerification();
    //
  }
  sendOtpForVerification() async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Please Wait...');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl=prefs.getString('base_url')??'';

    print(baseUrl);

    var requestModel = {
      "email": emailController.text,
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();

    var response = await helper.postAPI(baseUrl,'employee/sendOtp', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      showOTPFields=true;
      emailStr=emailController.text;
    }
    else {
      showOTPFields=false;
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    setState(() {

    });
  }
  validateMobileotp(otpStrss) async {

    otpStr=otpStrss;
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Verifying OTP...');
    var requestModel = {
      "email": emailStr,
      "otp": otpStrss,
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
      print("Email Verified"+responseJSON['data']['verified'].toString());
        if(responseJSON['data']['verified']==true){
          isVerified=true;
        }else{
          isVerified=false;
        }
    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      isVerified=false;
    }

    print("isVerified $isVerified");

    setState(() {

    });
  }
  submitNewPassword(){
    if(checkPassword()){
      changePasswordOnServer();
    }
  }
  changePasswordOnServer() async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Please Wait...');
    var requestModel = {
      "email": emailStr,
      "otp": otpStr,
      "new_password":passwordController.text,
      "confirm_password":confirmController.text,
    };
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl=prefs.getString('base_url')??'';

    print(baseUrl);

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(baseUrl,'employee/forgotPassword', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['error'] == false) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      fininshScreen();

    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  fininshScreen(){
    Navigator.pop(context);
  }



}