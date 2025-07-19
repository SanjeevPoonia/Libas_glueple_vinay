// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:gluple_libas/utils/app_theme.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:path/path.dart' as path;
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:intl/intl.dart' show DateFormat;
//
//
// class RecordAudioScreen extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
// class _MyHomePageState extends State<RecordAudioScreen> {
//   FlutterSoundRecorder? _recordingSession;
//   final recordingPlayer = AssetsAudioPlayer();
//   String? pathToAudio;
//   bool _playAudio = false;
//   Timer? _timer;
//   int _start = 0;
//   String _timerText = '00:00:00';
//   @override
//   void initState() {
//     super.initState();
//     initializer();
//   }
//
//   formattedTime({required int timeInSecond}) {
//     int sec = timeInSecond % 60;
//     int min = (timeInSecond / 60).floor();
//     String minute = min.toString().length <= 1 ? "0$min" : "$min";
//     String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
//     return "$minute : $second";
//   }
//   void initializer() async {
//     final tempDir = await getTemporaryDirectory();
//     pathToAudio = '/sdcard/Download/temp.wav';
//     _recordingSession = FlutterSoundRecorder();
//     await _recordingSession!.openAudioSession(
//         focus: AudioFocus.requestFocusAndStopOthers,
//         category: SessionCategory.playAndRecord,
//         mode: SessionMode.modeDefault,
//         device: AudioDevice.speaker);
//     await _recordingSession!.setSubscriptionDuration(Duration(milliseconds: 10));
//     await initializeDateFormatting();
//     await Permission.microphone.request();
//     await Permission.storage.request();
//     await Permission.manageExternalStorage.request();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(title: Text('Audio Recorder',style: TextStyle(
//           fontSize: 18
//
//       ),),backgroundColor: AppTheme.orangeColor),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             SizedBox(
//               height: 40,
//             ),
//             Container(
//               child: Center(
//                 child: Text(
//                   formattedTime(timeInSecond: _start),
//                   style: TextStyle(fontSize: 66, color: Colors.black),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 createElevatedButton(
//                   icon: Icons.mic,
//                   iconColor: Colors.red,
//                   onPressFunc: startRecording,
//                 ),
//                 SizedBox(
//                   width: 30,
//                 ),
//                 createElevatedButton(
//                   icon: Icons.stop,
//                   iconColor: Colors.red,
//                   onPressFunc: stopRecording,
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             ElevatedButton.icon(
//               style:
//               ElevatedButton.styleFrom(elevation: 9.0),
//               onPressed: () {
//                 setState(() {
//                   _playAudio = !_playAudio;
//                 });
//                 if (_playAudio) playFunc();
//                 if (!_playAudio) stopPlayFunc();
//               },
//               icon: _playAudio
//                   ? Icon(
//                 Icons.stop,
//               )
//                   : Icon(Icons.play_arrow),
//               label: _playAudio
//                   ? Text(
//                 "Stop",
//                 style: TextStyle(
//                   fontSize: 26,
//                 ),
//               )
//                   : Text(
//                 "Play",
//                 style: TextStyle(
//                   fontSize: 26,
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 40),
//
//
//
//             _start!=0?
//
//
//
//
//             InkWell(
//               onTap: () {
//                 Navigator.pop(context,pathToAudio.toString());
//
//               },
//               child: Container(
//                   margin: EdgeInsets.symmetric(horizontal: 60),
//                   decoration: BoxDecoration(
//                       color: AppTheme.themeColor,
//                       borderRadius: BorderRadius.circular(5)),
//                   height: 49,
//                   child: const Center(
//                     child: Text('Upload',
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white)),
//                   )),
//             ):Container()
//
//
//           ],
//         ),
//       ),
//     );
//   }
//   ElevatedButton createElevatedButton(
//       {IconData? icon, Color? iconColor, Function? onPressFunc}) {
//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(
//         padding: EdgeInsets.all(5.0),
//         side: BorderSide(
//           color: Colors.red,
//           width: 2.0,
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         elevation: 9.0,
//       ),
//       onPressed:(){
//         onPressFunc!();
//       },
//       icon: Padding(
//         padding: const EdgeInsets.only(left: 5),
//         child: Icon(
//           icon,
//           color: iconColor,
//           size: 35.0,
//         ),
//       ),
//       label: Text(''),
//     );
//   }
//   Future<void> startRecording() async {
//     Directory directory = Directory(path.dirname(pathToAudio!));
//     if (!directory.existsSync()) {
//       directory.createSync();
//     }
//     _recordingSession!.openAudioSession();
//     await _recordingSession!.startRecorder(
//       toFile: pathToAudio,
//       codec: Codec.pcm16WAV,
//     );
//
//     startTimer();
//   }
//
//   void startTimer() {
//     _start = 0;
//     const oneSec = const Duration(seconds: 1);
//     _timer = new Timer.periodic(
//       oneSec,
//           (Timer timer) {
//
//         setState(() {
//           _start=_start+1;
//
//         });
//       },
//     );
//   }
//
//
//   Future<String?> stopRecording() async {
//     _recordingSession!.closeAudioSession();
//     _timer?.cancel();
//     return await _recordingSession!.stopRecorder();
//   }
//   Future<void> playFunc() async {
//     recordingPlayer.open(
//       Audio.file(pathToAudio!),
//       autoStart: true,
//       showNotification: true,
//     );
//   }
//   Future<void> stopPlayFunc() async {
//     recordingPlayer.stop();
//   }
//
// }