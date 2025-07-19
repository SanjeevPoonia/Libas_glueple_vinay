import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../network/api_helper.dart';
import '../network/loader.dart';
import '../utils/app_theme.dart';

class AnnouncementScreen extends StatefulWidget{
  _announcementScreen createState()=> _announcementScreen();
}
class _announcementScreen extends State<AnnouncementScreen>{
  var userIdStr="";
  var designationStr="";
  var token="";
  var fullNameStr="";
  var empId="";
  var baseUrl="";
  var clientCode="";
  var platform="";
  List<dynamic> announcementList=[];
  bool isLoading=false;
  bool communityLoading=false;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        appBar: AppBar  (
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_left_outlined, color: Colors.black,size: 35,),
            onPressed: () => {
              Navigator.of(context).pop()
            },
          ),
          backgroundColor: AppTheme.at_details_header,
          title: const Text(
            "Community",
            style: TextStyle(
                fontSize: 18.5,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          /*actions: [IconButton(onPressed: (){
              _showAlertDialog();

            }, icon: SvgPicture.asset("assets/logout.svg"))] ,*/
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: isLoading?SizedBox():
        communityLoading?Center(child: Loader(),):
        announcementList.isEmpty?Align(alignment: Alignment.center,child: Text("No Community Post Available",style: TextStyle(fontSize: 14.5,color: AppTheme.orangeColor,fontWeight: FontWeight.w300),),):
        Padding(padding: EdgeInsets.all(10),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: announcementList.length,
            itemBuilder: (BuildContext cntx,int index){

              String type=announcementList[index]['type'].toString();
              String startDate="";
              String endDate="";
              String description="";
              String birthdayDescription="May this birthday be filled with lots of happy hours and also your life with many happy birthdays that are yet to come. Happy Birthday!!!";
              String createdAt="";
              String empName="";
              String userProfileImage="";
              int yearStr=0;
              String yearJSOnStr="assets/anni_1.json";
              String yearCountStr="";
              String AnniverseryStr="Thank You for being part of the Journey let's keep on growing together";

              startDate=announcementList[index]['start_date'].toString();
              endDate=announcementList[index]['end_date'].toString();
              userProfileImage=announcementList[index]['profile_photo'].toString();
              empName=announcementList[index]['username'].toString();
              description=announcementList[index]['description'].toString();
              createdAt=announcementList[index]['created_at'].toString();

              String WelcomeDescription="We are Please to announce that $empName has joined Us";


              if(type=='anniversary'){
                yearStr=announcementList[index]['years'];
                if(yearStr==1){
                  yearJSOnStr="assets/anni_1.json";
                  yearCountStr="1st Year";
                }else if(yearStr==2){
                  yearJSOnStr="assets/anni_2.json";
                  yearCountStr="2nd Year";
                }else if(yearStr==3){
                  yearJSOnStr="assets/anni_3.json";
                  yearCountStr="3rd Year";
                }else if(yearStr==4){
                  yearJSOnStr="assets/anni_4.json";
                  yearCountStr="4th Year";
                }else if(yearStr==5){
                  yearJSOnStr="assets/anni_5.json";
                  yearCountStr="5th Year";
                }else if(yearStr==6){
                  yearJSOnStr="assets/anni_6.json";
                  yearCountStr="6th Year";
                }else if(yearStr==7){
                  yearJSOnStr="assets/anni_7.json";
                  yearCountStr="7th Year";
                }else if(yearStr==8){
                  yearJSOnStr="assets/anni_8.json";
                  yearCountStr="8th Year";
                }else if(yearStr==9){
                  yearJSOnStr="assets/anni_9.json";
                  yearCountStr="9th Year";
                }else if(yearStr==10){
                  yearJSOnStr="assets/anni_10.json";
                  yearCountStr="10th Year";
                }else if(yearStr==11){
                  yearJSOnStr="assets/anni_11.json";
                  yearCountStr="11th Year";
                }else if(yearStr==12){
                  yearJSOnStr="assets/anni_12.json";
                  yearCountStr="12th Year";
                }else if(yearStr==13){
                  yearJSOnStr="assets/anni_13.json";
                  yearCountStr="13th Year";
                }else if(yearStr==14){
                  yearJSOnStr="assets/anni_14.json";
                  yearCountStr="14th Year";
                }else if(yearStr==15){
                  yearJSOnStr="assets/anni_15.json";
                  yearCountStr="15th Year";
                }else if(yearStr==16){
                  yearJSOnStr="assets/anni_16.json";
                  yearCountStr="16th Year";
                }else if(yearStr==17){
                  yearJSOnStr="assets/anni_17.json";
                  yearCountStr="17th Year";
                }else if(yearStr==18){
                  yearJSOnStr="assets/anni_18.json";
                  yearCountStr="18th Year";
                }else{
                  yearJSOnStr="assets/anni_1.json";
                  yearCountStr="$yearStr Year";
                }
              }

              if(type=='welcome_email'){
                String department="";
                String designation="";
                if(announcementList[index]['department']!=null){
                  department=announcementList[index]['department'].toString();
                }

                if(announcementList[index]['designation']!=null){
                  department=announcementList[index]['designation'].toString();
                }

                if(department.isNotEmpty && designation.isNotEmpty){
                  WelcomeDescription="We are Please to announce that $empName has joined Us as $designation in $department";
                }

              }


              return  Column(

                children: [
                  type=='announcement'?
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/announc_back_img.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 7,right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              Lottie.asset(
                                  "assets/announcement.json",
                                  width: 100,height: 100
                              ),
                              Expanded(child: Column(
                                children: [
                                  Text(
                                    "Announcement",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold,
                                        color: AppTheme.themeColor,
                                        fontSize: 18
                                    ),

                                  ),
                                  SizedBox(height: 5,),
                                  Text("$startDate to $endDate",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 14,color: Colors.black),),
                                ],
                              ))
                            ],
                          ),

                          SizedBox(height: 10,),
                          Text(description,textAlign: TextAlign.center,style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.black
                          ),),
                          SizedBox(height: 10,),


                        ],
                      ),
                    ),
                    padding: EdgeInsets.all(10),

                  ):
                  type=='birthday'?
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/birthday_backimg.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 7,right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(

                            children: [
                              Lottie.asset(
                                  "assets/cake.json",
                                  width: 100,height: 150
                              ),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  userProfileImage==''?
                                  Image.asset("assets/profile.png",height: 65,width: 40,):
                                  CachedNetworkImage(
                                    imageUrl: userProfileImage,
                                    height: 65,width: 40,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        CircularProgressIndicator(value: downloadProgress.progress),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                  Text(
                                    empName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold,
                                        color: AppTheme.orangeColor,
                                        fontSize: 18
                                    ),

                                  ),
                                  SizedBox(height: 5,),
                                  Text("Many Many Happy Return of the Day!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12,color: Colors.black),),
                                  SizedBox(height: 5,),
                                  Text("$startDate",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12,color: Colors.black),),
                                ],
                              ))
                            ],
                          ),

                          SizedBox(height: 10,),
                          Text(birthdayDescription,
                            textAlign: TextAlign.center,style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.black
                            ),),
                          SizedBox(height: 10,),


                        ],
                      ),
                    ),
                    padding: EdgeInsets.all(10),

                  ):
                  type=='anniversary'?
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/aniv_back_img.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 7,right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(

                            children: [
                              Lottie.asset(
                                  yearJSOnStr,
                                  width: 100,height: 150
                              ),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  userProfileImage==''?
                                  Image.asset("assets/profile.png",height: 65,width: 40,):
                                  CachedNetworkImage(
                                    imageUrl: userProfileImage,
                                    height: 65,width: 40,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        CircularProgressIndicator(value: downloadProgress.progress),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                  Text(
                                    empName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold,
                                        color: AppTheme.orangeColor,
                                        fontSize: 18
                                    ),

                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Happy",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12,color: Colors.black),),
                                      SizedBox(width: 5,),
                                      Text(yearCountStr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: AppTheme.themeColor),),
                                      SizedBox(width: 5,),
                                      Text("Anniversary",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12,color: Colors.black),),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Text("$startDate",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12,color: Colors.black),),
                                ],
                              ))
                            ],
                          ),

                          SizedBox(height: 10,),
                          Text(AnniverseryStr,
                            textAlign: TextAlign.center,style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.black
                            ),),
                          SizedBox(height: 10,),


                        ],
                      ),
                    ),
                    padding: EdgeInsets.all(10),

                  ):
                  type=='welcome_email'?
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/aniv_back_img.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 7,right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(

                            children: [
                              Lottie.asset(
                                  "assets/welcome.json",
                                  width: 100,height: 150
                              ),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  userProfileImage==''?
                                  Image.asset("assets/profile.png",height: 65,width: 40,):
                                  CachedNetworkImage(
                                    imageUrl: userProfileImage,
                                    height: 65,width: 40,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        CircularProgressIndicator(value: downloadProgress.progress),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                  Text(
                                    empName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold,
                                        color: AppTheme.orangeColor,
                                        fontSize: 18
                                    ),

                                  ),
                                  SizedBox(height: 5,),
                                  Text("Welcome Aboard",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12,color: Colors.black),),
                                  SizedBox(height: 5,),
                                  Text("$startDate",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12,color: Colors.black),),
                                ],
                              ))
                            ],
                          ),

                          SizedBox(height: 10,),
                          Text(WelcomeDescription,
                            textAlign: TextAlign.center,style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.black
                            ),),
                          SizedBox(height: 10,),


                        ],
                      ),
                    ),
                    padding: EdgeInsets.all(10),

                  ):
                  Container(),
                  const SizedBox(height: 25,),
                ],

              );

            }),
        ),

    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _getDashboardData();
    });


  }
  _getDashboardData() async {
    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    userIdStr=await MyUtils.getSharedPreferences("user_id")??"";
    fullNameStr=await MyUtils.getSharedPreferences("full_name")??"";
    token=await MyUtils.getSharedPreferences("token")??"";
    designationStr=await MyUtils.getSharedPreferences("designation")??"";
    empId=await MyUtils.getSharedPreferences("emp_id")??"";
    baseUrl=await MyUtils.getSharedPreferences("base_url")??"";
    clientCode=await MyUtils.getSharedPreferences("client_code")??"";
    String? access=await MyUtils.getSharedPreferences("at_access")??'1';

    if(Platform.isAndroid){
      platform="Android";
    }else if(Platform.isIOS){
      platform="iOS";
    }else{
      platform="Other";
    }


    print("userId:-"+userIdStr.toString());
    print("token:-"+token.toString());
    print("employee_id:-"+empId.toString());
    print("Base Url:-"+baseUrl.toString());
    print("Platform:-"+platform);




    setState(() {
      isLoading=false;
    });

    Navigator.of(context).pop();


    getAnnouncements();
  }

  getAnnouncements() async {

    final now = DateTime.now();
    var date = now.subtract(Duration(days: 30));
    var startDate=DateFormat("yyyy-MM-dd").format(date);
    var endDate=DateFormat("yyyy-MM-dd").format(now);

    print("start Date : $startDate");
    print("End Date : $endDate");

    setState(() {
      communityLoading=true;
    });

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl, 'rest_api/get-all-announcements?start_date=$startDate&end_date=$endDate', token, context);
    //Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['error'] == false) {

      announcementList.clear();

      List<dynamic> tempList=[];
      tempList=responseJSON['data'];

      for(int i=tempList.length-1;i>=0;i--){
        announcementList.add(tempList[i]);
      }

      //announcementList=responseJSON['data'];



      setState(() {
        communityLoading=false;
      });
    }
    else if(responseJSON['code']==401 || responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        communityLoading=false;
      });

    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        communityLoading=false;
      });

    }
  }

}
