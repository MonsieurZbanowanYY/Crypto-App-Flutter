import 'package:crypto_app/util/api_calls.dart';
import 'package:crypto_app/widgets/chart/chart.dart';
import 'package:crypto_app/widgets/chart/chart_sort_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:unicons/unicons.dart';

class DetailsPage extends StatefulWidget {
  final IconData cryptoIcon;
  final String cryptoName;
  final String cryptoCode;
  final String exchangeCurrency;

  final List<FlSpot> spots;
  final double profitPercent;
  final double minY;
  final double maxY;

  const DetailsPage({
    Key? key,
    required this.cryptoIcon,
    required this.cryptoName,
    required this.cryptoCode,
    required this.exchangeCurrency,
    required this.spots,
    required this.profitPercent,
    required this.minY,
    required this.maxY,
  }) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late RxList<FlSpot> spots;
  @override
  void initState() {
    spots = widget.spots.obs;
    minY = widget.minY.obs;
    maxY = widget.maxY.obs;
    super.initState();
  }

  late RxDouble minY;
  late RxDouble maxY;
  void changeSort(int i) async {
    //! i != sortStrings.length - 1 || because 1 year API get is not supported
    if (i != selectedSort.value && i != sortStrings.length - 1) {
      selectedSort.value = i;
      if (i == 0) {
        spots.value = await ApiCalls().getChart(
          widget.cryptoCode,
          widget.exchangeCurrency,
          '2MIN',
          DateTime.now().subtract(const Duration(hours: 2)),
          DateTime.now(),
        );
      } else if (i == 1) {
        spots.value = await ApiCalls().getChart(
          widget.cryptoCode,
          widget.exchangeCurrency,
          '30MIN',
          DateTime.now().subtract(const Duration(days: 1)),
          DateTime.now(),
        );
      } else if (i == 2) {
        spots.value = await ApiCalls().getChart(
          widget.cryptoCode,
          widget.exchangeCurrency,
          '1DAY',
          DateTime.now().subtract(const Duration(days: 7)),
          DateTime.now(),
        );
      } else if (i == 3) {
        spots.value = await ApiCalls().getChart(
          widget.cryptoCode,
          widget.exchangeCurrency,
          '1DAY',
          DateTime.now().subtract(const Duration(days: 30)),
          DateTime.now(),
        );
      } else if (i == 4) {
        spots.value = await ApiCalls().getChart(
          widget.cryptoCode,
          widget.exchangeCurrency,
          '10DAY', //! ONE YEAR IS NOT SUPPORTED!!!
          DateTime.now().subtract(const Duration(days: 365)),
          DateTime.now(),
        );
      }
    }
    List sortedSpots = spots.toList();
    sortedSpots.sort((a, b) => a.y.compareTo(b.y));
    minY.value = sortedSpots.first.y;
    maxY.value = sortedSpots.last.y;
  }

  Rx<int> selectedSort = 2.obs;
  List sortStrings = [
    '2H',
    '1D',
    '1W',
    '1M',
    '1Y',
  ];
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0), //appbar size
        child: AppBar(
          bottomOpacity: 0.0,
          elevation: 0.0,
          shadowColor: Colors.transparent,
          backgroundColor: themeData.backgroundColor,
          leading: Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: SizedBox(
              height: 3.5.h,
              width: 10.w,
              child: InkWell(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    UniconsLine.angle_left,
                    color: themeData.primaryColor,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leadingWidth: 15.w,
          title: Text(
            widget.cryptoName,
            style: GoogleFonts.lato(
              color: themeData.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: SizedBox(
                height: 3.5.h,
                width: 10.w,
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    UniconsLine.bell,
                    color: themeData.primaryColor,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.5.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeData.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        widget.cryptoIcon,
                        size: 80.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0.5.h),
              child: Center(
                child: Text(
                  '\$${spots.last.y.toStringAsFixed(2).replaceFirst('.', ',').replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}',
                  style: GoogleFonts.lato(
                    letterSpacing: 1,
                    color: themeData.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                '${widget.cryptoCode}/${widget.exchangeCurrency}',
                style: GoogleFonts.lato(
                  letterSpacing: 1,
                  color: themeData.primaryColor,
                  fontWeight: FontWeight.w300,
                  fontSize: 15.sp,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.profitPercent >= 0
                      ? UniconsLine.arrow_growth
                      : UniconsLine.chart_down,
                  color: widget.profitPercent >= 0
                      ? Colors.green[600]
                      : Colors.red[600],
                  size: 20.sp,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Text(
                    '${widget.profitPercent.toStringAsFixed(2).replaceFirst('.', ',')}%',
                    style: GoogleFonts.poppins(
                      color: widget.profitPercent >= 0
                          ? Colors.green[600]
                          : Colors.red[600],
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 1.h, bottom: 3.h),
              child: Center(
                child: Container(
                  width: 95.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: SizedBox(
                        width: 85.w,
                        height: 30.h,
                        child: Obx(
                          () => LineChart(
                            chart(
                              false,
                              spots,
                              minY.value,
                              maxY.value,
                              double.parse((spots.length - 1).toString()),
                              widget.profitPercent >= 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: SizedBox(
                height: 5.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sortStrings.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Obx(() => i == selectedSort.value
                        ? GestureDetector(
                            onTap: () => changeSort(i),
                            child: chartSortWidget(
                                sortStrings[i], true, themeData))
                        : GestureDetector(
                            onTap: () => changeSort(i),
                            child: chartSortWidget(
                                sortStrings[i], false, themeData)));
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.h, left: 5.w, right: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {}, //TODO: add sell action
                    splashColor:
                        themeData.secondaryHeaderColor.withOpacity(0.5),
                    highlightColor:
                        themeData.secondaryHeaderColor.withOpacity(0.8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeData.primaryColor.withOpacity(0.05),
                        border: Border.all(
                          color: themeData.secondaryHeaderColor,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 43.w,
                      height: 7.h,
                      child: Center(
                        child: Text(
                          'Sell',
                          style: GoogleFonts.lato(
                            color: themeData.primaryColor.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {}, //TODO: add buy action
                    splashColor: themeData.primaryColor,
                    highlightColor: themeData.primaryColor,
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeData.secondaryHeaderColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 43.w,
                      height: 7.h,
                      child: Center(
                        child: Text(
                          'Buy',
                          style: GoogleFonts.lato(
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
