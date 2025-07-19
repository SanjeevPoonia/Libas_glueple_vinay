import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ChecklistTree/views/sidemenu/SideMenuHomeScreen.dart';
import 'package:ChecklistTree/views/store/store_dashboard.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toast/toast.dart';
import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_modal.dart';
import '../utils/app_theme.dart';

class LoginScreen extends StatefulWidget{
  loginState createState()=> loginState();
}
class loginState extends State<LoginScreen>{
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible=true;
  var emailId = "";
  Position? _currentPosition;

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
                      child: Image.asset("assets/checklistree_logo.png",height: 50,width: 150,),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
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
                        height: 450,
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
                                child: Text('Login to your Account.',
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
                                  controller: usernameController,
                                  validator: checkEmptyString,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Email / Employee Code",
                                    label: Text("Email / Employee Code"),
                                    /*suffixIcon: Icon(Icons.mail_rounded,color: AppTheme.themeColor,),*/
                                    enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color:AppTheme.orangeColor)),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 18),
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: passwordVisible,
                                  decoration: InputDecoration(
                                    hintText: "Enter Password",
                                    label: const Text("Password"),
                                    suffixIcon: IconButton(
                                      icon: Icon(passwordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility, color: AppTheme.themeColor,),
                                      onPressed: () {
                                        setState(
                                              () {
                                            passwordVisible = !passwordVisible;
                                          },
                                        );
                                      },
                                    ),
                                    alignLabelWithHint: false,
                                    filled: false,
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,

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
                                      child: Text('Login',
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
        ),
    );
  }

  void initState(){
    super.initState();

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
    FocusScope.of(context).unfocus();
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


      loginUser(context);





     // _getAddressFromLatLng(position);
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




  String? checkEmptyString(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);
    //if (value!.isEmpty || !regex.hasMatch(value)) {
    if (value!.isEmpty) {
      return 'Please enter Your Email or Employee Code';
    }
    return null;
  }

  void _submitHandler() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    _getCurrentPosition();
    //
  }




  loginUser(BuildContext context) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Logging in...');
    var data = {
      "email": usernameController.text,
      "password": passwordController.text,
      "fcm_token": passwordController.text,
      "latitude": _currentPosition!.latitude,
      "longitude": _currentPosition!.longitude,
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('login_employee', data, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);

    if(responseJSON["status"]==200)
    {
      Toast.show("Logged In successfully!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      AppModel.setTokenValue(responseJSON["data"]['remember_token']);

      MyUtils.saveSharedPreferences("base_url", "https://libas.glueple.in:3019/");

      MyUtils.saveSharedPreferences(
          'access_token', responseJSON["data"]['remember_token']);

    /*  MyUtils.saveSharedPreferences(
          'access_token', responseJSON["data"]['full_name']);*/
      MyUtils.saveSharedPreferences(
          'user_id_libas', responseJSON["data"]['user_id'].toString());
      MyUtils.saveSharedPreferences(
          'email', responseJSON["data"]['email'].toString());
      AppModel.setUserID(responseJSON["data"]['user_id'].toString());
      MyUtils.saveSharedPreferences(
          'full_name', responseJSON["data"]['full_name'].toString());

      MyUtils.saveSharedPreferences(
          'emp_id', responseJSON["data"]['emp_id'].toString());
      if(responseJSON["data"]["type"]=="store")
        {
          MyUtils.saveSharedPreferences(
              'usertype', "store");

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => StoreDashboardScreen()));
        }
      else if(responseJSON["data"]["type"]=="employee")
        {
          MyUtils.saveSharedPreferences(
              'usertype', "employee");
          MyUtils.saveSharedPreferences(
              'token', responseJSON["data"]['glueple_token'].toString());

          MyUtils.saveSharedPreferences(
              'user_id', responseJSON["data"]['glueple_user_id'].toString());

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => SideMenuHomeScreen()));


        }







    }
    else
    {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }





    print(responseJSON);

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

}