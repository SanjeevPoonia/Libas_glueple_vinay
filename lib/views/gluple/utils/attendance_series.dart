import 'package:flutter/cupertino.dart';
class AttendanceSeries{
    final String date;
    final String firstHalfStatus;
    final String secondHalfStatus;
    final String firstCheckIn;
    final String lastCheckOut;
    final String totaltime;
    final String attendanceStatus;
    final String attendanceDay;
    final int position;
    final double hours;
    AttendanceSeries(
        @required this.date,
        @required this.firstHalfStatus,
        @required this.secondHalfStatus,
        @required this.firstCheckIn,
        @required this.lastCheckOut,
        @required this.totaltime,
        @required this.attendanceStatus,
        @required this.attendanceDay,
        @required this.position,
        @required this.hours
        );
}