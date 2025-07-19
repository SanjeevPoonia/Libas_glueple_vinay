

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/attendance_series.dart';


class AttendanceChart extends StatelessWidget{
    final List<AttendanceSeries> data;
    const AttendanceChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {

    return BarChart(
      BarChartData(
          barGroups: _chartGroups(),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
              border: const Border(bottom: BorderSide())),
          titlesData: FlTitlesData(
              bottomTitles: AxisTitles(sideTitles: _bottomTitles),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)
              )
          )

      ),);


  }
    List<BarChartGroupData> _chartGroups() {
      return data.map((point) =>
          BarChartGroupData(
              x: point.position,
              barRods: [
                BarChartRodData(
                    toY: point.hours,
                    color: _getcolor(point.attendanceStatus),
                  width: 15
                )
              ]
          )

      ).toList();
    }

     _getcolor(String type){
        Color barColor=Colors.blue;
        if(type=="PR"||type=="PH_P"||type=="WO_P"||type=="present"){
          barColor=AppTheme.at_green;
        }else if(type=="PH"){
          barColor=AppTheme.at_lightgray;
        }else if(type=="HD"||type=="first_half_present"||type=="FHP"||type=="SHP"||type=="second_half_present"||type=="PH_FHP"||type=="PH_SHP"||type=="WO_FHP"||type=="WO_SHP"){
          barColor=AppTheme.at_blue;
        }else if(type=="WO"){
          barColor=AppTheme.at_gray;
        }else if(type=="LW" || type=="PL"|| type=="SSL"|| type=="FH_PL"|| type=="SH_PL"){
          barColor=AppTheme.at_yellow;
        }else if(type=="CO"||type=="C_Off"){
          barColor=AppTheme.at_purple;
        }else if(type=="AB"){
          barColor=AppTheme.at_red;
        }else if(type=="TOD"){
          barColor=AppTheme.at_black;
        }

      return barColor;
    }

    SideTitles get _bottomTitles => SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        String text = data[value.toInt()].date;
        return Text(text);
      },
    );

    SideTitles get _leftTitles => SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        String text = value.toString();
        return Text(text);
      },
    );
}