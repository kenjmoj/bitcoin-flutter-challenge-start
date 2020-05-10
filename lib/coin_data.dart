import 'package:http/http.dart' as http;
import 'dart:convert';
import 'keys.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  Future getCoinData(String convertingCurrency) async {
    Map<String, dynamic> coinValuesData = {};
    for (String crypto in cryptoList) {
      http.Response response = await http
          .get('$coinAPIURL/$crypto/$convertingCurrency?apikey=$apiKey');

      if (response.statusCode == 200) {
        coinValuesData[crypto] = jsonDecode(response.body);
      } else {
        print(response.statusCode);
      }
    }

    return coinValuesData;
  }
}
