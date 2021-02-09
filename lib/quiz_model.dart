import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:asmatzen/question.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart' show rootBundle;

class QuizModel extends ChangeNotifier {
  int currectQuestion = 0;
  List<Question> questions;
  QuizModel(List<Question> qs) {
    questions = qs;
  }

  void setCorrect() {
    questions[currectQuestion].isCorrect = true;
    currectQuestion++;
    notifyListeners();
  }

  void setIncorrect() {
    questions[currectQuestion].isCorrect = false;
    currectQuestion++;
    notifyListeners();
  }

  static Future<List<Question>> loadQuestions() async {
    List<Question> questions = [];
    //List<Map<String, dynamic>> questionsMap =
    //    jsonDecode(File('/assets/galderak.json').readAsStringSync());

    List<dynamic> questionsMap =
        jsonDecode(await rootBundle.loadString('assets/galderak.json'));
    for (int i = 0; i < 10; i++) {
      int random = Random().nextInt(questionsMap.length);
      questions.add(await loadQuestion(questionsMap[random]));
    }
    return questions;
  }

  static Future<Question> loadQuestion(Map<String, dynamic> data) async {
    switch (data['type']) {
      case 'maths':
        return generateMathQuestion();
      case 'flags':
        return await generateFlagQuestion(data['title']);
      case 'images':
        return generateImagesQuestion(
            data['answers'].cast<String>(), data['directory'], data['title']);
    }
  }

  static Question generateMathQuestion() {
    var r = Random();
    int firstInt = r.nextInt(30);
    int secondInt = r.nextInt(50);
    var title = 'Zenbat da $firstInt + $secondInt?';
    List<String> answers = [
      r.nextInt(100).toString(),
      r.nextInt(100).toString(),
      (firstInt + secondInt).toString()
    ];
    answers.shuffle();
    var correctAnswers = answers.indexOf((firstInt + secondInt).toString());
    return Question(
        answers: answers, correctAnswer: correctAnswers, title: title);
  }

  static Question generateImagesQuestion(
      List<String> answers, String directory, String title) {
    Random r = Random();
    var i0 = r.nextInt(answers.length);
    var i1 = r.nextInt(answers.length);
    var i2 = r.nextInt(answers.length);
    var correct = r.nextInt(3);
    String correctTitle;
    switch (correct) {
      case 0:
        correctTitle = answers[i0];
        break;
      case 1:
        correctTitle = answers[i1];
        break;
      case 2:
        correctTitle = answers[i2];
        break;
    }
    var answ = [answers[i0], answers[i1], answers[i2]];
    var image = AssetImage('assets/' +
        directory +
        '/' +
        correctTitle.toLowerCase().replaceAll(" ", "_") +
        '.jpg');
    return Question(
        answers: answ, correctAnswer: correct, image: image, title: title);
  }

  static Future<Question> generateFlagQuestion(String title) async {
    List<dynamic> countriesMap =
        jsonDecode(await rootBundle.loadString('assets/countries.json'));
    Random r = Random();
    List<Map<String, dynamic>> answers = [];
    for (int i = 0; i < 3; i++) {
      var a = r.nextInt(countriesMap.length);
      answers.add(countriesMap[a]);
    }
    int correct = r.nextInt(3);

    List<String> answersEus = [];
    for (var a in answers) {
      answersEus.add(a['label_eu']);
    }
    var enLabel = answers[correct]['label_en'];
    String code = answers[correct]['code'].toString().toLowerCase();

    //PictureProvider pictureProvider = NetworkPicture(SvgPicture.svgByteDecoder,
    //    'https://upload.wikimedia.org/wikipedia/commons/f/fe/$enLabel.svg');
    //PictureProvider pictureProvider = NetworkPicture(SvgPicture.svgByteDecoder,
    //    'https://en.wikipedia.org/wiki/File:Flag_of_$enLabel.svg');
    PictureProvider pictureProvider = NetworkPicture(
        SvgPicture.svgByteDecoder, 'https://flagcdn.com/$code.svg');

    return Question(
        answers: answersEus,
        correctAnswer: correct,
        title: title,
        svgPicture: pictureProvider);
  }
}
