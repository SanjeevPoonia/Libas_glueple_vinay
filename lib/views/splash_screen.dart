
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ChecklistTree/network/Utils.dart';
//import 'package:gluple_libas/views/gluple/views/login_screen.dart';
import 'package:ChecklistTree/views/manager/manager_dashboard.dart';
import 'package:ChecklistTree/views/sidemenu/SideMenuHomeScreen.dart';
import 'package:ChecklistTree/views/store/store_dashboard.dart';

import 'dart:io';

import 'package:lottie/lottie.dart';

import 'gluple/views/dashboard_screen.dart';
import 'login_screen.dart';


class SplashScreen extends StatefulWidget{
  final String token;
  SplashScreen(this.token);

  splashState createState()=>splashState();
}
class splashState extends State<SplashScreen>
{
  @override
  Widget build(BuildContext context) {
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
              margin: const EdgeInsets.only(top: 30,left: 25,right: 25),
              child: Center(
               child: Image.asset("assets/checklistree_logo.png"),
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
    if(widget.token!='')
      {
        redirectUser();
      }
    else
      {
        Timer(
            Duration(seconds: 2),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen())));
      }

    //checkForUpdate();

  }

  redirectUser() async {

    String? userType=await MyUtils.getSharedPreferences("usertype");
    if(userType=="store")
      {
        Timer(
            Duration(seconds: 2),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => StoreDashboardScreen())));
      }
    else if(userType=="employee")
      {
        Timer(
            Duration(seconds: 2),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => SideMenuHomeScreen())));
      }




  }

}