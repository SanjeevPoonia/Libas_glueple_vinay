import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ChecklistTree/network/loader.dart';
import 'package:intl/intl.dart';

import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';


class NotificationScreen extends StatefulWidget {
  @override
  NotificationState createState() => NotificationState();
}

class NotificationState extends State<NotificationScreen> {
  bool showImage = false;
  bool isLoading=false;
  List<dynamic> notificationList=[];
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

          body: Column(
            children: [


              Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 10),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                ),
                child: Container(
                  height: 69,
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);

                          },
                          child:Icon(Icons.keyboard_backspace_rounded)),


                      Text("Notifications",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                      showImage == true?
                      Image.asset("assets/bell_ic.png",width: 23,height: 23):Column()

                    ],
                  ),
                ),
              ),

              Expanded(
                child:
                isLoading?

                    Center(
                      child: Loader(),
                    ):

                    notificationList.length==0?

                    Center(
                      child: Text("No data found!"),
                    ):




                ListView.builder(
                  itemCount: notificationList.length, // Example content count
                  itemBuilder: (context, contentIndex) {
                    return Container(
                      margin: EdgeInsets.only(left: 16,right: 16,top: 6,bottom: 6),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFFE9F4F7),
                        borderRadius: BorderRadius.circular(8.0), // Set corner radius
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(notificationList[contentIndex]["title"],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFFF7C00)
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Text(notificationList[contentIndex]["body"],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF000000)
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Text(parseServerFormatDate(notificationList[contentIndex]["created_at"].toString()),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF708096)
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 25)

            ],
          )
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNotificationData(context);
  }
  String parseServerFormatDate(String serverDate) {
    var date = DateTime.parse(serverDate);
    final dateformat = DateFormat.yMMMMEEEEd();
    final clockString = dateformat.format(date);
    return clockString.toString();
  }
  fetchNotificationData(BuildContext context) async {
    String? authKey=await MyUtils.getSharedPreferences("access_token");
    setState(() {
      isLoading=true;
    });
    var data = {
      "auth_key": authKey.toString()
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('notifications', data, context);
    var responseJSON = json.decode(response.body);
    setState(() {
      isLoading=false;
    });
    print(responseJSON);

    notificationList=responseJSON["data"];
    setState(() {

    });





  }




}
