import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget{

  final Map rates;

  const DetailsPage({required this.rates});

  @override
  Widget build(BuildContext context) {
    List _currencies = rates.keys.toList();
    List _exchangeRates = rates.values.toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Currency Exchange Rates',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _currencies.length,
                itemBuilder: (_context, _index) {
                  String _currency = _currencies[_index].toString().toUpperCase();
                  String _exchangeRate = _exchangeRates[_index].toString().toUpperCase();
                  return ListTile(
                    title: Text('$_currency: $_exchangeRate', style: const TextStyle(color: Colors.white),),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}