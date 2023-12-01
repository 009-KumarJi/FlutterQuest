import 'package:flutter/cupertino.dart';
import 'package:ibmi/widgets/info_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatelessWidget {
  late double _deviceHeight, _deviceWidth;
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      child: _dataCard(),
    );
  }

  Widget _dataCard() {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final prefs = snapshot.data as SharedPreferences;
          String? bmiDate = prefs.getString('bmi_date');
          List<String>? bmiData = prefs.getStringList('bmi_data');
          if (bmiDate != null && bmiData != null && bmiData.length > 1) {
            DateTime date = DateTime.parse(bmiDate);
            return Center(
              child: InfoCard(
                height: _deviceHeight * 0.3,
                width: _deviceWidth * 0.75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'You were ${bmiData[1]}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'on ${date.day}/${date.month}/${date.year}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      bmiData[0],
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return Center(
          child: InfoCard(
            height: _deviceHeight * 0.3,
            width: _deviceWidth * 0.75,
            child: const Center(
              child: Text('No Previous Data'),
            ),
          ),
        );
      },
    );
  }
}
