import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ChecklistTree/views/gluple/utils/app_theme.dart';
import '../../login_screen.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';

class LandingScreen extends StatefulWidget{
  landingState createState()=> landingState();
}
class landingState extends State<LandingScreen>{
  var loginController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String offerLetter="0";
  String aadharVerification="0";
  String personsal_details="0";
  String family_details="0";
  String education_details="0";
  String bank_details="0";
  String social_details="0";
  String reference_details="0";
  String work_experience_details="0";
  String upload_documents="0";
  String policy="0";


  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppTheme.themeColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset("assets/logo_main_wh.png",height: 50,width: 150,),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          height: 400,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/back_img.png'),
                              fit: BoxFit.cover,
                            )
                          ),
                        )
                      ],
                    ),
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(height: 18),
                          Container(
                            height: 350,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              child: ListView(
                                children: [
                                  const SizedBox(height: 25),
                                  const Center(
                                    child: Text('Hello',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.orangeColor,
                                        )),
                                  ),
                                  const SizedBox(height: 10),
                                  const Center(
                                    child: Text('Please provide Organization Details.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        )),
                                  ),
                                  const SizedBox(height: 25),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 18),
                                    child: TextFormField(
                                      controller: loginController,
                                      validator: checkEmptyString,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        hintText: "Enter Organization Code",
                                        label: Text("Organization Code"),
                                        enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color:AppTheme.orangeColor)),
                                      ),
                                      textCapitalization: TextCapitalization.characters,
                                    ),
                                  ),
                                  const SizedBox(height: 35),
                                  InkWell(
                                    onTap: () {
                                      _submitHandler();

                                    },
                                    child: Container(
                                        margin:
                                        const EdgeInsets.symmetric(horizontal: 15),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: AppTheme.themeColor,
                                            borderRadius: BorderRadius.circular(5)),
                                        height: 50,
                                        child: const Center(
                                          child: Text('Next',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white)),
                                        )),
                                  ),
                                  const SizedBox(height: 40,),
                                  SvgPicture.asset("assets/powered_by.svg"),
                                  const SizedBox(height: 10),

                                ],
                              ),
                            ),
                          ),
                          SizedBox(height:MediaQuery.of(context).viewInsets.bottom)
                        ],
                      ))



                ],
      ),
    ));
  }
  String? checkEmptyString(String? value) {
    if (value!.isEmpty ) {
      return 'Please Enter Your Organization Code';
    }
    return null;
  }
  void _submitHandler() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    _getClientInfo();
    //
  }
  redirectFun(String baseUrl,String clientName,String clientCode){

      MyUtils.saveSharedPreferences('base_url', baseUrl);
      MyUtils.saveSharedPreferences('client_code', clientCode);
      MyUtils.saveSharedPreferences('client_name', clientName);

      MyUtils.saveSharedPreferences('offer_letter', offerLetter);
      MyUtils.saveSharedPreferences('aadhar_verification', aadharVerification);
      MyUtils.saveSharedPreferences('personal_details', personsal_details);
      MyUtils.saveSharedPreferences('family_details', family_details);
      MyUtils.saveSharedPreferences('education_details', education_details);
      MyUtils.saveSharedPreferences('bank_details', bank_details);
      MyUtils.saveSharedPreferences('social_details', social_details);
      MyUtils.saveSharedPreferences('reference_details', reference_details);
      MyUtils.saveSharedPreferences('work_experience_details', work_experience_details);
      MyUtils.saveSharedPreferences('upload_documents', upload_documents);
      MyUtils.saveSharedPreferences('policy', policy);
      MyUtils.saveSharedPreferences('offer_accepted', "0");
      MyUtils.saveSharedPreferences('aadhar_verify', "0");

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen()));
  }
  _getClientInfo() async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper = ApiBaseHelper();
    var response= await helper.getClientInfo("rest_api/get-client-info?code="+loginController.text, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      String clientName="";
      String baseUrl="";
      String clientCode="";



      List<dynamic> tempUserList=[];
      tempUserList=responseJSON['data'];

      if(tempUserList.isNotEmpty){
        clientName=tempUserList[0]['company_name'].toString();
        baseUrl=tempUserList[0]['base_url'].toString();
        clientCode=tempUserList[0]['code'].toString();

        offerLetter=tempUserList[0]['modules_permission']['onboard_steps']['offer_letter'].toString();
        aadharVerification=tempUserList[0]['modules_permission']['onboard_steps']['aadhar_validation'].toString();
        personsal_details=tempUserList[0]['modules_permission']['onboard_steps']['personsal_details'].toString();
        family_details=tempUserList[0]['modules_permission']['onboard_steps']['family_details'].toString();
        education_details=tempUserList[0]['modules_permission']['onboard_steps']['education_details'].toString();
        bank_details=tempUserList[0]['modules_permission']['onboard_steps']['bank_details'].toString();
        social_details=tempUserList[0]['modules_permission']['onboard_steps']['social_details'].toString();
        reference_details=tempUserList[0]['modules_permission']['onboard_steps']['reference_details'].toString();
        work_experience_details=tempUserList[0]['modules_permission']['onboard_steps']['work_experience_details'].toString();
        upload_documents=tempUserList[0]['modules_permission']['onboard_steps']['upload_documents'].toString();
        policy=tempUserList[0]['modules_permission']['onboard_steps']['policy'].toString();
      }



      _showCustomDialog(clientName, baseUrl+"/",clientCode);
     // _showAttendanceBottomDialog(clientName, "$baseUrl/", clientCode);
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  /*_showConfirmDialog(String clientName,String baseUrl,String clientCode){

    showDialog(context: context, builder: (ctx)=>AlertDialog(
        title: const Text("Confirm Information",
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 18),),
          content: Container(
            height: 200,
            width: double.infinity,
            child: Column(
              children: [
                Text("Organization Name", style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.greyColor,
                    fontSize: 18
                ),),
                SizedBox(height: 10,),
                Text(clientName, style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.themeColor,
                    fontSize: 18
                ),),
                SizedBox(height: 10,),
              ],
            ),
          ),
        actions: <Widget>[
          TextButton(
              onPressed: (){
                Navigator.of(ctx).pop();
                redirectFun(baseUrl);
                //call attendance punch in or out
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme.themeColor,
                ),
                height: 45,
                padding: const EdgeInsets.all(10),
                child: const Center(child: Text("Confirm",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
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
        ]
    ));
  }*/

  _showCustomDialog(String clientName,String baseUrl,String clientCode){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Confirm Organization !",style: TextStyle(color: AppTheme.themeColor,fontWeight: FontWeight.w500,fontSize: 18),),
                    SizedBox(height: 20,),
                    Text(clientName,style: TextStyle(color: AppTheme.orangeColor,fontWeight: FontWeight.w900,fontSize: 18),),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                              redirectFun(baseUrl,clientName,clientCode);
                              //call attendance punch in or out
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppTheme.themeColor,
                              ),
                              height: 45,
                              padding: const EdgeInsets.all(10),
                              child: const Center(child: Text("Confirm",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
                            )
                        )),
                        SizedBox(width: 5,),
                        Expanded(child: TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
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
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showAttendanceBottomDialog(String clientName,String baseUrl,String clientCode){

    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (BuildContext contx){
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
            ),
            child: Wrap(
              children: [
                Column(

                  children: [
                    SizedBox(height: 20,),
                    Align(alignment: Alignment.center, child: Container(height: 5,width: 30,color: AppTheme.greyColor,),),
                    SizedBox(height: 10,),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(child: Text("Confirm Organization!",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black,fontSize: 18.5),)),
                          SizedBox(width: 5,),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.close_rounded,color: AppTheme.greyColor,size: 32,),
                          ),
                          SizedBox(width: 5,),

                        ],
                      ),),
                    SizedBox(height: 10,),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(clientName,textAlign:TextAlign.center,style: TextStyle(color: AppTheme.orangeColor,fontWeight: FontWeight.w900,fontSize: 18),),),
                    SizedBox(height: 10,),



                    SizedBox(height: 20,),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                              redirectFun(baseUrl,clientName,clientCode);
                              //call attendance punch in or out
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppTheme.themeColor,
                              ),
                              height: 45,
                              padding: const EdgeInsets.all(10),
                              child: const Center(child: Text("Confirm",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
                            )
                        )),
                        SizedBox(width: 5,),
                        Expanded(child: TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
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
                        )),
                      ],
                    ) ,
                    )



                  ],
                )
              ],
            ),
          );
        });
  }
  
}