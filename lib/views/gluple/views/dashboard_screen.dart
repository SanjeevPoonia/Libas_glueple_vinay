import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ChecklistTree/network/api_helper.dart' as libas;
import 'package:ChecklistTree/views/gluple/attendance/applied_leaves_screen.dart';
import 'package:ChecklistTree/views/gluple/mh_attendance/mh_attendance_details_screen.dart';
import 'package:ChecklistTree/views/gluple/network/Utils.dart';
import 'package:ChecklistTree/views/gluple/network/loader.dart';
import 'package:ChecklistTree/views/gluple/task_manegment/addtask_screen.dart';
import 'package:ChecklistTree/views/gluple/task_manegment/alltask_screen.dart';
import 'package:ChecklistTree/views/gluple/task_manegment/taskdetails_screen.dart';
import 'package:ChecklistTree/views/gluple/utils/attendance_series.dart';
import 'package:ChecklistTree/views/gluple/views/AnnouncementScreen.dart';
import 'package:ChecklistTree/views/gluple/views/MarkAttendanceScreen.dart';
import 'package:ChecklistTree/views/gluple/views/attendance_chart.dart';
import '../../login_screen.dart';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../../manager/add_task_screen.dart';
import '../../mcq/test_mcq1.dart';
import '../../store/drafted_task.dart';
import '../../store/incomplete_tasks_screen.dart';
import '../libas_demo/libas_check_in.dart';
import '../libas_demo/libas_check_out.dart';
import '../mh_attendance/mh_apply_leave_screen.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import 'package:intl/intl.dart';
import 'applyleave_screen.dart';
import 'applyleave_screen_ub.dart';
import 'attendance_details_screen.dart';
import 'package:camera/camera.dart';

import 'capture_image.dart';

class DashboardScreen extends StatefulWidget {
  dashboardState createState() => dashboardState();
}

class dashboardState extends State<DashboardScreen> {
  bool childLoading = false;
  String pendingTasks = "";
  String completedTasks = "";
  String draftTasks = "";
  String userName = "";
  List<String> filterList = ["Today", "Last 7 days", "MTD", "All"];

  int selectedFilterIndex = 0;

