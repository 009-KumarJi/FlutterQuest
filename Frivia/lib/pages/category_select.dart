import 'package:flutter/material.dart';
import 'package:frivia/pages/home_page.dart';

class CategorySelect extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _categorySelect();
  }
}

class _categorySelect extends State<CategorySelect> {

  Map CategoryMap = {
    'Any Category': 0,
    'General Knowledge': 9,
    'Entertainment: Books': 10,
    'Entertainment: Film': 11,
    'Entertainment: Music': 12,
    'Entertainment: Musicals & Theatres': 13,
    'Entertainment: Television': 14,
    'Entertainment: Video Games': 15,
    'Entertainment: Board Games': 16,
    'Science & Nature': 17,
    'Science: Computers': 18,
    'Science: Mathematics': 19,
    'Mythology': 20,
    'Sports': 21,
    'Geography': 22,
    'History': 23,
    'Politics': 24,
    'Art': 25,
    'Celebrities': 26,
    'Animals': 27,
    'Vehicles': 28,
    'Entertainment: Comics': 29,
    'Science: Gadgets': 30,
    'Entertainment: Japanese Anime & Manga': 31,
    'Entertainment: Cartoon & Animations': 32
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            _col1(),
          ],
        ),
      ),
    );
  }

  Widget _col1() {
    return Column(
      children: [
        _textButton("Any Category"),
        _textButton("General Knowledge"),
        _textButton("Entertainment: Books"),
        _textButton("Entertainment: Film"),
        _textButton("Entertainment: Music"),
        _textButton("Entertainment: Musicals & Theatres"),
        _textButton("Entertainment: Television"),
        _textButton("Entertainment: Video Games"),
        _textButton("Entertainment: Board Games"),
        _textButton("Science & Nature"),
        _textButton("Science: Computers"),
        _textButton("Science: Mathematics"),
        _textButton("Mythology"),
        _textButton("Sports"),
        _textButton("Geography"),
        _textButton("History"),
        _textButton("Politics"),
        _textButton("Art"),
        _textButton("Celebrities"),
        _textButton("Animals"),
        _textButton("Vehicles"),
        _textButton("Entertainment: Comics"),
        _textButton("Science: Gadgets"),
        _textButton("Entertainment: Japanese Anime & Manga"),
        _textButton("Entertainment: Cartoon & Animations"),
      ],
    );
  }



  Widget _textButton(String category){
    return MaterialButton(
      child: Text(
        category,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext _context) => HomePage(category: CategoryMap[category]),
          ),
        );
      },
    );
  }
}