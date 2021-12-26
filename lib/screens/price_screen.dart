import 'dart:io' show Platform;

import 'package:bitcoin_ticker/app/constants.dart';
import 'package:bitcoin_ticker/app/models/coin_data.dart';
import 'package:bitcoin_ticker/services/coin_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  List<Future<CoinData>> coinData = List<Future<CoinData>>.empty(growable: true);

  @override
  initState() {
    super.initState();
    _syncCoinData();
  }

  void _syncCoinData() {
    coinData.clear();
    cryptoList.forEach((crypto) {
      coinData.add(getCoinData(crypto, selectedCurrency));
    });
  }

  Widget _getPlatformSpecificPicker() {
    return !Platform.isIOS
        ? CupertinoPicker(
            scrollController:
                FixedExtentScrollController(initialItem: currenciesList.indexOf('USD')),
            backgroundColor: Colors.lightBlue,
            itemExtent: 32.0,
            onSelectedItemChanged: (selectedIndex) {
              setState(() => selectedCurrency = currenciesList[selectedIndex]);
              _syncCoinData();
            },
            children: currenciesList.map((currency) => Text(currency)).toList())
        : DropdownButton<String>(
            value: selectedCurrency,
            items: currenciesList
                .map<DropdownMenuItem<String>>(
                  (currency) => DropdownMenuItem<String>(value: currency, child: Text(currency)),
                )
                .toList(),
            onChanged: (value) {
              setState(() => selectedCurrency = value!);
              _syncCoinData();
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: cryptoList.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: coinData.length - 1 >= index
                        ? FutureBuilder(
                            future: coinData[index],
                            builder: (context, AsyncSnapshot<CoinData> snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  '1 ${cryptoList[index]} = ${snapshot.data!.rate.toStringAsFixed(4)} $selectedCurrency',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                  ),
                                );
                              } else {
                                return Text(
                                  '1 ${cryptoList[index]} = ? $selectedCurrency',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            })
                        : Text(
                            '1 ${cryptoList[index]} = ? $selectedCurrency',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: _getPlatformSpecificPicker(),
          ),
        ],
      ),
    );
  }
}
