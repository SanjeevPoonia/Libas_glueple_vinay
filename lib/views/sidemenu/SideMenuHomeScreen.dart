import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:ChecklistTree/views/gluple/attendance/TeamAttendance.dart';
import 'package:ChecklistTree/views/gluple/attendance/attendance_managment.dart';
import 'package:ChecklistTree/views/gluple/network/Utils.dart';
import 'package:ChecklistTree/views/gluple/network/api_helper.dart';
import 'package:ChecklistTree/views/gluple/views/Taskbox_Screen.dart';
import 'package:ChecklistTree/views/login_screen.dart';
import 'package:ChecklistTree/network/api_helper.dart' as libas;

import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/app_theme.dart';
import '../gluple/views/dashboard_screen.dart';
class SideMenuHomeScreen extends StatefulWidget{
  _sideMenuHomeScreen createState()=>_sideMenuHomeScreen();
}
class _sideMenuHomeScreen extends State<SideMenuHomeScreen>{
  final _advancedDrawerController = AdvancedDrawerController();
  int selectedPosition=0;
  String selectedTitle="Dashboard";
  var fullNameStr="";
  var empId="";
  var clientCode="";
  var currentVersionCode="";
  var currentVersionName="";
  var platform="";
  var baseUrl="";
  var token="";
  @override
  Widget build(BuildContext context) {
  return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.themeColor, AppTheme.themeColor.withOpacity(0.5)],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(selectedTitle,style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white)
            ,),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                    color: Colors.white,

                  ),
                );
              },
            ),
          ),
          backgroundColor: AppTheme.themeColor,
        ),
        body: getScreens(),
      ),
      drawer: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      Container(
                        width: 50.0,
                        height: 50.0,
                        margin: const EdgeInsets.only(
                          top: 24.0,
                          bottom: 24.0,
                        ),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/profile.png',
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullNameStr,
                            style: TextStyle(
                                fontSize: 17.5,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.orangeColor),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            empId,
                            style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),flex: 1,)

                    ],
                  ),

                  ListTile(
                    onTap: () {
                      setState(() {
                        selectedTitle="Dashboard";
                        selectedPosition=0;
                      });
                    },
                    leading: Icon(Icons.dashboard_customize_outlined),
                    title: Text('Dashboard'),
                    tileColor: selectedPosition==0?AppTheme.orangeColor:Colors.transparent,
                  ),
                /*  ListTile(
                    onTap: () {
                      setState(() {
                        selectedTitle="Task Box";
                        selectedPosition=1;
                      });
                    },
                    leading: Icon(Icons.task_outlined),
                    title: Text('Task Box'),
                    tileColor: selectedPosition==1?AppTheme.orangeColor:Colors.transparent,
                  ),*/
                  ListTile(
                    onTap: () {
                      setState(() {
                        selectedTitle="Attendance Details";
                        selectedPosition=2;
                      });
                    },
                    leading: Icon(Icons.person_pin_outlined),
                    title: Text('Attendance Details'),
                    tileColor: selectedPosition==2?AppTheme.orangeColor:Colors.transparent,
                  ),



                  ListTile(
                    onTap: () {
                      setState(() {
                        selectedTitle="Task Box";
                        selectedPosition=3;
                      });
                    },
                    leading: Icon(Icons.task_outlined),
                    title: Text('Task Box'),
                    tileColor: selectedPosition==3?AppTheme.orangeColor:Colors.transparent,
                  ),



                /*  ListTile(
                    onTap: () {
                      setState(() {
                        selectedTitle="Team Attendance";
                        selectedPosition=3;
                      });
                    },
                    leading: Icon(Icons.groups_3_outlined),
                    title: Text('Team Attendance'),
                    tileColor: selectedPosition==3?AppTheme.orangeColor:Colors.transparent,
                  ),
*/
                  /*ListTile(
                    onTap: () {
                      setState(() {
                        selectedTitle="Candidate Library";
                        selectedPosition=6;
                      });
                    },
                    leading: Icon(Icons.person_add_alt_1_outlined),
                    title: Text('Candidate Library'),
                    tileColor: selectedPosition==6?AppTheme.orangeColor:Colors.transparent,
                  ),*/
                 /* ListTile(
                    onTap: () {
                      setState(() {
                        selectedTitle="Saparation";
                        selectedPosition=5;
                      });
                    },
                    leading: Icon(Icons.person_remove_outlined),
                    title: Text('Separation'),
                    tileColor: selectedPosition==5?AppTheme.orangeColor:Colors.transparent,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        selectedTitle="MRF";
                        selectedPosition=6;
                      });
                    },
                    leading: Icon(Icons.person_add_alt),
                    title: Text('MRF'),
                    tileColor: selectedPosition==6?AppTheme.orangeColor:Colors.transparent,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        selectedTitle="Task Management";
                        selectedPosition=7;
                      });
                    },
                    leading: Icon(Icons.add_task),
                    title: Text('Task Managment'),
                    tileColor: selectedPosition==7?AppTheme.orangeColor:Colors.transparent,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        selectedTitle="Payroll";
                        selectedPosition=8;
                      });
                    },
                    leading: Icon(Icons.money_outlined),
                    title: Text('Payroll'),
                    tileColor: selectedPosition==8?AppTheme.orangeColor:Colors.transparent,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        selectedTitle="Tours & Claims";
                        selectedPosition=9;
                      });
                    },
                    leading: Icon(Icons.airplane_ticket_outlined),
                    title: Text('Tours & Claims'),
                    tileColor: selectedPosition==9?AppTheme.orangeColor:Colors.transparent,
                  ),*/
                  ListTile(
                    onTap: () {
                      /*setState(() {
                      selectedTitle="Logout";
                      selectedPosition=9;
                    });*/
                      _advancedDrawerController.hideDrawer();
                      _showAlertDialog();
                    },
                    leading: Icon(Icons.login_outlined),
                    title: Text('Logout'),
                    tileColor: selectedPosition==7?AppTheme.orangeColor:Colors.transparent,
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
  );
  }
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
  Widget getScreens(){
    _advancedDrawerController.hideDrawer();

    switch(selectedPosition){
      case 0:
          return DashboardScreen();
      case 1:
        return Container();
      case 2:
        return AttendanceManagementScreen();
      case 3:
        return TaskBoxScreen();
     /* case 4:
        return ProfileScreen();
        case 5:
        return RequestPayslip();*/
      /*case 6:
        return HrDashboardScreen();*/
      /*case 5:
        return SaparationScreen();
      case 6:
        return Container();
      case 7:
        return Container();
      case 8:
        return Container();
      case 9:
        return Container();*/
      case 7:
        return Container();
    }
    return Container();
  }
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _getDashboardData();
    });

  }
  _getDashboardData() async {
    fullNameStr=await MyUtils.getSharedPreferences("full_name")??"";
    empId=await MyUtils.getSharedPreferences("emp_id")??"";
    clientCode=await MyUtils.getSharedPreferences("client_code")??"";
    baseUrl=await MyUtils.getSharedPreferences("base_url")??"";
    token=await MyUtils.getSharedPreferences("token")??"";
    if(Platform.isAndroid){
      platform="Android";
    }else if(Platform.isIOS){
      platform="iOS";
    }else{
      platform="Other";
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    currentVersionName = packageInfo.version;
    currentVersionCode = packageInfo.buildNumber;

    print(appName);
    print(packageName);
    print(currentVersionName);
    print(currentVersionCode);
    setState(() {
    });

    getAppUpdateDetails();
    updateVersionOnServer();

  }


  logOutServer(BuildContext context) async {
    String? authKey = await MyUtils.getSharedPreferences("access_token");
    String? userID = await MyUtils.getSharedPreferences("user_id_libas");
    var data = {"auth_key": authKey.toString(), "user_id": userID};
    print(data);

    libas.ApiBaseHelper helper = libas.ApiBaseHelper();
    var response = await helper.postAPI('logout', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
  }





  _logOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
  }
  _showAlertDialog(){
    showDialog(context: context, builder: (ctx)=> AlertDialog(
      title: const Text("Logout",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 18),),
      content: const Text("Are you sure you want to Logout ?",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16,color: Colors.black),),
      actions: <Widget>[
        TextButton(
            onPressed: (){
              Navigator.of(ctx).pop();
              logOutServer(context);
              _logOut(context);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.themeColor,
              ),
              height: 45,
              padding: const EdgeInsets.all(10),
              child: const Center(child: Text("Logout",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
            )
        ),
        TextButton(
            onPressed: (){
              Navigator.of(ctx).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.greyColor,
              ),
              height: 45,
              padding: const EdgeInsets.all(10),
              child: const Center(child: Text("Cancel",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
            )
        )
      ],
    ));
  }
  _showAppUpdateDialog(String nextVersion,int forceUpdate){


    showDialog(context: context,
        barrierDismissible: false,
        builder: (ctx)=> PopScope(canPop: false, child: AlertDialog(
          title: const Text("Update Available",style: TextStyle(fontWeight: FontWeight.bold,color: AppTheme.themeColor,fontSize: 18),),
          content:Container(
            height: 220,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: Lottie.asset("assets/splash_loader.json"),
                  ),
                ),
                SizedBox(height: 10,),
                Text("App Update version $nextVersion is available for download. Please update your App.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16,color: Colors.black),)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: (){
                  Navigator.of(ctx).pop();
                  _redirectToStore();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.themeColor,
                  ),
                  height: 45,
                  padding: const EdgeInsets.all(10),
                  child: const Center(child: Text("Update",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
                )
            ),

            forceUpdate==1 ?SizedBox(height: 1)
                :TextButton(
                onPressed: (){
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.greyColor,
                  ),
                  height: 45,
                  padding: const EdgeInsets.all(10),
                  child: const Center(child: Text("Skip",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
                )
            )
          ],
        )));
  }
  getAppUpdateDetails() async{
    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithBase("https://glueple.com:3001/","rest_api/get-global-app-settings?client_code=$clientCode", context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {

      List<dynamic>dataList=responseJSON['data'];
      if(dataList.isNotEmpty){
        String nextVersionCode="0";
        String nextVersionName="0.0.0";
        int forceUpdate=0;

        if(platform=="Android"){
          if(dataList[0]['curr_android_app_build_num']!=null){
            nextVersionCode=dataList[0]['curr_android_app_build_num'];
          }
          if(dataList[0]['curr_android_app_version']!=null){
            nextVersionName=dataList[0]['curr_android_app_version'];
          }
        }
        else if(platform=="iOS"){
          if(dataList[0]['curr_ios_app_build_num']!=null){
            nextVersionCode=dataList[0]['curr_ios_app_build_num'];
          }
          if(dataList[0]['curr_ios_app_version']!=null){
            nextVersionName=dataList[0]['curr_ios_app_version'];
          }
        }

        if(dataList[0]['is_force_update']!=null){
          forceUpdate=dataList[0]['is_force_update'];
        }


        int nextVersion=int.parse(nextVersionCode);
        int currentVersion=int.parse(currentVersionCode);
        if(nextVersion>currentVersion){
          _showAppUpdateDialog(nextVersionName,forceUpdate);
        }
      }




    }

  }
  updateVersionOnServer() async{
    ApiBaseHelper helper= ApiBaseHelper();
    var requestModel = {
      "installed_app_version": currentVersionName,
      "app_platform":platform,
      "fcm_token":"",
    };
    var response=await helper.postAPIWithHeader(baseUrl,"rest_api/update-user-app-info",requestModel, context,token);
    var responseJSON = json.decode(response.body);
    print("Update Info API Response :$responseJSON");
  }
  _redirectToStore(){
    if(Platform.isAndroid)
    {
      launchUrl(
        Uri.parse('https://play.google.com/store/apps/details?id=com.qdegrees.glueple_flutter'),
        mode: LaunchMode.externalApplication,
      );
    }
    else
    {
      launchUrl(
        Uri.parse('https://apps.apple.com/app/buildstorey/id6470981687'),
        mode: LaunchMode.externalApplication,
      );
    }
  }
}