  String userTitle = "";
  List<dynamic> taskList = [];
  var userIdStr = "";
  var designationStr = "";
  var token = "";
  var fullNameStr = "";
  var empId = "";
  var baseUrl = "";
  var clientCode = "";
  var platform = "";
  var isAttendanceAccess = "1";
  bool isLoading = false;
  bool attStatus = false;
  bool lastAttendance = false;
  bool taskLoading = false;
  bool leaveLoading = false;
  bool communityLoading = false;
  List<AttendanceSeries> attendanceDate = [];
  XFile? image;
  XFile? imageFile;
  File? file;
  XFile? capturedImage;
  File? capturedFile;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );
  bool showCheckIn = true;
  String logedInTime = "00:00:00";
  Position? _currentPosition;
  String? _currentAddress;
  String lastImage = "";
  List<dynamic> locationList = [];
  Timer? countdownTimer;
  Duration? myDuration;

  /*********Today task************/
  List<dynamic> totakTaskList = [];
  List RandomImages = [
    'https://images.unsplash.com/photo-1597223557154-721c1cecc4b0?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8aHVtYW4lMjBmYWNlfGVufDB8fDB8fA%3D%3D&w=1000&q=80',
    'https://img.freepik.com/free-photo/portrait-white-man-isolated_53876-40306.jpg',
    'https://images.unsplash.com/photo-1542909168-82c3e7fdca5c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8ZmFjZXxlbnwwfHwwfHw%3D&w=1000&q=80',
    'https://i0.wp.com/post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/03/GettyImages-1092658864_hero-1024x575.jpg?w=1155&h=1528'
  ];

  /*********Leave List*****************/
  List<dynamic> leaveList = [];
  List<dynamic> totalLeaveList = [];

  /******Announcement List***************/
  List<dynamic> announcementList = [];

  /****************Camera Functionality*****************/
  double cameraZoom = 1.0;
  CameraController? controller;
  CameraDescription? camera;
  List<CameraDescription> cameras = [];
  XFile? cameraImageFile;
  bool noData = false;

  /**********Upload File IN Background*****************/
  bool isImageUploading = false;

  /****************User Notification*********************/
  bool isNotiLoading = false;
  String notiStr = "";

  /************Custom range for Location *****************/
  int locationRadius = 501;
  int announcementSize = 0;
  int taskSize = 0;
  int leaveSize = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return ListView(
      children: [
        isNotiLoading
            ? Center(child: Loader())
            : notiStr == ''
                ? SizedBox(height: 2)
                : Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/announc_back_img.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 7, right: 10),
                      child: Marquee(
                        text: notiStr,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 20,
                        velocity: 100,
                        pauseAfterRound: Duration(seconds: 1),
                        startPadding: 10,
                        accelerationDuration: Duration(seconds: 1),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    height: 40,
                  ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(color: AppTheme.dashboardheader),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isImageUploading
                    ? Center(
                        child: Loader(),
                      )
                    : lastImage == ""
                        ? CircleAvatar(
                            backgroundImage: AssetImage("assets/profile.png"),
                            radius: 35,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(33.0),
                            child: imageFromBase64String(lastImage),
                          ),
                SizedBox(
                  width: 7,
                ),
                Expanded(
                    child: Column(
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
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      empId,
                      style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ],
                )),
                SizedBox(
                  width: 7,
                ),
                attStatus
                    ? Loader()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$logedInTime Hrs",
                            style: TextStyle(
                                fontSize: 17.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          isAttendanceAccess == "1"
                              ? InkWell(
                                  onTap: () {
                                    _getCurrentPosition();
                                  },
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: AppTheme.orangeColor),
                                    height: 30,
                                    child: Center(
                                      child: Text(
                                          showCheckIn == true
                                              ? "Check In"
                                              : "Check Out",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ),
                                  ),
                                )
                              : SizedBox(height: 1)
                        ],
                      )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(color: AppTheme.filterColor),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Last 7 Days Report",
                      style: TextStyle(
                          color: AppTheme.themeColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 17.5),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () => {
                        clientCode == 'MH100'
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MH_AttendanceDetailsScreen()),
                              ).then((value) => _getDashboardData())
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AttendanceDetailsScreen()),
                              ).then((value) => _getDashboardData())
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                            color: AppTheme.orangeColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.5),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(color: AppTheme.at_green),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Full Day",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        )
                      ],
                    )),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppTheme.at_blue,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Half Day",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        )
                      ],
                    )),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppTheme.at_yellow,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Leave",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        )
                      ],
                    )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppTheme.at_lightgray,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Public Holiday",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        )
                      ],
                    )),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppTheme.at_gray,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Week Off",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        )
                      ],
                    )),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppTheme.at_red,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Absent",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black),
                            )
                          ],
                        )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [

                    Expanded(
                        child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppTheme.at_black,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Tour",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        )
                      ],
                    )),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(color: AppTheme.filterColor),
                  child: lastAttendance
                      ? Center(
                          child: Loader(),
                        )
                      : AttendanceChart(data: attendanceDate),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("Overall Task Report",
                  style: TextStyle(
                    fontSize: 15,
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
        SizedBox(height: 15),
        childLoading
            ? Container(height: 150, child: Center(child: Loader()))
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
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
                                              padding: const EdgeInsets.only(
                                                  left: 15),
                                              child: Text('Completed Task',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  )),
                                            ),
                                            SizedBox(height: 10),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15),
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
                              )),
                          SizedBox(width: 18),
                          Expanded(
                              child: InkWell(
                                onTap: () {


                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            IncompleteTasksScreen("0")),
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
                                              0.0, -10.0, 0.0),
                                          child: Align(
                                              alignment: Alignment.topRight,
                                              child: Image.asset(
                                                  "assets/mask.png",
                                                  width: 83,
                                                  height: 99)),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 15),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15),
                                              child: Text('Expired Task',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  )),
                                            ),
                                            SizedBox(height: 10),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15),
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
                                        DraftedTasksScreen()),
                                  ).then((value) {

                                    print("Click Triggered");

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
                                                      child: Text(
                                                          'Drafted Task',
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
                  ],
                ),
              ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("Today Task List",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  )),
            ),
            Spacer(),

            /* GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTaskScreen()));
                },

                child: Icon(Icons.add_circle,color: AppTheme.orangeColor)),
*/

            SizedBox(width: 15)
          ],
        ),
        SizedBox(height: 10),
        !isLoading && taskList.length == 0
            ? Container(
                height: 100,
                child: Center(
                  child: Text("No tasks found!"),
                ))
            : ListView.builder(
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
    );
  }

  void selectCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, bottomSheetState) {
          return Container(
            padding: EdgeInsets.all(10),
            // height: 600,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              // Set the corner radius here
              color: Colors.white, // Example color for the container
            ),
            child: Column(
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
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset("assets/cross_ic.png",
                            width: 38, height: 38)),
                    SizedBox(width: 4),
                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: filterList.length,
                    itemBuilder: (BuildContext context, int pos) {
                      return InkWell(
                        onTap: () {
                          bottomSheetState(() {
                            selectedFilterIndex = pos;
                          });
                        },
                        child: Container(
                          height: 57,
                          color: selectedFilterIndex == pos
                              ? Color(0xFFFF7C00).withOpacity(0.10)
                              : Colors.white,
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
                    }),
                SizedBox(height: 15),
                Card(
                  elevation: 4,
                  shadowColor: Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 53,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // background
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppTheme.themeColor), // fore
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
        });
      },
    );
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
      childLoading = true;
    });
    String type = "1";

    if (selectedFilterIndex == 0) {
      type = "1";
    } else if (selectedFilterIndex == 1) {
      type = "2";
    } else if (selectedFilterIndex == 2) {
      type = "3";
    } else if (selectedFilterIndex == 3) {
      type = "4";
    }

    var data = {"auth_key": authKey.toString(), "type": type};
    print(data);

    libas.ApiBaseHelper helper = libas.ApiBaseHelper();
    var response = await helper.postAPI('home_page', data, context);
    var responseJSON = json.decode(response.body);
    setState(() {
      childLoading = false;
    });

    pendingTasks = responseJSON["totalPandingTask"].toString();
    completedTasks = responseJSON["totalTask"].toString();
    userName = responseJSON["userName"];
    taskList = responseJSON["allTasks"];
    taskList=taskList.reversed.toList();

