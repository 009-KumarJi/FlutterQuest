import 'dart:convert';

import 'package:crypto_sense/pages/details_page.dart';

import '/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  String? _selectedValue;

  HTTPService? _http;

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _selectedCoinDropDown(),
              _dataWidgets(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedCoinDropDown() {
    List<String> _coins = ["dogecoin", "bitcoin", "ethereum", "tether", "binancecoin", "ripple", "solana"];
    List<DropdownMenuItem<String>> _items = _coins
        .map((elem) => DropdownMenuItem(
            value: elem,
            child: Text(
              elem,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            )))
        .toList();
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(36, 1, 150, 0.6),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton(
          value: _selectedValue,
          items: _items,
          dropdownColor: const Color.fromRGBO(36, 1, 150, 1),
          elevation: 0,
          hint: const Text(
            'Select a coin!',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 20,
            ),
          ),
          iconSize: 30,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white,
          ),
          onChanged: (_val) {
            setState(() {
              _selectedValue = _val;
            });
          },
          underline: Container(),
        ),
      ),
    );
  }

  Widget _dataWidgets() {
    return (_selectedValue == null)
        ? Container()
        : FutureBuilder(
            future: _http!.get("/coins/$_selectedValue"),
            builder: (BuildContext _context, AsyncSnapshot _snapshot) {
              if (_snapshot.hasData) {
                Map _data = jsonDecode(_snapshot.data.toString());
                num _inrPrice = _data['market_data']['current_price']['inr'];
                num _change24h = _data['market_data']['price_change_percentage_24h'];
                Map _exchangeRates = _data['market_data']['current_price'];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: _coinImageWidget(_data['image']['large']),
                      onDoubleTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext _context) {
                              return DetailsPage(rates: _exchangeRates,);
                            },
                          ),
                        );
                      },
                    ),
                    _currentPriceWidget(_inrPrice),
                    _percentageChangeWidget(_change24h),
                    _descriptionWidget(_data['description']['en']),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(100, 100, 100, 0.8),
                  ),
                );
              }
            });
  }

  Widget _currentPriceWidget(num _rate) {
    return Text(
      "₹ ${_rate.toStringAsFixed(2)}",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _percentageChangeWidget(num _change) {
    return Text(
      "${_change.toStringAsFixed(2)} %",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _coinImageWidget(String _imgURL) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.02,
      ),
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.15,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            _imgURL,
          ),
        ),
      ),
    );
  }

  Widget _descriptionWidget(String _desc) {
    return Container(
      height: _deviceHeight! * 0.45,
      width: _deviceWidth! * 0.9,
      margin: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.05,
      ),
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.02,
        horizontal: _deviceHeight! * 0.01,
      ),
      color: const Color.fromRGBO(32, 1, 133, 0.6),
      child: Text(
        _desc,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
