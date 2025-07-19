import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ChecklistTree/views/gluple/attendance/ShowTeamAttendance.dart';
import 'package:ChecklistTree/views/gluple/utils/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import 'dart:io';

import '../network/api_helper.dart';
import '../views/login_screen.dart';
import 'package:ChecklistTree/views/login_screen.dart';

class TeamAttendance extends StatefulWidget{
  _teamAttendance createState()=>_teamAttendance();
}
class _teamAttendance extends State<TeamAttendance>{
  var userIdStr="";
  var designationStr="";
  var token="";
  var fullNameStr="";
  var empId="";
  var baseUrl="";
  var clientCode="";
  var platform="";
  bool isLoading=false;
  List<dynamic> teamList=[];
  List<dynamic>searchList=[];
  var searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return isLoading?Container():
        teamList.isEmpty?const Center(
           child:  Text("No Team Member Found!!!",style: TextStyle(fontSize: 18,
               fontWeight: FontWeight.w500,
               color: AppTheme.orangeColor),
            )
        ):
            Form(
                key: _formKey,
                child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      hintText: 'Find',
                    ),
                  ),),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: searchList.length,
                      itemBuilder: (BuildContext cntx,int indx){
                        String empName="";
                        String empProfile="";
                        String empId="";
                        String empDesignation="";
                        if(searchList[indx]['employee_name']!=null){
                          empName=searchList[indx]['employee_name'].toString();
                        }
                        if(searchList[indx]['profile_photo']!=null){
                          empProfile=searchList[indx]['profile_photo'].toString();
                        }
                        if(searchList[indx]['emp_id']!=null){
                          empId=searchList[indx]['emp_id'].toString();
                        }
                        if(searchList[indx]['employee_designation']!=null){
                          empDesignation=searchList[indx]['employee_designation'].toString();
                        }

                        return InkWell(
                          child: Card(
                            margin: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  empProfile==""?
                                  CircleAvatar(
                                    backgroundImage: AssetImage("assets/profile.png"),
                                    radius: 30,)
                                      :
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(60.0),
                                    child: CachedNetworkImage(
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      imageUrl: empProfile,
                                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                                          CircularProgressIndicator(value: downloadProgress.progress),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                    //child: Image.network(empProfile,width: 60,height: 60,fit: BoxFit.cover,),

                                  ),

                                  SizedBox(width: 10,),
                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(empName,
                                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900,color: Colors.black),),
                                      SizedBox(height: 5,),
                                      Text("$empId  |  $empDesignation",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
                                    ],
                                  ),flex: 1,)

                                ],
                              ),
                            ),
                          ),
                          onTap: (){
                            FocusScope.of(context).unfocus();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ShowTeamAttendance(empId, empDesignation, empName, empProfile)),);
                          },
                        );



                      })
                ],
              ),
            )
            );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _getUserData();
    });
    searchController.addListener(() {
      _searchUser();
    });


  }
  _getUserData() async {
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


    if(Platform.isAndroid){
      platform="Android";
    }else if(Platform.isIOS){
      platform="iOS";
    }else{
      platform="Other";
    }


    Navigator.of(context).pop();

    getTeamsDetails();

  }
  getTeamsDetails() async {

    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl, 'common_api/get-all-team?emp_id='+empId, token, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      teamList.clear();
      teamList=responseJSON['data'];
      searchList.addAll(teamList);
      setState(() {
        isLoading=false;
      });
    }
    else if(responseJSON['code']==401 || responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        isLoading=false;
      });
      _logOut(context);
    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        isLoading=false;
      });

    }
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
  void dispose() {
   searchController.dispose();
    super.dispose();
  }

  _searchUser(){
    searchList.clear();
    String textCont=searchController.text;
    if(textCont.isEmpty){
      searchList.addAll(teamList);
    }
    else{
      for(int i=0;i<teamList.length;i++){
        String name="";
        if(teamList[i]['employee_name']!=null){
          name=teamList[i]['employee_name'].toString();
          if(name.toLowerCase().contains(textCont.toLowerCase())){
            searchList.add(teamList[i]);
          }

        }
      }
    }
    setState(() {

    });
  }

}