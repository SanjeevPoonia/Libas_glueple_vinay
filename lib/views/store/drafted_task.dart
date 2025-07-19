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

class DraftedTasksScreen extends StatefulWidget {

  IncompleteState createState() => IncompleteState();
}

class IncompleteState extends State<DraftedTasksScreen> {
  bool isLoading = false;
  List<dynamic> taskList = [];

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.orangeColor,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white)),
        // leading: Image.asset('yourImage'), // you can put Icon as well, it accepts any widget.
        title: Text("Drafted Tasks",
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
                          shrinkWrap: true,
                          itemCount: taskList.length,
                          physics: NeverScrollableScrollPhysics(),
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

                                         // Navigator.push(context, MaterialPageRoute(builder: (context)=>MCQTest1Screen(taskList[pos]["task_detail"]["task_id"].toString(),taskList[pos]["id"].toString(),true)));

                                          DateTime currentDate=DateTime.now();

                                          DateTime dt1 = DateTime.parse(
                                              taskList[pos]["start_date_time"]);
                                          DateTime dt2 = DateTime.parse(
                                              taskList[pos]["end_date_time"]);

                                        //  dt1 = DateTime(currentDate.year, currentDate.month, currentDate.day, dt1.hour, dt1.minute);
                                        //  dt2 = DateTime(currentDate.year, currentDate.month, currentDate.day, dt2.hour, dt2.minute);


                                          if (DateTime.now().isAfter(dt1) && DateTime.now().isBefore(dt2)) {
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MCQTest1Screen(taskList[pos]["task_detail"]["task_id"].toString(),taskList[pos]["id"].toString(),true)));

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
                                                                        "task_detail"]
                                                                    [
                                                                    "task_repetation"]
                                                                .toString()),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        )),
                                                    taskList[pos]["task_detail"]
                                                                ["remark"] ==
                                                            null
                                                        ? Container()
                                                        : SizedBox(height: 5),
                                                    taskList[pos]["task_detail"]
                                                                ["remark"] ==
                                                            null
                                                        ? Container()
                                                        : Text(
                                                            "Remark: " +
                                                                taskList[pos][
                                                                            "task_detail"]
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


                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 10),


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
    fetchDraftedData(context);
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
    String? authKey=await MyUtils.getSharedPreferences("access_token");
    setState(() {
      isLoading=true;
    });
    var data = {
      "auth_key": authKey.toString()
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('saved_draft_listing', data, context);
    var responseJSON = json.decode(response.body);
    setState(() {
      isLoading=false;
    });

    taskList=responseJSON["draftTask"];
    setState(() {

    });

    print(responseJSON);

  }

  String parseServerFormatDate(String serverDate) {
    var date = DateTime.parse(serverDate);
    final dateformat = DateFormat.jm();
    final clockString = dateformat.format(date);
    return clockString.toString();
  }




}
