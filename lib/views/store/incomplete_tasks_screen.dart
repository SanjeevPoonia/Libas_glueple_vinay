import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../utils/app_modal.dart';
import '../../utils/app_theme.dart';
import '../mcq/test_mcq1.dart';

class IncompleteTasksScreen extends StatefulWidget {
  final String taskType;

  IncompleteTasksScreen(this.taskType);

  IncompleteState createState() => IncompleteState();
}

class IncompleteState extends State<IncompleteTasksScreen> {
  int currentMonthCount = DateTime.now().month;
  int selectedIndex = 5;
  List<int> dates = [];
  List<int> month = [];
  List<int> year = [];
  bool isLoading = false;
  List<dynamic> taskList = [];
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.themeColor,
        onPressed: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1950),
              //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime(2100));

          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            selectedDate = formattedDate.toString();
            setState(() {});
            fetchInCompleteTasks(context);
          }
        },
        child: const Icon(Icons.calendar_month, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: AppTheme.orangeColor,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white)),
        // leading: Image.asset('yourImage'), // you can put Icon as well, it accepts any widget.
        title: Text(widget.taskType=="0"?"Expired Tasks":"Completed Tasks",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            )),
        /*  actions: [
          Image.asset("assets/bell_ic.png", width: 23, height: 23,color: Colors.white),
          SizedBox(width: 12),
          Icon(Icons.login,color: Colors.white),
          SizedBox(width: 12),
        ],*/
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          Container(
            height: 75,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: Colors.black.withOpacity(0.3))),
            child: dates.length == 0
                ? Container()
                : ListView.builder(
                    itemCount: dates.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int pos) {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = pos;
                              });

                              String currentMonthAsString=month[pos].toString();
                              String currentYearAsString=year[pos].toString();
                              String currentDateAsString=dates[pos].toString();


                              if(currentMonthAsString.length==1)
                                {
                                  currentMonthAsString="0"+currentMonthAsString;
                                }

                              if(currentDateAsString.length==1)
                              {
                                currentDateAsString="0"+currentDateAsString;
                              }




                              selectedDate=currentYearAsString+"-"+currentMonthAsString+"-"+currentDateAsString;

                              fetchInCompleteTasks(context);





                            },
                            child: Container(
                              width: 50,
                              color: selectedIndex == pos
                                  ? AppTheme.orangeColor.withOpacity(0.4)
                                  : Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      dates[pos].toString().length == 1
                                          ? "0" + dates[pos].toString()
                                          : dates[pos].toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      )),
                                  SizedBox(height: 2),
                                  Text(
                                      fetchDayName(dates[pos].toString() +
                                          "/" +
                                          month[pos].toString() +
                                          "/" +
                                          year[pos].toString()),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black.withOpacity(0.4),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 7)
                        ],
                      );
                    }),
          ),
          SizedBox(height: 15),
          Expanded(
              child: isLoading
                  ? Center(
                      child: Loader(),
                    )
                  : taskList.length == 0
                      ? Center(
                          child: Text("No tasks found!"),
                        )
                      : ListView.builder(
                          itemCount: taskList.length,
                          itemBuilder: (BuildContext context, int pos) {
                            return Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 80,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 15),
                                          Text(
                                              parseServerFormatDate(
                                                  taskList[pos]
                                                          ["start_date_time"]
                                                      .toString()),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: AppTheme.themeColor,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap:(){


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
                                                            taskList[pos]["task_artifacts"]["task_id"].toString(),taskList[pos]["id"].toString(),false)),
                                              ).then((value) {

                                              fetchInCompleteTasks(context);
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











                                       /*   if(widget.taskType=="0")
                                            {
                                              DateTime currentDate=DateTime.now();

                                              DateTime dt1 = DateTime.parse(
                                                  taskList[pos]["start_date_time"]);
                                              DateTime dt2 = DateTime.parse(
                                                  taskList[pos]["end_date_time"]);

                                             // dt1 = DateTime(currentDate.year, currentDate.month, currentDate.day, dt1.hour, dt1.minute);
                                            //  dt2 = DateTime(currentDate.year, currentDate.month, currentDate.day, dt2.hour, dt2.minute);


                                              if (DateTime.now().isAfter(dt1) && DateTime.now().isBefore(dt2)) {
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MCQTest1Screen(taskList[pos]["task_artifacts"]["task_id"].toString(),taskList[pos]["id"].toString(),false)));

                                              } else {
                                                Toast.show(
                                                    "You can complete this between " +
                                                        parseServerFormatDate(
                                                            taskList[pos]
                                                            ["start_date_time"]
                                                                .toString()) +
                                                        " to " +
                                                        parseServerFormatDate(
                                                            taskList[pos]["end_date_time"]
                                                                .toString()),
                                                    duration: Toast.lengthLong,
                                                    gravity: Toast.bottom,
                                                    backgroundColor: Colors.red);
                                              }
                                            }*/




                            },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 13),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF8F8F8),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 2.0,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        taskList[pos]
                                                            ["task_name"],
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.blueGrey,
                                                        )),
                                                    SizedBox(height: 5),
                                                    Text(
                                                        "Repetition: " +
                                                            getTaskRepeatName(taskList[
                                                                            pos][
                                                                        "task_artifacts"]
                                                                    [
                                                                    "task_repetation"]
                                                                .toString()),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        )),
                                                    taskList[pos]["task_artifacts"]
                                                                ["remark"] ==
                                                            null
                                                        ? Container()
                                                        : SizedBox(height: 5),
                                                    taskList[pos]["task_artifacts"]
                                                                ["remark"] ==
                                                            null
                                                        ? Container()
                                                        : Text(
                                                            "Remark: " +
                                                                taskList[pos][
                                                                            "task_artifacts"]
                                                                        ["remark"]
                                                                    .toString(),
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight.w400,
                                                              color: Colors.black,
                                                            )),
                                                    SizedBox(height: 10),
                                                    Text(
                                                        parseServerFormatDate(
                                                                taskList[pos][
                                                                        "start_date_time"]
                                                                    .toString()) +
                                                            " - " +
                                                            parseServerFormatDate(
                                                                taskList[pos][
                                                                        "end_date_time"]
                                                                    .toString()),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppTheme
                                                              .orangeColor,
                                                        )),
                                                    taskList[pos].toString().contains("report")?
                                                    SizedBox(height: 5):Container(),


                                                    taskList[pos].toString().contains("report") && taskList[pos]
                                                    ["report"]!=null?


                                                    Text(

                                                        taskList[pos]
                                                        ["report"]["admin_remark"]==null?


                                                            "Feedback:NA":



                                                      "Feedback: "+
                                                        taskList[pos]
                                                        ["report"]["admin_remark"],
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color: Colors.blueGrey,
                                                        )):Container(),

                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 10),



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
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 17),
                              ],
                            );
                          }))
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDateList();
    fetchInCompleteTasks(context);
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

  fetchInCompleteTasks(BuildContext context) async {
    String? authKey = await MyUtils.getSharedPreferences("access_token");
    //String authKey="\$2y\$10\$/T.2Oxl4xx87GhTC2lPHeu48G/jUJIoqNwx2KW.ZfB1UqMdaaWLBq";
    setState(() {
      isLoading = true;
    });
    //0 incomplete
    var data = {
      "auth_key": authKey,
      "date": selectedDate,
      "task_type": widget.taskType
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('get_task', data, context);
    var responseJSON = json.decode(response.body);
    setState(() {
      isLoading = false;
    });

    print(responseJSON);

    taskList = responseJSON["taskData"];

  }

  String parseServerFormatDate(String serverDate) {
    var date = DateTime.parse(serverDate);
    final dateformat = DateFormat.jm();
    final clockString = dateformat.format(date);
    return clockString.toString();
  }

  fetchDateList() {
    for (int i = 0; i < 6; i++) {
      String date =
          DateTime.now().subtract(Duration(days: 5 - i)).day.toString();

      String monthCount =
          DateTime.now().subtract(Duration(days: 5 - i)).month.toString();

      String yearCount =
          DateTime.now().subtract(Duration(days: 5 - i)).year.toString();

      dates.add(int.parse(date));
      month.add(int.parse(monthCount));
      year.add(int.parse(yearCount));


      print(dates.toString());

    }

    /* dates.reversed.toList();
    month.reversed.toList();
    year.reversed.toList();*/

    print(dates.toString());
    print(month.toString());
    print(year.toString());
  }

  String fetchDayName(String date) {
    final format = DateFormat('dd/MM/yyyy');
    final dateTime = format.parse(date);
    final DateFormat format1 = DateFormat('EEE');
    String dayName = format1.format(dateTime);
    return dayName;
  }
}
