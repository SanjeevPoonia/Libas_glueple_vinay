// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_file_downloader/flutter_file_downloader.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:toast/toast.dart';
// import '../network/api_dialog.dart';
// import '../utils/app_theme.dart';
//
//
// class ShowPaySlipScreen extends StatefulWidget{
//   final String pdfUrl;
//   final String monthName;
//   final String autoId;
//
//   ShowPaySlipScreen(this.pdfUrl, this.monthName,this.autoId);
//   _showPayslip createState()=>_showPayslip();
// }
// class _showPayslip extends State<ShowPaySlipScreen>{
//   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
//   File? downloadedFile;
//   String downloadMessage = "Press download";
//   File? savedF;
//
//
//   @override
//   Widget build(BuildContext context) {
//     ToastContext().init(context);
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_outlined,
//               color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         backgroundColor: AppTheme.themeColor,
//         title: const Text(
//           "Payslip",
//           style: TextStyle(
//               fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(onPressed: ()=>{
//             downloadFileCustome(),
//             //downloadFile(),
//           },
//
//               icon: Icon(Icons.download,color: Colors.white,size: 24,)
//           )
//         ],
//       ),
//       body: SfPdfViewer.network(widget.pdfUrl,key: _pdfViewerKey,),
//     );
//   }
//
//   downloadFile() async{
//    APIDialog.showAlertDialog(context, "Downloading File...");
//     var file= await FileDownloader.downloadFile(
//         url: widget.pdfUrl,
//         name: "${widget.monthName}.pdf",
//         );
//     FileDownloader.setLogEnabled(true);
//     Navigator.of(context).pop();
//     String? filePath=file?.path;
//     _showCustomDialog(filePath!);
//
//   }
//
//   downloadFileCustome()async{
//     APIDialog.showAlertDialog(context, "Downloading File...");
//     try {
//
//
//       HttpClient client = HttpClient();
//       List<int> downloadData = [];
//
//       Directory downloadDirectory;
//
//       if (Platform.isIOS) {
//         downloadDirectory = await getApplicationDocumentsDirectory();
//       } else {
//         downloadDirectory = Directory('/storage/emulated/0/Download');
//         if (!await downloadDirectory.exists()) downloadDirectory = (await getExternalStorageDirectory())!;
//       }
//
//       String filePathName = "${downloadDirectory.path}/${widget.autoId}${widget.monthName}.pdf";
//       File savedFile = File(filePathName);
//       bool fileExists = await savedFile.exists();
//       savedF=savedFile;
//
//       if (fileExists && mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("File already downloaded")));
//       } else {
//         client.getUrl(Uri.parse(widget.pdfUrl)).then(
//               (HttpClientRequest request) {
//             setState(() {
//               downloadMessage = "Loading";
//             });
//             return request.close();
//           },
//         ).then(
//               (HttpClientResponse response) {
//             response.listen((d) => downloadData.addAll(d), onDone: () {
//               savedFile.writeAsBytes(downloadData);
//               setState(() {
//                 downloadedFile = savedFile;
//               });
//             });
//           },
//         );
//       }
//
//
//
//     } catch (error) {
//
//
//       setState(() {
//         downloadMessage = "Some error occurred -> $error";
//       });
//     }
//
//     Navigator.of(context).pop();
//     print(" File Path ${savedF?.path}");
//     if(savedF!=null){
//       String? filePath=savedF?.path;
//       _showCustomDialog(filePath!);
//     }
//
//     print(downloadMessage);
//   }
//
//
//   _showCustomDialog(String path){
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius:
//                 BorderRadius.circular(20.0)), //this right here
//             child: Container(
//              // height: 300,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
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
//
//                     Text("Payslip Downloaded Successfully",style: TextStyle(fontWeight: FontWeight.w900,color: AppTheme.themeColor,fontSize: 18),),
//                     SizedBox(height: 20,),
//                     Text("Path : $path",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 14),),
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
//
//
//
// }