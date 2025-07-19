// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:glueple_flutter/on_boarding/BankDetails_Screen.dart';
// import 'package:glueple_flutter/on_boarding/EducationDetails_Screen.dart';
// import 'package:glueple_flutter/on_boarding/FamilyDetails_Screen.dart';
// import 'package:glueple_flutter/on_boarding/PolicyDetails_Screen.dart';
// import 'package:glueple_flutter/on_boarding/UploadDocumentScreen.dart';
// import 'package:glueple_flutter/on_boarding/WorkExperience_Screen.dart';
// import 'package:glueple_flutter/views/ShowOfferLetterScreen.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lottie/lottie.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:toast/toast.dart';
//
// import '../network/Utils.dart';
// import '../network/api_dialog.dart';
// import '../network/api_helper.dart';
// import '../utils/app_theme.dart';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:http_parser/http_parser.dart';
//
// import 'PersonalDetails_Screen.dart';
//
// class ProfileScreen extends StatefulWidget{
//   _profileScreen createState()=>_profileScreen();
// }
// class _profileScreen extends State<ProfileScreen>{
//   bool isLoading=false;
//   late var userIdStr;
//   late var fullNameStr;
//   late var designationStr;
//   late var token;
//   late var empId;
//   late var baseUrl;
//   var clientCode="";
//
//
//   String employeeIdStr="";
//   String NameStr="";
//   String joiningDate="";
//   String mobileNoStr="";
//   String emailStr="";
//   String departmentStr="";
//   String desiStr="";
//   String reportingManager="";
//
//   int offerLaterStatus=0;
//   int offerRejectedStatus=0;
//   int personalDetailsStatus=0;
//   int familyDetailsStatus=0;
//   int educationDetailsStatus=0;
//   int bankDetailsStatus=0;
//   int socialDetailsStatus=0;
//   int workExperienceDetailsStatus=0;
//   int referenceDetailsStatus=0;
//   int empPolicyDetyailsStatus=0;
//   int documentDetailsStatus=0;
//
//   String profileImage="";
//
//   XFile? imageFile;
//   File? file;
//
//
//   @override
//   Widget build(BuildContext context) {
//     ToastContext().init(context);
//     return isLoading?SizedBox():SingleChildScrollView(
//       child: Column(
//         children: [
//           SizedBox(height: 10,),
//           Container(
//             margin: EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 8,),
//             decoration: BoxDecoration(
//                 border: Border.all(
//                   color: AppTheme.orangeColor, // Set the border color here
//                   width: 1.0, // Set the border width
//                 ),
//                 borderRadius: const BorderRadius.all(Radius.circular(10))),
//             child: Column(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(10.0),  // Adjust the top-left corner radius
//                     topRight: Radius.circular(10.0), // Adjust the top-right corner radius
//                   ),
//                   child: Container(
//                     height: 40,
//                     color: AppTheme.orangeColor,
//                     child: Center(
//                       child: Text(
//                         "Employee Information",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10,),
//
//                 Padding(padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: Column(
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//
//                           Container(
//                             height: 100,
//                             width: 100,
//                             child: Stack(
//                               children: [
//                                 InkWell(
//                                   onTap: (){
//                                     _showAlertDialog();
//                                   },
//                                   child: profileImage==""?
//                                   CircleAvatar(
//                                     backgroundImage: AssetImage("assets/profile.png"),
//                                     radius: 50,)
//                                       :
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(100.0),
//                                     child: Image.network(profileImage,width: 100,height: 100,fit: BoxFit.cover,),),
//                                 ),
//                                 Positioned(
//                                   right: 5,
//                                   bottom: 5,
//                                   child:  InkWell(
//                                     onTap: (){
//                                       _showAlertDialog();
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: AppTheme.orangeColor),
//                                       width: 30,
//                                       height: 30,
//                                       child: Align(
//                                         alignment: Alignment.center,
//                                         child: Icon(Icons.edit,color: Colors.white,size: 20,),
//                                       ),
//
//                                     ),
//                                   ),)
//                               ],
//
//                             ),
//                           ),
//
//                           SizedBox(width: 10,),
//                           Expanded(child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Name",style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black
//                               ),),
//                               SizedBox(height: 5,),
//                               Text(NameStr,style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w900,
//                                   color: AppTheme.themeColor
//                               ),),
//                             ],
//                           ))
//                         ],
//                       ),
//                       SizedBox(height: 10,),
//                       Row(
//                         children: [
//                           Expanded(child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Employee Id",style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black
//                               ),),
//                               SizedBox(height: 5,),
//                               Text(employeeIdStr,style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w900,
//                                   color: AppTheme.themeColor
//                               ),),
//                             ],
//                           )),
//                           SizedBox(width: 5,),
//                           Expanded(child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Joining Date",style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black
//                               ),),
//                               SizedBox(height: 5,),
//                               Text(joiningDate,style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w900,
//                                   color: AppTheme.themeColor
//                               ),),
//                             ],
//                           ))
//                         ],
//                       ),
//                       SizedBox(height: 10,),
//                       Row(
//                         children: [
//                           Expanded(child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Mobile Number",style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black
//                               ),),
//                               SizedBox(height: 5,),
//                               Text(mobileNoStr,style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w900,
//                                   color: AppTheme.themeColor
//                               ),),
//                             ],
//                           )),
//                           SizedBox(width: 5,),
//                           Expanded(child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Email",style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black
//                               ),),
//                               SizedBox(height: 5,),
//                               Text(emailStr,style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w900,
//                                   color: AppTheme.themeColor
//                               ),),
//                             ],
//                           ))
//                         ],
//                       ),
//                       SizedBox(height: 10,),
//                       Row(
//                         children: [
//                           Expanded(child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Department",style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black
//                               ),),
//                               SizedBox(height: 5,),
//                               Text(departmentStr,style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w900,
//                                   color: AppTheme.themeColor
//                               ),),
//                             ],
//                           )),
//                           SizedBox(width: 5,),
//                           Expanded(child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Designation",style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black
//                               ),),
//                               SizedBox(height: 5,),
//                               Text(desiStr,style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w900,
//                                   color: AppTheme.themeColor
//                               ),),
//                             ],
//                           ))
//                         ],
//                       ),
//                       SizedBox(height: 10,),
//                       Row(
//                         children: [
//                           Expanded(child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Reporting Manager",style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black
//                               ),),
//                               SizedBox(height: 5,),
//                               Text(reportingManager,style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w900,
//                                   color: AppTheme.themeColor
//                               ),),
//                             ],
//                           )),
//                         ],
//                       ),
//                       SizedBox(height: 10,),
//
//                       clientCode=='UB100'?
//                       Row(
//                         children: [
//                           Expanded(child: TextButton(
//                               onPressed: (){
//                                 getUserLetter("offer_letter");
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: AppTheme.orangeColor,
//                                 ),
//                                 height: 45,
//                                 child: const Center(child: Text("View Offer Letter",textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 13,color: Colors.white),),),
//                               )
//                           ),),
//                           SizedBox(width: 5,),
//                           Expanded(child: TextButton(
//                               onPressed: (){
//                                 getUserLetter("appointment_letter");
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: AppTheme.themeColor,
//                                 ),
//                                 height: 45,
//                                 child: const Center(child: Text("View Appointment Letter",textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 13,color: Colors.white),),),
//                               )
//                           ),),
//                         ],
//                       ):SizedBox(height: 2,),
//
//
//                     ],
//                   ),)
//
//
//
//
//
//
//
//               ],
//             ),
//           ),
//
//
//
//           Row(
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=>PersonalDetailScreen(true)));
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 8,),
//                     decoration: BoxDecoration(
//                         border: Border.all(
//                           color: AppTheme.orangeColor, // Set the border color here
//                           width: 1.0, // Set the border width
//                         ),
//                         borderRadius: const BorderRadius.all(Radius.circular(10))),
//                     child: Column(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10.0),  // Adjust the top-left corner radius
//                             topRight: Radius.circular(10.0), // Adjust the top-right corner radius
//                           ),
//                           child: Container(
//                             height: 20,
//                             color: personalDetailsStatus==1?AppTheme.onBoarding_Completed:Colors.red,
//                             child: Center(
//                               child: Text(
//                                 personalDetailsStatus==1?'Status : 100% Complete':'Status : 0% Complete',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Center(
//                           child: Lottie.asset('assets/book.json',
//                             height: 120,
//                             width: 100,),
//                         ),
//                         SizedBox(height: 10.0),
//                         Text('Personal Details',
//                           style: TextStyle(
//                               fontSize: 14.0,
//                               color: Colors.black// Set the desired font size
//                           ),
//                         ),
//                         SizedBox(height: 15.0),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=>FamilyDetailsScreen(true)));
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(left: 8, right: 16, top: 16, bottom: 8,),
//                     decoration: BoxDecoration(
//                         border: Border.all(
//                           color: AppTheme.orangeColor, // Set the border color here
//                           width: 1.0, // Set the border width
//                         ),
//                         borderRadius: const BorderRadius.all(Radius.circular(10))),
//                     child: Column(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10.0),  // Adjust the top-left corner radius
//                             topRight: Radius.circular(10.0), // Adjust the top-right corner radius
//                           ),
//                           child: Container(
//                             height: 20,
//                             color: familyDetailsStatus==1?AppTheme.onBoarding_Completed:Colors.red,
//                             child: Center(
//                               child: Text(
//                                 familyDetailsStatus==1?'Status : 100% Complete':'Status : 0% Complete',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Center(
//                           child: Lottie.asset('assets/family.json',
//                             height: 120,
//                             width: 180,),
//                         ),
//                         SizedBox(height: 10.0),
//                         Text('Family Details',
//                           style: TextStyle(
//                               fontSize: 14.0,
//                               color: Colors.black// Set the desired font size
//                           ),
//                         ),
//                         SizedBox(height: 15.0),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=>EducationDetailsScreen(true)));
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8,),
//                     decoration: BoxDecoration(
//                         border: Border.all(
//                           color: AppTheme.orangeColor, // Set the border color here
//                           width: 1.0, // Set the border width
//                         ),
//                         borderRadius: const BorderRadius.all(Radius.circular(10))),
//                     child: Column(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10.0),  // Adjust the top-left corner radius
//                             topRight: Radius.circular(10.0), // Adjust the top-right corner radius
//                           ),
//                           child: Container(
//                             height: 20,
//                             color: educationDetailsStatus==1?AppTheme.onBoarding_Completed:Colors.red,
//                             child: Center(
//                               child: Text(
//                                 educationDetailsStatus==1?'Status : 100% Complete':'Status : 0% Complete',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Center(
//                           child: Lottie.asset('assets/distance.json',
//                             height: 120,
//                             width: 180,),
//                         ),
//                         SizedBox(height: 10.0),
//                         Text('Education Details',
//                           style: TextStyle(
//                               fontSize: 14.0,
//                               color: Colors.black// Set the desired font size
//                           ),
//                         ),
//                         SizedBox(height: 15.0),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=>BankDetailsScreen(true)));
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 8,),
//                     decoration: BoxDecoration(
//                         border: Border.all(
//                           color: AppTheme.orangeColor, // Set the border color here
//                           width: 1.0, // Set the border width
//                         ),
//                         borderRadius: const BorderRadius.all(Radius.circular(10))),
//                     child: Column(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10.0),  // Adjust the top-left corner radius
//                             topRight: Radius.circular(10.0), // Adjust the top-right corner radius
//                           ),
//                           child: Container(
//                             height: 20,
//                             color: bankDetailsStatus==1?AppTheme.onBoarding_Completed:Colors.red,
//                             child: Center(
//                               child: Text(
//                                 bankDetailsStatus==1?'Status : 100% Complete':'Status : 0% Complete',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Center(
//                           child: Lottie.asset('assets/bank.json',
//                             height: 120,
//                             width: 180,),
//                         ),
//                         SizedBox(height: 10.0),
//                         Text('Bank Details',
//                           style: TextStyle(
//                               fontSize: 14.0,
//                               color: Colors.black// Set the desired font size
//                           ),
//                         ),
//                         SizedBox(height: 15.0),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=>WorkExperienceScreen(true)));
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8,),
//                     decoration: BoxDecoration(
//                         border: Border.all(
//                           color: AppTheme.orangeColor, // Set the border color here
//                           width: 1.0, // Set the border width
//                         ),
//                         borderRadius: const BorderRadius.all(Radius.circular(10))),
//                     child: Column(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10.0),  // Adjust the top-left corner radius
//                             topRight: Radius.circular(10.0), // Adjust the top-right corner radius
//                           ),
//                           child: Container(
//                             height: 20,
//                             color: workExperienceDetailsStatus==1?AppTheme.onBoarding_Completed:Colors.red,
//                             child: Center(
//                               child: Text(
//                                 workExperienceDetailsStatus==1?'Status : 100% Complete':'Status : 0% Complete',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Center(
//                           child: Lottie.asset('assets/workExp.json',
//                             height: 120,
//                             width: 130,),
//                         ),
//                         SizedBox(height: 10.0),
//                         Text('Work Experience',
//                           style: TextStyle(
//                               fontSize: 14.0,
//                               color: Colors.black// Set the desired font size
//                           ),
//                         ),
//                         SizedBox(height: 15.0),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadDocumentScreen(true)));
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 8,),
//                     decoration: BoxDecoration(
//                         border: Border.all(
//                           color: AppTheme.orangeColor, // Set the border color here
//                           width: 1.0, // Set the border width
//                         ),
//                         borderRadius: const BorderRadius.all(Radius.circular(10))),
//                     child: Column(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10.0),  // Adjust the top-left corner radius
//                             topRight: Radius.circular(10.0), // Adjust the top-right corner radius
//                           ),
//                           child: Container(
//                             height: 20,
//                             color: documentDetailsStatus==1?AppTheme.onBoarding_Completed:Colors.red,
//                             child: Center(
//                               child: Text(
//                                 documentDetailsStatus==1?'Status : 100% Complete':'Status : 0% Complete',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Center(
//                           child: Lottie.asset('assets/id.json',
//                             height: 120,
//                             width: 180,),
//                         ),
//                         SizedBox(height: 10.0),
//                         Text('Documents',
//                           style: TextStyle(
//                               fontSize: 14.0,
//                               color: Colors.black// Set the desired font size
//                           ),
//                         ),
//                         SizedBox(height: 15.0),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               /* Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       // Navigator.push(context, MaterialPageRoute(builder: (context)=>SocialMediaDetailsScreen(true)));
//                     },
//                     child: Container(
//                       margin: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8,),
//                       decoration: BoxDecoration(
//                           border: Border.all(
//                             color: AppTheme.orangeColor, // Set the border color here
//                             width: 1.0, // Set the border width
//                           ),
//                           borderRadius: const BorderRadius.all(Radius.circular(10))),
//                       child: Column(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(10.0),  // Adjust the top-left corner radius
//                               topRight: Radius.circular(10.0), // Adjust the top-right corner radius
//                             ),
//                             child: Container(
//                               height: 20,
//                               color: Color(0xFF1BA967),
//                               child: Center(
//                                 child: Text(
//                                   'Status : 100% Complete',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Center(
//                             child: Lottie.asset('assets/social.json',
//                               height: 120,
//                               width: 130,),
//                           ),
//                           SizedBox(height: 10.0),
//                           Text('Social Media Details',
//                             style: TextStyle(
//                                 fontSize: 14.0,
//                                 color: Colors.black// Set the desired font size
//                             ),
//                           ),
//                           SizedBox(height: 15.0),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),*/
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=>PolicyDetailsScreen(true,empPolicyDetyailsStatus)));
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 8,),
//                     decoration: BoxDecoration(
//                         border: Border.all(
//                           color: AppTheme.orangeColor, // Set the border color here
//                           width: 1.0, // Set the border width
//                         ),
//                         borderRadius: const BorderRadius.all(Radius.circular(10))),
//                     child: Column(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10.0),  // Adjust the top-left corner radius
//                             topRight: Radius.circular(10.0), // Adjust the top-right corner radius
//                           ),
//                           child: Container(
//                             height: 20,
//                             color: empPolicyDetyailsStatus==1?AppTheme.onBoarding_Completed:Colors.red,
//                             child: Center(
//                               child: Text(
//                                 empPolicyDetyailsStatus==1?'Status : 100% Complete':'Status : 0% Complete',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Center(
//                           child: Lottie.asset('assets/policy.json',
//                             height: 120,
//                             width: 180,),
//                         ),
//                         SizedBox(height: 10.0),
//                         Text('Company Policies',
//                           style: TextStyle(
//                               fontSize: 14.0,
//                               color: Colors.black// Set the desired font size
//                           ),
//                         ),
//                         SizedBox(height: 15.0),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//
//   }
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(milliseconds: 0), () {
//       _getDashboardData();
//     });
//   }
//   _getDashboardData() async {
//     setState(() {
//       isLoading=true;
//     });
//     APIDialog.showAlertDialog(context, 'Please Wait...');
//     userIdStr=await MyUtils.getSharedPreferences("user_id");
//     fullNameStr=await MyUtils.getSharedPreferences("full_name");
//     token=await MyUtils.getSharedPreferences("token");
//     designationStr=await MyUtils.getSharedPreferences("designation");
//     empId=await MyUtils.getSharedPreferences("emp_id");
//     baseUrl=await MyUtils.getSharedPreferences("base_url");
//     clientCode=await MyUtils.getSharedPreferences("client_code")??"";
//     Navigator.of(context).pop();
//     getUserProfile();
//   }
//   getUserProfile() async {
//
//     setState(() {
//       isLoading=true;
//     });
//     APIDialog.showAlertDialog(context, 'Please Wait...');
//     ApiBaseHelper helper = ApiBaseHelper();
//     var response = await helper.getWithToken(baseUrl, 'employee/getEmployeeProfileDetails', token, context);
//     Navigator.pop(context);
//     var responseJSON = json.decode(response.body);
//     print(responseJSON);
//     if (responseJSON['error'] == false) {
//
//       List<dynamic> tempList=responseJSON['data'];
//       for(int i=0;i<tempList.length;i++){
//         employeeIdStr=tempList[i]['emp_id'].toString();
//         if(tempList[i]['first_name']!=null){
//           NameStr=tempList[i]['first_name'].toString();
//         }
//         if(tempList[i]['last_name']!=null){
//           NameStr="$NameStr ${tempList[i]['last_name']}";
//         }
//         joiningDate=tempList[i]['joining_date'].toString();
//         mobileNoStr=tempList[i]['mobile'].toString();
//         emailStr=tempList[i]['email'].toString();
//         departmentStr=tempList[i]['employeee_department'].toString();
//         desiStr=tempList[i]['employee_designation'].toString();
//         reportingManager=tempList[i]['reporting_manager_name'].toString();
//       }
//
//       setState(() {
//         isLoading=false;
//       });
//       getUserProfileStatus();
//     }
//     else {
//       Toast.show(responseJSON['message'],
//           duration: Toast.lengthLong,
//           gravity: Toast.bottom,
//           backgroundColor: Colors.red);
//       setState(() {
//         isLoading=false;
//       });
//       getUserProfileStatus();
//     }
//   }
//   getUserProfileStatus() async{
//
//     setState(() {
//       isLoading=true;
//     });
//     APIDialog.showAlertDialog(context, "Please wait...");
//     ApiBaseHelper helper= ApiBaseHelper();
//     var response=await helper.getWithToken(baseUrl,"employee/getEmployeeProfileDetailStatus?",token, context);
//     Navigator.pop(context);
//     var responseJSON = json.decode(response.body);
//     print(responseJSON);
//     if (responseJSON['error'] == false) {
//
//       List<dynamic> tempUserList=[];
//       tempUserList=responseJSON['data'];
//       for(int i=0;i<tempUserList.length;i++){
//         offerLaterStatus=tempUserList[i]['offer_letter_status'];
//         offerRejectedStatus=tempUserList[i]['offer_letter_rejection_status'];
//         personalDetailsStatus=tempUserList[i]['personal_details_status'];
//         familyDetailsStatus=tempUserList[i]['family_details_status'];
//         educationDetailsStatus=tempUserList[i]['education_detail_status'];
//         bankDetailsStatus=tempUserList[i]['bank_details_status'];
//         socialDetailsStatus=tempUserList[i]['social_detail_status'];
//         workExperienceDetailsStatus=tempUserList[i]['work_experience_detail_status'];
//         referenceDetailsStatus=tempUserList[i]['reference_detail_status'];
//         empPolicyDetyailsStatus=tempUserList[i]['emp_policy_status'];
//         documentDetailsStatus=tempUserList[i]['documents_details_status'];
//       }
//
//
//     } else {
//       Toast.show(responseJSON['message'],
//           duration: Toast.lengthLong,
//           gravity: Toast.bottom,
//           backgroundColor: Colors.red);
//     }
//
//     setState(() {
//       isLoading=false;
//     });
//     getUserProfileImage();
//
//   }
//   getUserProfileImage() async{
//
//     setState(() {
//       isLoading=true;
//     });
//     APIDialog.showAlertDialog(context, "Please wait...");
//     ApiBaseHelper helper= ApiBaseHelper();
//     var response=await helper.getWithToken(baseUrl,"employee/getEmployeeProfilePic",token, context);
//     Navigator.pop(context);
//     var responseJSON = json.decode(response.body);
//     print(responseJSON);
//     if (responseJSON['error'] == false) {
//
//       List<dynamic> tempUserList=[];
//       tempUserList=responseJSON['data']['data'];
//       String rootPath=responseJSON['data']['root_path'].toString();
//       String fileName="";
//       for(int i=0;i<tempUserList.length;i++){
//         fileName=tempUserList[i]['filename'].toString();
//       }
//
//       if(fileName.isNotEmpty){
//         profileImage="$rootPath/$fileName";
//       }
//
//
//     } /*else {
//       Toast.show(responseJSON['message'],
//           duration: Toast.lengthLong,
//           gravity: Toast.bottom,
//           backgroundColor: Colors.red);
//     }*/
//
//     setState(() {
//       isLoading=false;
//     });
//
//   }
//   _showAlertDialog(){
//     showDialog(context: context, builder: (ctx)=> AlertDialog(
//       title: const Text("Profile Image",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 18),),
//       content: const Text("Select the Image From",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16,color: Colors.black),),
//       actions: <Widget>[
//         TextButton(
//             onPressed: (){
//               Navigator.of(ctx).pop();
//               //prepairGallery();
//               imageSelectorFromGallery(context);
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: AppTheme.themeColor,
//               ),
//               height: 45,
//               padding: const EdgeInsets.all(10),
//               child: const Center(child: Text("Gallery",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
//             )
//         ),
//         TextButton(
//             onPressed: (){
//               Navigator.of(ctx).pop();
//               prepairCamera();
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: AppTheme.orangeColor,
//               ),
//               height: 45,
//               padding: const EdgeInsets.all(10),
//               child: const Center(child: Text("Camera",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
//             )
//         )
//       ],
//     ));
//   }
//   /**********Capture Image From Camera*************/
//   Future<void> prepairCamera() async{
//     /*APIDialog.showAlertDialog(context, "Preparing Camera..");
//     final hasPermission = await _handleCameraPermission();
//     if (!hasPermission) {
//       Navigator.of(context).pop();
//       _showCameraPermissionCustomDialog();
//       return;
//     }
//     Navigator.of(context).pop();*/
//     imageSelector(context);
//     //prepairCamera();
//
//   }
//   Future<void> prepairGallery() async{
//     APIDialog.showAlertDialog(context, "Preparing Gallery..");
//     final hasPermission = await _handleGalleryPermission();
//     if (!hasPermission) {
//       Navigator.of(context).pop();
//       _showReadImagePermissionCustomDialog();
//       return;
//     }
//     Navigator.of(context).pop();
//     imageSelectorFromGallery(context);
//     //prepairCamera();
//
//   }
//   Future<bool> _handleCameraPermission() async{
//     bool serviceEnabled;
//     PermissionStatus status=await Permission.camera.status;
//     if(status.isGranted){
//       serviceEnabled = true;
//     }else if(status.isPermanentlyDenied){
//       serviceEnabled=false;
//     }else{
//       var camStatus=await Permission.camera.request();
//       if(camStatus.isGranted){
//         serviceEnabled = true;
//       }else{
//         serviceEnabled = false;
//       }
//     }
//     return serviceEnabled;
//   }
//   Future<bool> _handleGalleryPermission() async{
//     bool serviceEnabled;
//     PermissionStatus status=await Permission.storage.status;
//     if(status.isGranted){
//       serviceEnabled = true;
//     }else if(status.isPermanentlyDenied){
//       serviceEnabled=false;
//     }else{
//       var camStatus=await Permission.storage.request();
//       if(camStatus.isGranted){
//         serviceEnabled = true;
//       }else{
//         serviceEnabled = false;
//       }
//     }
//     return serviceEnabled;
//   }
//   _showCameraPermissionCustomDialog(){
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius:
//                 BorderRadius.circular(20.0)), //this right here
//             child: Container(
//               height: 300,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: InkWell(
//                         onTap: (){
//                           Navigator.of(context).pop();
//                         },
//                         child: Icon(Icons.close_rounded,color: Colors.red,size: 20,),
//                       ),
//                     ),
//                     SizedBox(height: 20,),
//                     Text(
//                       "Please allow Camera Permissions For Capture Image",
//                       style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 14),),
//
//                     SizedBox(height: 20,),
//                     TextButton(
//                         onPressed: (){
//                           Navigator.of(context).pop();
//                           //call attendance punch in or out
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: AppTheme.themeColor,
//                           ),
//                           height: 45,
//                           padding: const EdgeInsets.all(10),
//                           child: const Center(child: Text("OK",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
//                         )
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }
//   _showReadImagePermissionCustomDialog(){
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius:
//                 BorderRadius.circular(20.0)), //this right here
//             child: Container(
//               height: 300,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: InkWell(
//                         onTap: (){
//                           Navigator.of(context).pop();
//                         },
//                         child: Icon(Icons.close_rounded,color: Colors.red,size: 20,),
//                       ),
//                     ),
//                     SizedBox(height: 20,),
//                     Text(
//                       "Please allow Read Images Permission for Browse Image from Gallery",
//                       style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 14),),
//
//                     SizedBox(height: 20,),
//                     TextButton(
//                         onPressed: (){
//                           Navigator.of(context).pop();
//                           //call attendance punch in or out
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: AppTheme.themeColor,
//                           ),
//                           height: 45,
//                           padding: const EdgeInsets.all(10),
//                           child: const Center(child: Text("OK",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
//                         )
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }
//   imageSelectorFromGallery(BuildContext context) async {
//     imageFile = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 60);
//     if(imageFile!=null){
//       file=File(imageFile!.path);
//
//       final imageFiles = imageFile;
//       if (imageFiles != null) {
//         print("You selected  image : " + imageFiles.path.toString());
//         setState(() {
//           debugPrint("SELECTED IMAGE PICK   $imageFiles");
//         });
//
//         _showImageDialog();
//
//       } else {
//         print("You have not taken image");
//       }
//     }else{
//       Toast.show("Unable to Browse Image. Please try Again...",
//           duration: Toast.lengthLong,
//           gravity: Toast.bottom,
//           backgroundColor: Colors.red);
//     }
//   }
//   imageSelector(BuildContext context) async{
//
//     imageFile = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 60,preferredCameraDevice: CameraDevice.front);
//
//     if(imageFile!=null){
//       file=File(imageFile!.path);
//
//       final imageFiles = imageFile;
//       if (imageFiles != null) {
//         print("You selected  image : " + imageFiles.path.toString());
//         setState(() {
//           debugPrint("SELECTED IMAGE PICK   $imageFiles");
//         });
//
//         _showImageDialog();
//
//       } else {
//         print("You have not taken image");
//       }
//     }else{
//       Toast.show("Unable to capture Image. Please try Again...",
//           duration: Toast.lengthLong,
//           gravity: Toast.bottom,
//           backgroundColor: Colors.red);
//     }
//
//
//   }
//   _showImageDialog(){
//
//     showDialog(context: context, builder: (ctx)=>AlertDialog(
//         title: const Text("Upload Profile Image",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 18),),
//         content: Container(
//           width: double.infinity,
//           height: 300,
//           decoration: BoxDecoration(
//             color: Colors.grey,
//             shape: BoxShape.rectangle,
//             image: DecorationImage(
//                 image: FileImage(file!),
//                 fit: BoxFit.cover
//             ),
//
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//               onPressed: (){
//                 Navigator.of(ctx).pop();
//                 UploadImage();
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: AppTheme.themeColor,
//                 ),
//                 height: 45,
//                 padding: const EdgeInsets.all(10),
//                 child: const Center(child: Text("Upload",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
//               )
//           ),
//           TextButton(
//               onPressed: (){
//                 Navigator.of(ctx).pop();
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: AppTheme.greyColor,
//                 ),
//                 height: 45,
//                 padding: const EdgeInsets.all(10),
//                 child: const Center(child: Text("Cancel",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
//               )
//           )
//         ]
//     ));
//   }
//   UploadImage() async{
//     APIDialog.showAlertDialog(context, 'Uploading Profile Image...');
//     String fileName = imageFile!.path.split('/').last;
//     String extension = fileName.split('.').last;
//
//     print(fileName);
//     FormData formData = FormData.fromMap({
//       "file": await MultipartFile.fromFile(imageFile!.path,
//           filename: fileName),
//     });
//     /*FormData formData = FormData.fromMap({
//       "file": await MultipartFile.fromFile(imageFile!.path,
//           filename: fileName,
//         contentType: MediaType("image", extension)
//       ),
//     });*/
//
//     String apiUrl=baseUrl+"employee/uploadEmployeeProfilePic";
//     print(apiUrl);
//
//     Dio dio = Dio();
//     dio.options.headers['Content-Type'] = 'multipart/form-data';
//     dio.options.headers['X-Auth-Token'] = token;
//     try {
//       var response = await dio.post(apiUrl, data: formData);
//       print(response.data);
//       Navigator.pop(context);
//       // var responseJSON = json.decode(response.data);
//       //
//       // print(responseJSON);
//       if (response.data['error'] == false) {
//         Toast.show(response.data['message'],
//             duration: Toast.lengthLong,
//             gravity: Toast.bottom,
//             backgroundColor: Colors.green);
//         getUserProfileImage();
//       }else{
//         Toast.show(response.data['message'],
//             duration: Toast.lengthLong,
//             gravity: Toast.bottom,
//             backgroundColor: Colors.red);
//       }
//     }on DioError catch(e){
//       print(e);
//       print(e.response.toString());
//       Navigator.pop(context);
//       Toast.show(e.message,
//           duration: Toast.lengthLong,
//           gravity: Toast.bottom,
//           backgroundColor: Colors.red);
//     }
//
//
//
//   }
//
//
//   /********************* get Offer Letter***************************/
//
//   getUserLetter(String type) async {
//     APIDialog.showAlertDialog(context, 'Please Wait...');
//
//
//
//     var requestModel = {
//       "type": type,
//       "emp_id":empId,
//     };
//
//
//     ApiBaseHelper helper = ApiBaseHelper();
//     var response = await helper.postAPIWithHeader(baseUrl, 'rest_api/getEmpLetters', requestModel, context,token);
//     Navigator.pop(context);
//     var responseJSON = json.decode(response.body);
//     print(responseJSON);
//     if (responseJSON['error'] == false) {
//       String pdfUrl=responseJSON['data']['file_path'].toString();
//       Navigator.push(context, MaterialPageRoute(builder: (context) => ShowOfferLetterScreen(type, pdfUrl, empId)),);
//     }
//     else {
//       Toast.show(responseJSON['message'],
//           duration: Toast.lengthLong,
//           gravity: Toast.bottom,
//           backgroundColor: Colors.red);
//     }
//   }
//
//
// }