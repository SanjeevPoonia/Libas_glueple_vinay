import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ChecklistTree/views/gluple/attendance/attendance_managment.dart';
import 'package:ChecklistTree/views/gluple/utils/app_theme.dart';
import 'package:ChecklistTree/views/gluple/views/Taskbox_Screen.dart';
import 'package:ChecklistTree/views/gluple/views/dashboard_screen.dart';

class HomeScreen extends StatefulWidget{
  _homeScreen createState()=> _homeScreen();
}
class _homeScreen extends State<HomeScreen>{
  int pageIndex = 0;

  final pages = [
    DashboardScreen(),
    TaskBoxScreen(),
    AttendanceManagementScreen(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.white,
     body: pages[pageIndex],
     bottomNavigationBar: buildMyNavBar(context),
   );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppTheme.bottomNav,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          InkWell(
            onTap: (){
              setState(() {
                pageIndex = 0;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/btm_home.svg",width: 30,height: 30,color:pageIndex == 0?AppTheme.orangeColor:Colors.grey,),
                SizedBox(height: 5,),
                Text("Home",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10,color: pageIndex==0?AppTheme.orangeColor:Colors.grey),)
              ],
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                pageIndex = 1;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/btm_taskbox.svg",width: 30,height: 30,color:pageIndex == 1?AppTheme.orangeColor:Colors.grey,),
                SizedBox(height: 5,),
                Text("Taskbox",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10,color: pageIndex==1?AppTheme.orangeColor:Colors.grey),)
              ],
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                pageIndex = 2;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/btm_attendance.svg",width: 30,height: 30,color:pageIndex == 2?AppTheme.orangeColor:Colors.grey,),
                SizedBox(height: 5,),
                Text("Attendance",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10,color: pageIndex==2?AppTheme.orangeColor:Colors.grey),)
              ],
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                pageIndex = 3;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/btm_profile.svg",width: 30,height: 30,color:pageIndex == 3?AppTheme.orangeColor:Colors.grey,),
                SizedBox(height: 5,),
                Text("Profile",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10,color: pageIndex==3?AppTheme.orangeColor:Colors.grey),)
              ],
            ),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 5),
    );
  }



}