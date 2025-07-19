import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ChecklistTree/network/Utils.dart';
import 'package:ChecklistTree/network/loader.dart';
import 'package:ChecklistTree/views/login_screen.dart';
import 'package:ChecklistTree/views/store/drafted_task.dart';
//import 'package:gluple_libas/views/login_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../utils/app_theme.dart';
import 'incomplete_tasks_screen.dart';
import '../mcq/test_mcq1.dart';
import 'notification_screen.dart';

class StoreDashboardScreen extends StatefulWidget {
  StoreState createState() => StoreState();
}

class StoreState extends State<StoreDashboardScreen> {
  bool isLoading = false;
  String pendingTasks = "";
  String completedTasks = "";
  String draftTasks = "";
  String userName = "";
  String userTitle = "";
  List<dynamic> taskList = [];
  List<String> filterList=[
    "Today",
    "Last 7 days",
    "MTD",
    "All"
  ];

  int selectedFilterIndex=0;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 66,
        backgroundColor: AppTheme.orangeColor,
        // leading: Image.asset('yourImage'), // you can put Icon as well, it accepts any widget.
        title: Text("Dashboard",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            )),
        actions: [


          GestureDetector(
              onTap: (){

                fetchDashboardData(context);
                fetchDraftedData(context);

              },

              child: Icon(Icons.refresh,color: Colors.white)),

          SizedBox(width: 12),

          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()));
              },
              child: Image.asset("assets/bell_ic.png",
                  width: 23, height: 23, color: Colors.white)),
          SizedBox(width: 12),
          GestureDetector(
              onTap: (){
                _logOut(context);
              },

              child: Icon(Icons.login, color: Colors.white)),
          SizedBox(width: 12),
        ],
      ),
      body: isLoading
          ? Center(
              child: Loader(),
            )
          : ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              )),
                          SizedBox(height: 2),
                          Text(userName,
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.orangeColor,
                              )),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 73,
                            height: 73,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage("assets/libas.png"))),
                            /*  child: Center(
                        child:   Text (userTitle,style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )),
                      ),*/
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text("0",
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.orangeColor,
                                  )),
                              SizedBox(width: 5),
                              Icon(Icons.star, color: AppTheme.orangeColor),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 13),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text("Overall Task Report",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          )),
                    ),

                    Spacer(),

                    InkWell(
                        onTap: () {
                          selectCategoryBottomSheet(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 13),
                          child: Image.asset(
                            "assets/filter_ic.png",
                            width: 38,
                            height: 38,

                          ),
                        ))


                  ],
                ),
                SizedBox(height: 16),



                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IncompleteTasksScreen("1")),
                              ).then((value) {

                                fetchDashboardData(context);
                                fetchDraftedData(context);




                              });
                            },
                            child: Card(
                              margin: EdgeInsets.only(left: 7),
                              color: Color(0xFfF9F9F9),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                height: 105,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  //color: Color(0xFfF9F9F9),
                                ),
                                //  height: 101,
                                width: 180,
                                child: Stack(
                                  //  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      transform: Matrix4.translationValues(
                                          10.0, -20.0, 0.0),
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: Image.asset(
                                              "assets/tiles_1.png",
                                              width: 83,
                                              height: 99)),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 15),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 15),
                                          child: Text('Completed Task',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              )),
                                        ),
                                        SizedBox(height: 10),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 15),
                                          child: Text(completedTasks,
                                              style: TextStyle(
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          flex: 1),

                      SizedBox(width: 18),

                      Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IncompleteTasksScreen("1")),
                              ).then((value) {
                                fetchDashboardData(context);
                                fetchDraftedData(context);
                              });
                            },
                            child: Card(
                              margin: EdgeInsets.only(left: 7),
                              color: Color(0xFfF9F9F9),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                height: 105,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  //color: Color(0xFfF9F9F9),
                                ),
                                //  height: 101,
                                width: 180,
                                child: Stack(
                                  //  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      transform:
                                      Matrix4.translationValues(
                                          0.0, -10.0, 0.0),
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: Image.asset("assets/mask.png",
                                              width: 83, height: 99)),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 15),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 15),
                                          child: Text('Expired Task',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              )),
                                        ),
                                        SizedBox(height: 10),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 15),
                                          child: Text(pendingTasks,
                                              style: TextStyle(
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          flex: 1),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DraftedTasksScreen()));
                            },
                            child: Card(
                              margin: EdgeInsets.only(left: 7),
                              color: Color(0xFfF9F9F9),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                height: 105,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  //color: Color(0xFfF9F9F9),
                                ),
                                //  height: 101,
                                width: 180,
                                child: Stack(
                                  //  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      transform: Matrix4.translationValues(
                                          10.0, -18.0, 0.0),
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: Image.asset(
                                              "assets/tiles_2.png",
                                              width: 83,
                                              height: 99)),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 20),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 15),
                                                  child: Text('Drafted Task',
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        color: Colors.black,
                                                      )),
                                                ),
                                                SizedBox(height: 10),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 15),
                                                  child: Text(draftTasks,
                                                      style: TextStyle(
                                                        fontSize: 22.0,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.blue,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          flex: 1),

                      /*Expanded(
                  flex:1,
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>DraftedTasksScreen()));

                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),

                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Image.asset("assets/ic_drafted_task.PNG",width: 30,height: 30,color: AppTheme.orangeColor),

                                SizedBox(width: 7),

                                Text (draftTasks,style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                )),


                              ],
                            ),

                            SizedBox(height: 19),


                            Text ("Drafted Task",style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            )),

                            SizedBox(height: 10),
                          ],
                        ),
                      ),




                    ),
                  ),
                ),*/
                    ],
                  ),
                ),
                SizedBox(height: 20),



                Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child: Text("Today Task List",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      )),
                ),
                SizedBox(height: 10),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: taskList.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int pos) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {

                              if(taskList[pos]["task_status"].toString() == "1")
                              {
                                Toast.show(
                                    "Task is already completed!",
                                    duration: Toast.lengthLong,
                                    gravity: Toast.bottom,
                                    backgroundColor: Colors.blue);
                              }

                              else if(DateTime.parse(taskList[pos]["end_date_time"]).isBefore(DateTime.now()))
                              {
                                Toast.show(
                                    "Sorry this task has been expired! ",
                                    duration: Toast.lengthLong,
                                    gravity: Toast.bottom,
                                    backgroundColor: Colors.red);
                              }






                              //  Navigator.push(context, MaterialPageRoute(builder: (context)=>MCQTest1Screen(taskList[pos]["task_detail"]["task_id"].toString(),taskList[pos]["id"].toString(),false)));

                              else if (taskList[pos]["task_status"].toString() != "1") {
                                DateTime currentDate = DateTime.now();

                                DateTime dt1 = DateTime.parse(
                                    taskList[pos]["start_date_time"]);
                                DateTime dt2 =
                                DateTime.parse(taskList[pos]["end_date_time"]);

                                print(dt1.toString());
                                print(dt2.toString());

                                //  dt1 = DateTime(currentDate.year, currentDate.month, currentDate.day, dt1.hour, dt1.minute);
                                //  dt2 = DateTime(currentDate.year, currentDate.month, currentDate.day, dt2.hour, dt2.minute);

                                if (DateTime.now().isAfter(dt1) &&
                                    DateTime.now().isBefore(dt2)) {


                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MCQTest1Screen(
                                                taskList[pos]["task_detail"]
                                                ["task_id"]
                                                    .toString(),
                                                taskList[pos]["id"]
                                                    .toString(),
                                                false)),
                                  ).then((value) {

                                    fetchDashboardData(context);
                                    fetchDraftedData(context);
                                  });


                                } else {
                                  Toast.show(
                                      "You can complete this between " +
                                          parseServerFormatDate(taskList[pos]
                                          ["start_date_time"]
                                              .toString()) +
                                          " to " +
                                          parseServerFormatDate(taskList[pos]
                                          ["end_date_time"]
                                              .toString()),
                                      duration: Toast.lengthLong,
                                      gravity: Toast.bottom,
                                      backgroundColor: Colors.red);
                                }
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 13),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueGrey.withOpacity(0.4),
                                    // Color of the shadow
                                    spreadRadius: 1,
                                    // Spread radius of the shadow
                                    blurRadius: 7,
                                    // Blur radius of the shadow
                                    offset: Offset(0, 0), // Offset of the shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(taskList[pos]["task_name"],
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blueGrey,
                                            )),
                                        SizedBox(height: 5),
                                        Text(
                                            "Repetition: " +
                                                getTaskRepeatName(taskList[pos]
                                                ["task_detail"]
                                                ["task_repetation"]
                                                    .toString()),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                        taskList[pos]["task_detail"]["remark"] ==
                                            null
                                            ? Container()
                                            : SizedBox(height: 5),
                                        taskList[pos]["task_detail"]["remark"] ==
                                            null
                                            ? Container()
                                            : Text(
                                            "Remark: " +
                                                taskList[pos]["task_detail"]
                                                ["remark"]
                                                    .toString(),
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            )),
                                        SizedBox(height: 10),
                                        Text(
                                            parseServerFormatDate(taskList[pos]
                                            ["start_date_time"]
                                                .toString()) +
                                                " - " +
                                                parseServerFormatDate(taskList[pos]
                                                ["end_date_time"]
                                                    .toString()),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: AppTheme.orangeColor,
                                            )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child:
                                    taskList[pos]["task_status"].toString() ==
                                        "1"
                                        ? Icon(Icons.check_circle,
                                        color: Colors.green)
                                        :

                                    DateTime.parse(taskList[pos]["end_date_time"]).isBefore(DateTime.now())?

                                    Image.asset(
                                      "assets/cross2.png",
                                      width: 25,
                                      height: 25,
                                    ):



                                    Image.asset(
                                      "assets/ic_task_pending.PNG",
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 17),
                        ],
                      );
                    })
              ],
            ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDashboardData(context);
    fetchDraftedData(context);
  }

  String parseServerFormatDate(String serverDate) {
    var date = DateTime.parse(serverDate);
    final dateformat = DateFormat.jm();
    final clockString = dateformat.format(date);
    return clockString.toString();
  }

  fetchDashboardData(BuildContext context) async {
    String? authKey = await MyUtils.getSharedPreferences("access_token");
    setState(() {
      isLoading = true;
    });
    String type="1";

    if(selectedFilterIndex==0)
      {
        type="1";
      }
    else if(selectedFilterIndex==1)
      {
        type="2";
      }
    else if(selectedFilterIndex==2)
      {
        type="3";
      }
    else if(selectedFilterIndex==3)
      {
        type="4";
      }


    var data = {"auth_key": authKey.toString(),"type":type};
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('home_page', data, context);
    var responseJSON = json.decode(response.body);
    setState(() {
      isLoading = false;
    });

    pendingTasks = responseJSON["totalPandingTask"].toString();
    completedTasks = responseJSON["totalTask"].toString();
    userName = responseJSON["userName"];
    taskList = responseJSON["allTasks"];

    List<String> nameList = userName.toString().split(" ");

    if (nameList.length > 1) {
      String fName = nameList[0][0].toUpperCase();
      String lName = nameList[1][0].toUpperCase();
      userTitle = fName + lName;
    }

    print(responseJSON);
  }

  String getTaskRepeatName(String repeat) {
    String type = "";

    if (!repeat.isEmpty && repeat != "null") {
      List<String> repeatList = repeat.split(",");
      String rep = repeatList[0];
      if (rep == "1") {
        type = "Daily";
      } else if (rep == "2") {
        type = "Alternate";
      }
      if (rep == "3") {
        type = "Weekly";
      }
    }

    return type;
  }

  fetchDraftedData(BuildContext context) async {
    String? authKey = await MyUtils.getSharedPreferences("access_token");
    setState(() {
      isLoading = true;
    });
    var data = {"auth_key": authKey.toString()};
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('saved_draft_listing', data, context);
    var responseJSON = json.decode(response.body);
    setState(() {
      isLoading = false;
    });

    draftTasks = responseJSON["draftTask"].length.toString();
    setState(() {});

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



  void selectCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context,bottomSheetState)
        {
          return Container(
            padding: EdgeInsets.all(10),
            // height: 600,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)), // Set the corner radius here
              color: Colors.white, // Example color for the container
            ),
            child:Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),

                Center(
                  child: Container(
                    height: 6,
                    width: 62,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),

                SizedBox(height: 10),

                Row(


                  children: [
                    SizedBox(width: 10),

                    Text("Filter",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        )),

                    Spacer(),

                    GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Image.asset("assets/cross_ic.png",width: 38,height: 38)),
                    SizedBox(width: 4),
                  ],
                ),

                ListView.builder(
                    shrinkWrap: true,
                    itemCount: filterList.length,
                    itemBuilder: (BuildContext context,int pos)
                    {
                      return InkWell(
                        onTap: (){
                          bottomSheetState(() {
                            selectedFilterIndex=pos;
                          });
                        },
                        child: Container(
                          height: 57,
                          color: selectedFilterIndex==pos?Color(0xFFFF7C00).withOpacity(0.10):Colors.white,
                          child: Row(
                            children: [

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Text(filterList[pos],
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      );
                    }


                ),

                SizedBox(height: 15),


                Card(
                  elevation: 4,
                  shadowColor:Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 53,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(
                              Colors.white), // background
                          backgroundColor:
                          MaterialStateProperty.all<Color>(
                              AppTheme.themeColor), // fore
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ))),
                      onPressed: () {

                        Navigator.pop(context);
                        fetchDashboardData(context);

                      },
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),


                SizedBox(height: 15),



              ],
            ),
          );
        }

        );

      },
    );
  }
}