/*    List<String> nameList = userName.toString().split(" ");

    if (nameList.length > 1) {
      String fName = nameList[0][0].toUpperCase();
      String lName = nameList[1][0].toUpperCase();
      userTitle = fName + lName;
    }*/

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

    libas.ApiBaseHelper helper = libas.ApiBaseHelper();
    var response = await helper.postAPI('saved_draft_listing', data, context);
    var responseJSON = json.decode(response.body);
    setState(() {
      isLoading = false;
    });

    draftTasks = responseJSON["draftTask"].length.toString();

    print("DRAFT DATA");

    log(draftTasks.toString());

    setState(() {});

    print(responseJSON);
  }

  _showAlertDialog() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text(
                "Logout",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 18),
              ),
              content: const Text(
                "Are you sure you want to Logout ?",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                    color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _logOut(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppTheme.themeColor,
                      ),
                      height: 45,
                      padding: const EdgeInsets.all(10),
                      child: const Center(
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white),
                        ),
                      ),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppTheme.greyColor,
                      ),
                      height: 45,
                      padding: const EdgeInsets.all(10),
                      child: const Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white),
                        ),
                      ),
                    ))
              ],
            ));
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

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _getDashboardData();
      fetchDraftedData(context);
      fetchDashboardData(context);
    });
  }

  _getDashboardData() async {
    setState(() {
      isLoading = true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    userIdStr = await MyUtils.getSharedPreferences("user_id") ?? "";
    fullNameStr = await MyUtils.getSharedPreferences("full_name") ?? "";
    token = await MyUtils.getSharedPreferences("token") ?? "";
    designationStr = await MyUtils.getSharedPreferences("designation") ?? "";
    empId = await MyUtils.getSharedPreferences("emp_id") ?? "";
    baseUrl = await MyUtils.getSharedPreferences("base_url") ?? "";
    clientCode = await MyUtils.getSharedPreferences("client_code") ?? "";
    String? access = await MyUtils.getSharedPreferences("at_access") ?? '1';
    isAttendanceAccess = access;

    if (Platform.isAndroid) {
      platform = "Android";
    } else if (Platform.isIOS) {
      platform = "iOS";
    } else {
      platform = "Other";
    }

    print("userId:-" + userIdStr.toString());
    print("token:-" + token.toString());
    print("employee_id:-" + empId.toString());
    print("Base Url:-" + baseUrl.toString());
    print("Platform:-" + platform);
    print("Client Code:-" + clientCode);

    Navigator.of(context).pop();

    getAttendanceDetails();
    _getLastAttendance();
    getLocationList();
    //  getTaskList();
    getLeaves();
    // getAnnouncements();
    if (clientCode == 'QD100') {
      getCorrectionNotification();
    }
  }

  imageSelector(BuildContext context) async {
    imageFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 60,
        preferredCameraDevice: CameraDevice.front);

    if (imageFile != null) {
      file = File(imageFile!.path);

      final imageFiles = imageFile;
      if (imageFiles != null) {
        print("You selected  image : " + imageFiles.path.toString());
        setState(() {
          debugPrint("SELECTED IMAGE PICK   $imageFiles");
        });
        _faceDetection();
      } else {
        print("You have not taken image");
      }
    } else {
      Toast.show("Unable to capture Image. Please try Again...",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  _faceFromCamera() async {
    APIDialog.showAlertDialog(context, "Detecting Face....");
    final image = InputImage.fromFile(capturedFile!);
    final faces = await _faceDetector.processImage(image);
    print("faces in image ${faces.length}");
    Navigator.pop(context);
    if (faces.isNotEmpty) {
      // _showImageDialog();
      _showCameraImageDialog();
    } else {
      Toast.show(
          "Face not detected in captured image. Please capture a selfie.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _showFaceErrorCustomDialog();
    }
  }

  _faceDetection() async {
    APIDialog.showAlertDialog(context, "Detecting Face....");

    final image = InputImage.fromFile(file!);
    final faces = await _faceDetector.processImage(image);
    print("faces in image ${faces.length}");
    Navigator.pop(context);
    if (faces.isNotEmpty) {
      _showImageDialog();
    } else {
      Toast.show(
          "Face not detected in captured image. Please capture a selfie.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _showFaceErrorCustomDialog();
    }
  }

  _showCameraImageDialog() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: const Text(
                  "Mark Attendance",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 18),
                ),
                content: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: FileImage(capturedFile!), fit: BoxFit.cover),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        // markAttendance();
                        //markAttendanceFromCamera();
                        markOnlyAttendance("camera");
                        //call attendance punch in or out
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppTheme.themeColor,
                        ),
                        height: 45,
                        padding: const EdgeInsets.all(10),
                        child: const Center(
                          child: Text(
                            "Mark",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        ),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppTheme.greyColor,
                        ),
                        height: 45,
                        padding: const EdgeInsets.all(10),
                        child: const Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        ),
                      ))
                ]));
  }

  _showImageDialog() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: const Text(
                  "Mark Attendance",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 18),
                ),
                content: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: FileImage(file!), fit: BoxFit.cover),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        // markAttendance();
                        markOnlyAttendance("iOS");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppTheme.themeColor,
                        ),
                        height: 45,
                        padding: const EdgeInsets.all(10),
                        child: const Center(
                          child: Text(
                            "Mark",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        ),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppTheme.greyColor,
                        ),
                        height: 45,
                        padding: const EdgeInsets.all(10),
                        child: const Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        ),
                      ))
                ]));
  }

  getAttendanceDetails() async {
    setState(() {
      attStatus = true;
    });
    //APIDialog.showAlertDialog(context, 'Please Wait...');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url') ?? '';
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl,
        'attendance_management/attendanceBasicDetails', token, context);
    //Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      String sAttendanceTypeServer = responseJSON['data']
              ['attendance_basic_details']['attendance_type']
          .toString();
      if (sAttendanceTypeServer == "attendance") {
        String last_check_status = responseJSON['data']
                ['attendance_basic_details']['last_check_status']
            .toString();
        String lastImg = responseJSON['data']['attendance_basic_details']
                ['last_check_capture']
            .toString();
        if (last_check_status == "null") {
          logedInTime = "00:00:00";
          showCheckIn = true;
        } else if (last_check_status == "in") {
          showCheckIn = false;
          logedInTime = responseJSON['data']['attendance_basic_details']
                  ['total_time']
              .toString();

          if (logedInTime == "null") {
            logedInTime = "00:00:00";
          }
          startTimer(logedInTime);
        } else if (last_check_status == "out") {
          showCheckIn = true;
          logedInTime = responseJSON['data']['attendance_basic_details']
                  ['total_time']
              .toString();
          if (logedInTime == "null") {
            logedInTime = "00:00:00";
          }
          stopTimer();
        }

        if (lastImg != "null" && lastImg != "no_cam") {
          String lmg = lastImg.replaceAll("data:image/png;base64,", '');
          lastImage = lmg.replaceAll("data:image/jpeg;base64,", '');
        }
      } else {
        showCheckIn = true;
      }
      setState(() {
        attStatus = false;
      });
    } else if (responseJSON['code'] == 401 ||
        responseJSON['message'] == 'Invalid token.') {
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        attStatus = false;
      });
      _logOut(context);
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        attStatus = false;
      });
    }
  }

  getLocationList() async {
    // APIDialog.showAlertDialog(context, "Please wait...");
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithBase(baseUrl,
        "rest_api/get-project-location-by-empid?empId=" + userIdStr, context);

    print("rest_api/get-project-location-by-empid?empId=");
    // Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print("rest_api/get-project-location-by-empid?empId=");
    print(responseJSON);
    if (responseJSON['error'] == false) {
      if (responseJSON['latLngRadius'] != null) {
        int ltRadus = responseJSON['latLngRadius'];
        locationRadius = ltRadus + 1;
      }

      print('Location Radius $locationRadius');

      locationList = responseJSON['data'];
      for (int i = 0; i < locationList.length; i++) {
        print("lofgubh : " + locationList[i]['lat']);
        print("lnghsg : " + locationList[i]['lng']);
      }

      setState(() {
        //isLoading=false;
      });
    } else if (responseJSON['code'] == 401 ||
        responseJSON['message'] == 'Invalid token.') {
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        //isLoading=false;
      });
      _logOut(context);
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

      setState(() {
        //isLoading=false;
      });
    }
  }

  /************Location Services******************/
  Future<void> prepairCamera() async {
    // imageSelector(context);

    if (Platform.isAndroid) {
      final imageData = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => CaptureCameraScreen()));
      if (imageData != null) {
        capturedImage = imageData;
        capturedFile = File(capturedImage!.path);

        _faceFromCamera();
      } else {
        Toast.show("Unable to capture Image. Please try Again...",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    } else {
      imageSelector(context);
    }
  }

  Future<bool> _handleCameraPermission() async {
    bool serviceEnabled;
    PermissionStatus status = await Permission.camera.status;
    if (status.isGranted) {
      serviceEnabled = true;
    } else if (status.isPermanentlyDenied) {
      serviceEnabled = false;
    } else {
      var camStatus = await Permission.camera.request();
      if (camStatus.isGranted) {
        serviceEnabled = true;
      } else {
        serviceEnabled = false;
      }
    }
    return serviceEnabled;
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Toast.show("Location services are disabled. Please enable the services.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      /*ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));*/
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Toast.show("Location permissions are denied.",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
        /*ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));*/
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Toast.show(
          "Location permissions are permanently denied, we cannot request permissions.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      /*ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));*/
      return false;
    }

    return true;
  }

  Future<void> _getCurrentPosition() async {
    APIDialog.showAlertDialog(context, "Fetching Location..");
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      Navigator.of(context).pop();
      _showPermissionCustomDialog();
      return;
    }
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      print(
          "Location  latitude : ${_currentPosition!.latitude} Longitude : ${_currentPosition!.longitude}");
      Navigator.pop(context);
      _getAddressFromLatLng(position);
    }).catchError((e) {
      debugPrint(e);
      Toast.show(
          "Error!!! Can't get Location. Please Ensure your location services are enabled",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      Navigator.pop(context);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    APIDialog.showAlertDialog(context, "Fetching Address....");
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) async {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.name},${place.street},${place.subLocality},${place.locality},${place.thoroughfare},${place.subThoroughfare},${place.subAdministrativeArea},${place.administrativeArea},${place.country}, ${place.postalCode}';
        // _currentAddress = '${place.street}, ${place.name}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.country}, ${place.postalCode}';
      });
      print("Current Address : " + _currentAddress!);
      bool isLocationMatched = false;
      double distancePoints = 0.0;
      print("Location Length ${locationList.length}");

      if (locationList.isNotEmpty) {
        for (int i = 0; i < locationList.length; i++) {
          double lat1 = double.parse(locationList[i]['lat'].toString());
          double long1 = double.parse(locationList[i]['lng'].toString());
          distancePoints = Geolocator.distanceBetween(
              lat1, long1, position.latitude, position.longitude);
          print("distance calculated:::$distancePoints Meter");
          if (distancePoints < locationRadius) {
            isLocationMatched = true;
            break;
          }
        }
      } else {
        isLocationMatched = true;
      }

      Navigator.pop(context);
      if (isLocationMatched) {
        print("Clicik Triggered");

        if (showCheckIn) {
          final imageData = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LibasCheckIn(
                      latitude: '${_currentPosition!.latitude}',
                      longitude: '${_currentPosition!.longitude}',
                      address: '$_currentAddress',
                      checkIN: true)));

          print("Capture image path22 " + imageData!.path.toString());

          if (imageData != null) {
            capturedFile = imageData;

            _showCameraImageDialog();
          } else {
            Toast.show("Unable to capture Image. Please try Again...",
                duration: Toast.lengthLong,
                gravity: Toast.bottom,
                backgroundColor: Colors.red);
          }
        } else {
          final imageData = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LibasCheckIn(
                      latitude: '${_currentPosition!.latitude}',
                      longitude: '${_currentPosition!.longitude}',
                      address: '$_currentAddress',
                      checkIN: false)));

          if (imageData != null) {
            capturedFile = imageData;

            _showCameraImageDialog();
          } else {
            Toast.show("Unable to capture Image. Please try Again...",
                duration: Toast.lengthLong,
                gravity: Toast.bottom,
                backgroundColor: Colors.red);
          }

