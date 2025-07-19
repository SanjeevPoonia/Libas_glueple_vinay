import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import '../../utils/app_theme.dart';
import 'manager_dashboard.dart';
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
                  ListTile(
                    onTap: () {
                      setState(() {
                        selectedTitle="Task Box";
                        selectedPosition=1;
                      });
                    },
                    leading: Icon(Icons.task_outlined),
                    title: Text('Task Box'),
                    tileColor: selectedPosition==1?AppTheme.orangeColor:Colors.transparent,
                  ),
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
                        selectedTitle="Team Attendance";
                        selectedPosition=3;
                      });
                    },
                    leading: Icon(Icons.groups_3_outlined),
                    title: Text('Team Attendance'),
                    tileColor: selectedPosition==3?AppTheme.orangeColor:Colors.transparent,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        selectedTitle="Profile";
                        selectedPosition=4;
                      });
                    },
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                    tileColor: selectedPosition==4?AppTheme.orangeColor:Colors.transparent,
                  ),

                  ListTile(
                    onTap: () {
                      setState(() {
                        selectedTitle="Request Payslip";
                        selectedPosition=5;
                      });
                    },
                    leading: Icon(Icons.money_outlined),
                    title: Text('Payslip'),
                    tileColor: selectedPosition==5?AppTheme.orangeColor:Colors.transparent,
                  ),

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
        return ManagerDashboardScreen();
      case 1:
        return Container();
      case 2:
        return Container();
      case 3:
        return Container();
      case 4:
        return Container();
      case 5:
        return Container();
      case 6:
        return Container();
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



  }

  _showAlertDialog(){
    showDialog(context: context, builder: (ctx)=> AlertDialog(
      title: const Text("Logout",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 18),),
      content: const Text("Are you sure you want to Logout ?",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16,color: Colors.black),),
      actions: <Widget>[
        TextButton(
            onPressed: (){
              Navigator.of(ctx).pop();
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


}

