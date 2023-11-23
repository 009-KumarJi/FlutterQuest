import 'package:flutter/material.dart';
import 'package:frivia/pages/category_select.dart';
import 'package:frivia/pages/game_page.dart';

Map CategoryMap = {0: 'Any Category', 9: 'General Knowledge', 10: 'Entertainment: Books', 11: 'Entertainment: Film', 12: 'Entertainment: Music', 13: 'Entertainment: Musicals & Theatres', 14: 'Entertainment: Television', 15: 'Entertainment: Video Games', 16: 'Entertainment: Board Games', 17: 'Science & Nature', 18: 'Science: Computers', 19: 'Science: Mathematics', 20: 'Mythology', 21: 'Sports', 22: 'Geography', 23: 'History', 24: 'Politics', 25: 'Art', 26: 'Celebrities', 27: 'Animals', 28: 'Vehicles', 29: 'Entertainment: Comics', 30: 'Science: Gadgets', 31: 'Entertainment: Japanese Anime & Manga', 32: 'Entertainment: Cartoon & Animations'};



class HomePage extends StatefulWidget {
  int category;
  HomePage({this.category = 0});
  @override
  State<StatefulWidget> createState() {
    return _HomePageState(category: category);
  }
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  double _sliderValue = 0.0;
  List<String> difficultyLevels = ['Easy', 'Medium', 'Hard'];
  int category;
  _HomePageState({required this.category});

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth!*0.1),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    _title(),
                    SizedBox(height: _deviceHeight! * 0.01,),
                    Text(
                      'Difficulty: ${difficultyLevels[_sliderValue.toInt()]}',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
                _selectCategoryButton(),
                _slider(),
                _startButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return const Text(
      "Frivia",
      style: TextStyle(
        color: Colors.white,
        fontSize: 60,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _slider() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Slider(
          value: _sliderValue,
          min: 0.0,
          max: 2.0,
          divisions: 2,
          onChanged: (value) {
            setState(() {
              _sliderValue = value;
            });
          },
        ),
      ],
    );
  }

  Widget _startButton() {
    return Container(
      width: _deviceWidth! * 0.8,
      height: _deviceHeight! * 0.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.lightBlueAccent,
      ),
      child: MaterialButton(
        onPressed: () {
          print(difficultyLevels[_sliderValue.toInt()]);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext _context) => GamePage(
                difficulty: difficultyLevels[_sliderValue.toInt()],
                category: category,
              ),
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Text(
          'Start',
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }


  Widget _selectCategoryButton(){
    print(CategoryMap[category]);
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext _context) => CategorySelect(),
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      child: Text(
        CategoryMap[category],
        style: const TextStyle(
          fontSize: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}
