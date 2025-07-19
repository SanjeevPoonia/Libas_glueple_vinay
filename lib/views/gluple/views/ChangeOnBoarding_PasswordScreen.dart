import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import '../../login_screen.dart';


class ChangeOnBoardingPasswordScreen extends StatefulWidget{
  _changePassword createState()=>_changePassword();
}
class _changePassword extends State<ChangeOnBoardingPasswordScreen>{
  var passwordController = TextEditingController();
  var confirmController = TextEditingController();
  var currentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible=true;
  bool confirmVisible=true;
  bool currentVisible=true;
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
                              child: TextField(
                                controller: currentController,
                                obscureText: currentVisible,
                                decoration: InputDecoration(
                                  hintText: "Enter Current Password",
                                  label: const Text("Current Password"),
                                  suffixIcon: IconButton(
                                    icon: Icon(currentVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility, color: AppTheme.themeColor,),
                                    onPressed: () {
                                      setState(
                                            () {
                                              currentVisible = !currentVisible;
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
                            const SizedBox(height: 10,),



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
  bool checkPassword(){
    String currentPass=currentController.text;
    String newPass=passwordController.text;
    String confirmPass=confirmController.text;
    if(currentPass.isEmpty){
      Toast.show("Please enter Current Password",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      return false;
    }else if(newPass.isEmpty){
      Toast.show("Please enter New Password",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      return false;
    }else if(confirmPass.isEmpty){
      Toast.show("Please enter Confirm  Password",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      return false;
    }else if(newPass!=confirmPass){
      Toast.show("New Password and Confirm Password Must Be Same",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      return false;
    }else{
      return true;
    }
  }
  void _submitHandler() async {
    if(checkPassword()){
      changePasswordOnServer();
    }
  }
  changePasswordOnServer() async{
    APIDialog.showAlertDialog(context, "Please wait...");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? orgDetails=prefs.getString('base_url')??'';
    String? token=prefs.getString('token')??'';
    var requestModel = {
      "old_password": currentController.text,
      "new_password":passwordController.text,
      "confirm_password":confirmController.text,
    };
    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.postAPIWithHeader(orgDetails, "employee/changeEmployeePassword", requestModel, context, token);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      _logOut(context);
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
}