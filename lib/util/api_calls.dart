import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Map<String, String> headers = {
  "X-CoinAPI-Key": "",
}; //TODO: paste api key from https://www.coinapi.io/pricing?apikey

class ApiCalls extends GetConnect {
  Future<List<FlSpot>> getChart(
    String cryptoBase,
    String exchangeCurrency,
    String periodID,
    DateTime timeStart,
    DateTime timeEnd,
  ) async {
    DateFormat format = DateFormat('yyyy-MM-dd HH:MM');
    String timeStartStr =
        format.format(timeStart).toString().replaceAll(' ', 'T');
    String timeEndStr = format.format(timeEnd).toString().replaceAll(' ', 'T');
    List<FlSpot> spots = [];
    Response response = await get(
      'https://rest.coinapi.io/v1/exchangerate/$cryptoBase/$exchangeCurrency/history?period_id=$periodID&time_start=$timeStartStr&time_end=$timeEndStr',
      headers: headers,
    );
    List ratesCount = response.body;
    //add spots
    for (var i = 0; i < ratesCount.length; i++) {
      spots.add(
        FlSpot(
          i.toDouble(),
          double.parse(response.body[i]['rate_close'].toStringAsFixed(6)),
        ),
      );
    }

    return spots;
  }
}
