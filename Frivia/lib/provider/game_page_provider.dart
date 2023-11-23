import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:html_unescape/html_unescape.dart';


class GamePageProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  final int _maxQuestions = 10;

  List? questions;
  int _currentQuesCount = 0;
  int _score = 0;

  BuildContext context;
  String difficulty;
  int category;

  GamePageProvider(
      {required this.context,
      required this.category,
      required this.difficulty}) {
    _dio.options.baseUrl = 'https://opentdb.com/api.php';
    _getQuestionsFromAPI();
  }

  Future<void> _getQuestionsFromAPI() async {
    Map<String, dynamic> queryParams = {
      'amount': 10,
      'difficulty': difficulty.toLowerCase(),
      'type': 'boolean',
    };

    if (category != 0) {
      queryParams['category'] = category;
    }
    print(queryParams);
    var _response = await _dio.get(
      '',
      queryParameters: queryParams,
    );

    var _data = jsonDecode(
      _response.toString(),
    );
    questions = _data['results'];
    notifyListeners();
    if (questions!.length < 10){
      endGame(true);
    }
  }

  String getCurrentQuestionText() {
    return HtmlUnescape().convert(questions![_currentQuesCount]['question']);
  }

  void answerQuestion(String _ans) async {
    bool isCorrect = questions![_currentQuesCount]['correct_answer'] == _ans;
    _score += isCorrect ? 1 : 0;
    _currentQuesCount++;
    _alert(isCorrect);
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);
    (_currentQuesCount == _maxQuestions) ? endGame(false) : notifyListeners();
  }

  void _alert(bool isCorrect) {
    showDialog(
      context: context,
      builder: (BuildContext _context) => AlertDialog(
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        title: Icon(
          isCorrect ? Icons.check_circle : Icons.cancel_sharp,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> endGame(bool error) async {
    if (!error){
      Map CategoryMap = {
        0: 'Any Category',
        9: 'General Knowledge',
        10: 'Entertainment: Books',
        11: 'Entertainment: Film',
        12: 'Entertainment: Music',
        13: 'Entertainment: Musicals & Theatres',
        14: 'Entertainment: Television',
        15: 'Entertainment: Video Games',
        16: 'Entertainment: Board Games',
        17: 'Science & Nature',
        18: 'Science: Computers',
        19: 'Science: Mathematics',
        20: 'Mythology',
        21: 'Sports',
        22: 'Geography',
        23: 'History',
        24: 'Politics',
        25: 'Art',
        26: 'Celebrities',
        27: 'Animals',
        28: 'Vehicles',
        29: 'Entertainment: Comics',
        30: 'Science: Gadgets',
        31: 'Entertainment: Japanese Anime & Manga',
        32: 'Entertainment: Cartoon & Animations'
      };

      showDialog(
        context: context,
        builder: (BuildContext _context) {
          return AlertDialog(
            backgroundColor: Colors.blueAccent,
            title: const Text(
              "End Game",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            content: Text(
                "Category: ${CategoryMap[category]}\nScore: $_score/$_maxQuestions"),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext _context) {
          return const AlertDialog(
            backgroundColor: Colors.red,
            title: Text(
              "Questions not found!",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            content: Text(
                "Change the category!"),
          );
        },
      );
    }
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