/*

          if(Platform.isAndroid){

          }else{
            imageSelector(context);
          }
*/
        }

        // imageSelector(context);
        /*if(empId=='TEST21'){
          if(showCheckIn){
            Navigator.push(context, MaterialPageRoute(builder: (context) => LibasCheckIn(latitude: '${_currentPosition!.latitude}', longitude: '${_currentPosition!.longitude}', address: '$_currentAddress')),).then((value) => _getDashboardData());
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => LibasCheckOutScreen(latitude: '${_currentPosition!.latitude}', longitude: '${_currentPosition!.longitude}', address: '$_currentAddress')),).then((value) => _getDashboardData());
          }


        }else{
          prepairCamera();
        }*/

        // prepairCamera();
      } else {
         Toast.show("Sorry!!! Please check your location. You are not  Allowed to Check-In/Check-Out on this Location",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
        String distanceStr = "";
        if (distancePoints < 1000) {
          distanceStr = "${distancePoints.toStringAsFixed(2)} Meters";
        } else {
          double ddsss = distancePoints / 1000;
          distanceStr = "${ddsss.toStringAsFixed(2)} Kms";
        }

        _showLocationErrorCustomDialog(distanceStr);
      }
    }).catchError((e) {
      debugPrint(e.toString());
      // imageSelector(context);
      // prepairCamera();
    });
  }

  /***********Mark Attendance*****************/
  markAttendanceFromCamera() async {
    String attendanceCheck = "";
    String addressStr = "";
    if (showCheckIn) {
      attendanceCheck = "in";
    } else {
      attendanceCheck = "out";
    }
    if (_currentAddress != null) {
      addressStr = _currentAddress!;
    } else {
      addressStr = "Address Not Available";
    }

    APIDialog.showAlertDialog(context, 'Submitting Attendance...');

    final bytes = await File(capturedFile!.path).readAsBytesSync();
    String base64Image = "data:image/jpeg;base64," + base64Encode(bytes);
    print("imagePan $base64Image");
    print("Base Url $baseUrl");
    print("Check Status $attendanceCheck");
    print("emp_user_id $userIdStr");

    var requestModel = {
      "emp_user_id": userIdStr,
      "latitude": _currentPosition!.latitude.toString(),
      "longitude": _currentPosition!.longitude.toString(),
      "status": "status",
      "attendance_check_status": attendanceCheck,
      "attendance_type": "attendance",
      "attendance_check_location": addressStr,
      "capture": base64Image,
      "device": platform,
      "mac_address": "flutter",
      "other_break_time": "00:00:00:00",
      "comment": "flutter",
    };
    ApiBaseHelper apiBaseHelper = ApiBaseHelper();
    var response = await apiBaseHelper.postAPIWithHeader(
        baseUrl,
        "attendance_management/attendanceCheckInCheckOut",
        requestModel,
        context,
        token);

    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      _showCustomDialog();
    } else if (responseJSON['code'] == 401 ||
        responseJSON['message'] == 'Invalid token.') {
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _logOut(context);
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  markAttendance() async {
    String attendanceCheck = "";
    String addressStr = "";
    if (showCheckIn) {
      attendanceCheck = "in";
    } else {
      attendanceCheck = "out";
    }
    if (_currentAddress != null) {
      addressStr = _currentAddress!;
    } else {
      addressStr = "Address Not Available";
    }

    APIDialog.showAlertDialog(context, 'Submitting Attendance...');

    final bytes = await File(file!.path).readAsBytesSync();
    String base64Image = "data:image/jpeg;base64," + base64Encode(bytes);
    print("imagePan $base64Image");
    print("Base Url $baseUrl");
    print("Check Status $attendanceCheck");
    print("emp_user_id $userIdStr");

    var requestModel = {
      "emp_user_id": userIdStr,
      "latitude": _currentPosition!.latitude.toString(),
      "longitude": _currentPosition!.longitude.toString(),
      "status": "status",
      "attendance_check_status": attendanceCheck,
      "attendance_type": "attendance",
      "attendance_check_location": addressStr,
      "capture": base64Image,
      "device": platform,
      "mac_address": "flutter",
      "other_break_time": "00:00:00:00",
      "comment": "flutter",
    };
    ApiBaseHelper apiBaseHelper = ApiBaseHelper();
    var response = await apiBaseHelper.postAPIWithHeader(
        baseUrl,
        "attendance_management/attendanceCheckInCheckOut",
        requestModel,
        context,
        token);

    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      _showCustomDialog();
    } else if (responseJSON['code'] == 401 ||
        responseJSON['message'] == 'Invalid token.') {
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _logOut(context);
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  _getLastAttendance() async {
    setState(() {
      lastAttendance = true;
    });
    var now = DateTime.now();
    var now_1w = now.subtract(const Duration(days: 7));
    var now_last = now.subtract(const Duration(days: 1));
    var startDate = DateFormat('yyyy-MM-dd').format(now_1w);
    var lastDate = DateFormat('yyyy-MM-dd').format(now_last);
    print("Start Date: $startDate");
    print("Last Date: $lastDate");
    print("Employee Id: $empId");
    // APIDialog.showAlertDialog(context, 'Please Wait...');
    var requestModel = {
      "emp_id": empId,
      "start_date": startDate,
      "last_date": lastDate,
    };
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(baseUrl,
        'attendance_management/get-attendance-by-id', requestModel, context);
    // Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      List<dynamic> tempUserList = [];
      tempUserList = responseJSON['data'];
      attendanceDate.clear();
      for (int i = 0; i < tempUserList.length; i++) {
        String dateStr = tempUserList[i]['date'];
        String first_half_status = tempUserList[i]['first_half_status'];
        String second_half_status = tempUserList[i]['second_half_status'];
        String first_check_in = tempUserList[i]['first_check_in'];
        String last_check_out = tempUserList[i]['last_check_out'];
        String total_time = tempUserList[i]['total_time'];
        String attendance_status = tempUserList[i]['attendance_status'];
        String attendance_day = "";
        if (tempUserList[i]['attendance_day'] != null) {
          attendance_day = tempUserList[i]['attendance_day'];
        }
        var atDate = DateTime.parse(dateStr);
        var nDate = DateFormat("ddMMM").format(atDate);
        double attendanceHour = 8;
        if (attendance_status == "HD" ||
            attendance_status == "first_half_present" ||
            attendance_status == "FHP" ||
            attendance_status == "SHP" ||
            attendance_status == "second_half_present" ||
            attendance_status == "PH_FHP" ||
            attendance_status == "PH_SHP" ||
            attendance_status == "WO_FHP" ||
            attendance_status == "WO_SHP") {
          attendanceHour = 4;
        }
        attendanceDate.add(AttendanceSeries(
            nDate,
            first_half_status,
            second_half_status,
            first_check_in,
            last_check_out,
            total_time,
            attendance_status,
            attendance_day,
            i,
            attendanceHour));
      }
    } else if (responseJSON['code'] == 401 ||
        responseJSON['message'] == 'Invalid token.') {
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _logOut(context);
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {
      lastAttendance = false;
    });
  }

  _showCustomDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          getAttendanceDetails();
                        },
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 100,
                      width: double.infinity,
                      child: Lottie.asset("assets/att_anim.json"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Time Marked!!!",
                        style: TextStyle(
                            color: AppTheme.orangeColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          getAttendanceDetails();
                          //call attendance punch in or out
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.themeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(
                            child: Text(
                              "Done",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  startTimer(String time) {
    List<String> splitString = time.split(':');
    int hour = int.parse(splitString[0]);
    int mnts = int.parse(splitString[1]);
    int sec = int.parse(splitString[2]);

    myDuration = Duration(hours: hour, minutes: mnts, seconds: sec);
    if (countdownTimer != null) {
      countdownTimer!.cancel();
    }
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  setCountDown() {
    const increasedSecBy = 1;
    setState(() {
      final second = myDuration!.inSeconds + increasedSecBy;
      myDuration = Duration(seconds: second);
      String strDigits(int n) => n.toString().padLeft(2, '0');
      final hours = strDigits(myDuration!.inHours.remainder(24));
      final minutes = strDigits(myDuration!.inMinutes.remainder(60));
      final seconds = strDigits(myDuration!.inSeconds.remainder(60));
      logedInTime = "$hours:$minutes:$seconds";
    });
  }

  stopTimer() {
    if (countdownTimer != null) {
      countdownTimer!.cancel();
    }
  }

  _showPermissionCustomDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Please allow below permissions for access the Attendance Functionality.",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "1.) Location Permission",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "2.) Enable GPS Services",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          //call attendance punch in or out
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.themeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showCameraPermissionCustomDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Please allow Camera Permissions For Capture Image",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          //call attendance punch in or out
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.themeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showFaceErrorCustomDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Please capture Selfie!!!",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w900,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Face not detected in captured Image. Please capture Selfie.",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          //call attendance punch in or out
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.themeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showLocationErrorCustomDialog(String distanceStr) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Location Not Matched !",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w900,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "You are not Allowed to Check-In OR Check-Out on this Location. You are $distanceStr away from required Location.",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          //call attendance punch in or out
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.themeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.cover,
      width: 70,
      height: 70,
      gaplessPlayback: true,
    );
  }

  /****************tasks/get-tasks**************/
  getTaskList() async {
    setState(() {
      taskLoading = true;
    });
    //APIDialog.showAlertDialog(context, "Please wait...");
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.getWithToken(baseUrl, "tasks/get-tasks", token, context);
    // Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      totakTaskList.clear();
      taskList.clear();

      totakTaskList = responseJSON['data']['data'];
      taskSize = totakTaskList.length;

      if (totakTaskList.length > 3) {
        taskList.add(totakTaskList[totakTaskList.length - 1]);
        taskList.add(totakTaskList[totakTaskList.length - 2]);
        taskList.add(totakTaskList[totakTaskList.length - 3]);
      } else {
        taskList.addAll(totakTaskList);
      }

      setState(() {
        taskLoading = false;
      });
    } else if (responseJSON['code'] == 401 ||
        responseJSON['message'] == 'Invalid token.') {
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        taskLoading = false;
      });
      _logOut(context);
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

      setState(() {
        taskLoading = false;
      });
    }
  }

  /****************get Applied Leaves**************/
  getLeaves() async {
    setState(() {
      leaveLoading = true;
    });
    //APIDialog.showAlertDialog(context, "Please wait...");
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(
        baseUrl,
        "attendance_management/getEmpAppliedApplication?type=leave&request_for=applied",
        token,
        context);
    // Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      totalLeaveList.clear();
      leaveList.clear();

      totalLeaveList = responseJSON['data'];
      leaveSize = totalLeaveList.length;
      if (totalLeaveList.length > 3) {
        leaveList.add(totalLeaveList[0]);
        leaveList.add(totalLeaveList[1]);
        leaveList.add(totalLeaveList[2]);
      } else {
        leaveList.addAll(totalLeaveList);
      }

      setState(() {
        leaveLoading = false;
      });
    } else if (responseJSON['code'] == 401 ||
        responseJSON['message'] == 'Invalid token.') {
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        leaveLoading = false;
      });
      _logOut(context);
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

      setState(() {
        leaveLoading = false;
      });
    }
  }

  /************get Camera for Capture Image******************/
  markOnlyAttendance(String from) async {
    String attendanceCheck = "";
    String addressStr = "";
    if (showCheckIn) {
      attendanceCheck = "in";
    } else {
      attendanceCheck = "out";
    }
    if (_currentAddress != null) {
      addressStr = _currentAddress!;
    } else {
      addressStr = "Address Not Available";
    }
    APIDialog.showAlertDialog(context, 'Submitting Attendance...');

    //final bytes= await File(file!.path).readAsBytesSync();
    // String base64Image="data:image/jpeg;base64,"+base64Encode(bytes);
    // print("imagePan $base64Image");
    print("Base Url $baseUrl");
    print("Check Status $attendanceCheck");
    print("emp_user_id $userIdStr");

    var requestModel = {
      "emp_user_id": userIdStr,
      "latitude": _currentPosition!.latitude.toString(),
      "longitude": _currentPosition!.longitude.toString(),
      "status": "status",
      "attendance_check_status": attendanceCheck,
      "attendance_type": "attendance",
      "attendance_check_location": addressStr,
      // "capture":base64Image,
      "device": platform,
      "mac_address": "flutter",
      "other_break_time": "00:00:00:00",
      "comment": "flutter",
    };
    ApiBaseHelper apiBaseHelper = ApiBaseHelper();
    var response = await apiBaseHelper.postAPIWithHeader(
        baseUrl,
        "attendance_management/attendanceCheckInCheckOutMobile",
        requestModel,
        context,
        token);

    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      if (responseJSON['data']['insertId'] != null) {
        String id = responseJSON['data']['insertId'].toString();
        uploadOnlyImage(from, id);
      }
      /*Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);*/
      _showCustomDialog();
    } else if (responseJSON['code'] == 401 ||
        responseJSON['message'] == 'Invalid token.') {
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _logOut(context);
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  uploadOnlyImage(String from, String id) async {
    setState(() {
      isImageUploading = true;
    });
    var bytes = null;

    if (from == 'camera') {
      bytes = await File(capturedFile!.path).readAsBytesSync();
    } else {
      bytes = await File(file!.path).readAsBytesSync();
    }
    String base64Image = "data:image/jpeg;base64," + base64Encode(bytes);
    var requestModel = {
      "id": id,
      "capture": base64Image,
      "device": platform,
    };
    ApiBaseHelper apiBaseHelper = ApiBaseHelper();
    var response = await apiBaseHelper.postAPIWithHeader(
        baseUrl,
        "attendance_management/updateImageAttendance",
        requestModel,
        context,
        token);
    var responseJSON = json.decode(response.body);
    if (responseJSON['error'] == false) {
      /*Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);*/
      getAttendanceDetails();
    } else if (responseJSON['code'] == 401 ||
        responseJSON['message'] == 'Invalid token.') {
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _logOut(context);
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {
      isImageUploading = false;
    });
  }

  getAnnouncements() async {
    final now = DateTime.now();
    var date = now.subtract(Duration(days: 10));
    var startDate = DateFormat("yyyy-MM-dd").format(date);
    var endDate = DateFormat("yyyy-MM-dd").format(now);

    print("start Date : $startDate");
    print("End Date : $endDate");

    setState(() {
      communityLoading = true;
    });
    //APIDialog.showAlertDialog(context, 'Please Wait...');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url') ?? '';
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(
        baseUrl,
        'rest_api/get-all-announcements?start_date=$startDate&end_date=$endDate',
        token,
        context);
    //Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['error'] == false) {
      announcementList.clear();

      List<dynamic> tempList = [];
      tempList = responseJSON['data'];

      announcementSize = tempList.length;

      if (tempList.length > 3) {
        for (int i = tempList.length - 1; i >= tempList.length - 3; i--) {
          announcementList.add(tempList[i]);
        }
      } else {
        for (int i = tempList.length - 1; i >= 0; i--) {
          announcementList.add(tempList[i]);
        }
      }

      //announcementList=responseJSON['data'];

      setState(() {
        communityLoading = false;
      });
    } else if (responseJSON['code'] == 401 ||
        responseJSON['message'] == 'Invalid token.') {
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        communityLoading = false;
      });
      _logOut(context);
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        communityLoading = false;
      });
    }
  }

  /************Correction Notification************************/
  getCorrectionNotification() async {
    setState(() {
      isNotiLoading = true;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(
        baseUrl, 'rest_api/get-correction-notification', token, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      List<dynamic> tempDataList = responseJSON['data'];
      notiStr = "";

      if (tempDataList.isNotEmpty) {
        String samplenotiStr = tempDataList[0]['message'].toString();
        notiStr = Bidi.stripHtmlIfNeeded(samplenotiStr);
      }

      setState(() {
        isNotiLoading = false;
      });
    } else if (responseJSON['code'] == 401 ||
        responseJSON['message'] == 'Invalid token.') {
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        isNotiLoading = false;
      });
      _logOut(context);
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        isNotiLoading = false;
      });
    }
  }
}
