
import 'package:flutter/cupertino.dart';

class AttendanceDetailsSeries{
  final String dateStr;
  final String firstHalfStatus;
  final String secondHalfStatus;
  final String firstCheckIn;
  final String lastCheckOut;
  final String totalTime;
  final String attendanceStatus;
  final String attendanceDay;
  final String dayStr;
  final String monthStr;

  AttendanceDetailsSeries(
      this.dateStr,
      this.firstHalfStatus,
      this.secondHalfStatus,
      this.firstCheckIn,
      this.lastCheckOut,
      this.totalTime,
      this.attendanceStatus,
      this.attendanceDay,
      this.dayStr,
      this.monthStr
      );
}