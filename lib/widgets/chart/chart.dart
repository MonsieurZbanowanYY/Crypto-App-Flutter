import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

LineChartData chart(
  bool isHomePage,
  List<FlSpot> spots,
  double minY,
  double maxY,
  double maxX,
  bool profit,
) {
  List<Color> greenColors = [
    Colors.green.shade900,
    Colors.green.shade700,
  ];
  List<Color> redColors = [
    Colors.red.shade900,
    Colors.red.shade700,
  ];

  return LineChartData(
    backgroundColor: Colors.black,
    gridData: FlGridData(
      show: !isHomePage,
      drawVerticalLine: false,
      drawHorizontalLine: true,
      verticalInterval: 1,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: isHomePage
        ? FlTitlesData(show: false)
        : FlTitlesData(
            show: true,
            rightTitles: SideTitles(showTitles: false),
            topTitles: SideTitles(showTitles: false),
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              // interval: 1,
              textAlign: TextAlign.start,
              getTextStyles: (context, value) => TextStyle(
                color: const Color(0xff68737d),
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
              getTitles: (value) {
                if (maxX == 55) {
                  //2 hours
                  if (maxX - value == 0) {
                    return '0';
                  } else {
                    return '-' + ((maxX - value) * 2).toInt().toString();
                  }
                } else if (maxX == 47) {
                  //one day
                  if (maxX - value == 0) {
                    return '0';
                  } else {
                    return '-' + ((maxX - value) ~/ 2).toString();
                  }
                } else if (maxX == 7 || maxX == 30) {
                  //one week
                  if (maxX - value == 0) {
                    return '0';
                  } else {
                    return '-' + (maxX - value).toInt().toString();
                  }
                } else {
                  return value.toInt().toString();
                }
              },
              margin: 8,
            ),
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              margin: 15,
              interval: maxY * 0.15,
              getTextStyles: (context, value) => TextStyle(
                color: const Color(0xff68737d),
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              return LineTooltipItem(
                flSpot.y
                    .toStringAsFixed(2)
                    .replaceFirst('.', ',')
                    .replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.'),
                GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  letterSpacing: 0.5,
                ),
              );
            }).toList();
          }),
    ),
    minX: 0,
    maxX: maxX,
    minY: minY,
    maxY: maxY,
    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: true,
        colors: profit ? greenColors : redColors,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors: profit
              ? greenColors.map((color) => color.withOpacity(0.3)).toList()
              : redColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    ],
  );
}
