import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:ibmi/widgets/info_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BMIPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  late double _deviceHeight, _deviceWidth;

  int _age = 25, _weight = 60, _height = 160, _gender = 0;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
      child: Center(
        child: Container(
          height: _deviceHeight * 0.85,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _ageSelectContainer(),
                    _weightSelectContainer(),
                  ],
                ),
                _heightSliderSelectContainer(),
                _genderSelectContainer(),
                _calculateButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _ageSelectContainer() {
    return InfoCard(
      height: _deviceHeight * 0.2,
      width: _deviceWidth * 0.45,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Age (Yr)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            _age.toString(),
            style: const TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                child: CupertinoDialogAction(
                  onPressed: () => setState(() => _age--),
                  child: const Icon(
                    CupertinoIcons.minus,
                    color: CupertinoColors.destructiveRed,
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                child: CupertinoDialogAction(
                  onPressed: () => setState(() => _age++),
                  child: const Icon(
                    CupertinoIcons.add,
                    color: CupertinoColors.activeBlue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _weightSelectContainer() {
    return InfoCard(
      height: _deviceHeight * 0.2,
      width: _deviceWidth * 0.45,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Weight (Kg)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            _weight.toString(),
            style: const TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                child: CupertinoDialogAction(
                  onPressed: () => setState(() => _weight--),
                  child: const Icon(
                    CupertinoIcons.minus,
                    color: CupertinoColors.destructiveRed,
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                child: CupertinoDialogAction(
                  onPressed: () => setState(() => _weight++),
                  child: const Icon(
                    CupertinoIcons.add,
                    color: CupertinoColors.activeBlue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heightSliderSelectContainer() {
    return InfoCard(
      height: _deviceHeight * 0.175,
      width: _deviceWidth * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Height (cms)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            _height.toString(),
            style: const TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            width: _deviceWidth * 0.8,
            child: CupertinoSlider(
                min: 30,
                max: 250,
                divisions: 220,
                value: _height.toDouble(),
                onChanged: (_value) =>
                    setState(() => _height = _value.toInt())),
          ),
        ],
      ),
    );
  }

  Widget _genderSelectContainer() {
    return InfoCard(
      height: _deviceHeight * 0.11,
      width: _deviceWidth * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Gender at Birth',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          CupertinoSlidingSegmentedControl(
            groupValue: _gender,
            children: const {
              0: Text('Male'),
              1: Text('Female'),
            },
            onValueChanged: (_value) => setState(() => _gender = _value as int),
          ),
        ],
      ),
    );
  }

  Widget _calculateButton() {
    return Container(
      height: _deviceHeight * 0.07,
      child: CupertinoButton.filled(
        child: const Text(
          'Calculate',
          style: TextStyle(
            color: CupertinoColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: () {
          if (_height > 0 && _weight > 0 && _age > 0) {
            double bmi = _weight / pow(_height * 0.01, 2);
            _showResultDialogBox(bmi);
          }
        },
      ),
    );
  }

  void _showResultDialogBox(double bmi) {
    late String status;
    if (bmi < 18.5) {
      status = 'UnderWeight';
    } else if (bmi >= 18.5 && bmi < 25) {
      status = 'Normal';
    } else if (bmi >= 25 && bmi < 30) {
      status = 'OverWeight';
    } else {
      status = 'Obese';
    }

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text('You\'re $status'),
        content: Text('Your BMI is ${bmi.toStringAsFixed(2)}'),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              _saveResults(bmi.toStringAsFixed(2), status);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _saveResults(String bmi, String status) async {
    final prefs = await SharedPreferences.getInstance();
    print('SharedPreferences instance: $prefs'); // Debug step 1
    print('Saving results...'); // Debug step 2
    print('BMI: $bmi, Status: $status'); // Debug step 3
    await prefs.setString('bmi_date', DateTime.now().toString());
    await prefs.setStringList('bmi_data', <String>[bmi, status]);
  }
}
