import 'package:crypto_app/data/crypto_pair_model.dart';
import 'package:crypto_app/data/cryptocurrencies_data.dart';
import 'package:crypto_app/util/api_calls.dart';
import 'package:crypto_app/widgets/actions/actions_widget.dart';
import 'package:crypto_app/widgets/balance_panel/balance_panel.dart';
import 'package:crypto_app/widgets/chart/chart_home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:unicons/unicons.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double balance = 66032206.10;
  double profit = 35.22;
  double profitPercent = 0.22;
  @override
  void initState() {
    getCharts();
    super.initState();
  }

  RxList cryptoCharts = [].obs;

  String periodID = '1DAY';
  getCharts() async {
    for (var i = 0; i < cryptocurrencies.length; i++) {
      cryptoCharts.add(
        {
          'cryptoPairModel': cryptocurrencies[i],
          'chartSpots': await ApiCalls().getChart(
            cryptocurrencies[i].cryptoBase,
            cryptocurrencies[i].exchangeCurrency,
            periodID,
            DateTime.now().subtract(const Duration(days: 7)),
            DateTime.now(),
          ),
        },
      );
    }
  }

  DateFormat format = DateFormat('yyyy-MM-dd HH:MM');
  void forceBalanceToRefresh() {
    setState(() {
      cryptoCharts = cryptoCharts;
    });
  }

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
          leading: SizedBox(
            height: 10.w,
            width: 15.w,
          ),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leadingWidth: 15.w,
          title: Image.asset(
            themeData.brightness == Brightness.light
                ? 'assets/sobGOGdark.png'
                : 'assets/sobGOGlight.png',
            height: 3.5.h,
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
        child: Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: ListView(
            children: [
              Obx(
                () => balancePanel(
                  // ignore: invalid_use_of_protected_member
                  cryptoCharts.value,
                  themeData,
                ),
              ),
              actionsWidget(forceBalanceToRefresh, themeData),
              Obx(
                () => cryptoCharts.isEmpty
                    ? SizedBox(
                        width: 100.w,
                        height: 10.h,
                        child: Align(
                          child: CircularProgressIndicator(
                            color: themeData.primaryColor,
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: cryptoCharts.length,
                        itemBuilder: (BuildContext context, int i) {
                          CryptoPairModel cryptoPairModel =
                              cryptoCharts[i]['cryptoPairModel'];

                          return chartHomePage(
                            true,
                            cryptoPairModel.cryptoIcon,
                            cryptoPairModel.cryptoName,
                            cryptoPairModel.cryptoBase,
                            cryptoPairModel.exchangeCurrency,
                            cryptoCharts[i]['chartSpots'],
                            themeData,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
