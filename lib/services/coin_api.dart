import 'dart:convert';

import 'package:bitcoin_ticker/app/constants.dart';
import 'package:bitcoin_ticker/app/models/coin_data.dart';
import 'package:http/http.dart' as http;

Future<CoinData> getCoinData(String base, String quote) async {
  http.Response response = await http.get(
    Uri.parse('https://rest-sandbox.coinapi.io/v1/exchangerate/$base/$quote'),
    headers: <String, String>{'X-CoinAPI-Key': API_KEY},
  );
  if (response.statusCode != 200) {
    return await Future.error(response.statusCode);
  }
  return CoinData.fromJson(jsonDecode(response.body));
}
