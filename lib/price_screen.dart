import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'currency_card.dart';
import 'dart:io' show Platform;

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  bool dataGathering = true;
  Map<String, String> coinValues = {};

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    dataGathering = true;
    CoinData coinData = CoinData();
    Map<String, dynamic> data = await coinData.getCoinData(selectedCurrency);
    dataGathering = false;
    updateUI(data);
  }

  void updateUI(Map coinData) {
    setState(() {
      for (String crypto in cryptoList) {
        coinValues[crypto] = coinData[crypto]['rate'].toStringAsFixed(0);
      }
    });
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
          currencyCard(
            convertedValue: dataGathering ? '?' : coinValues['BTC'],
            selectedCurrency: selectedCurrency,
            baseCurrency: 'BTC',
          ),
          currencyCard(
            convertedValue: dataGathering ? '?' : coinValues['ETH'],
            selectedCurrency: selectedCurrency,
            baseCurrency: 'ETH',
          ),
          currencyCard(
            convertedValue: dataGathering ? '?' : coinValues['LTC'],
            selectedCurrency: selectedCurrency,
            baseCurrency: 'LTC',
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
