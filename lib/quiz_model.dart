import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:asmatzen/question.dart';
import 'package:flutter/cupertino.dart';

class QuizModel extends ChangeNotifier {
  int currectQuestion = 0;
  List<Question> questions;

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

  void loadQuestions() {
    List<Map<String, dynamic>> questionsMap =
        jsonDecode(File('/assets/galderak.json').readAsStringSync());
    for (int i = 0; i < 10; i++) {
      int random = Random().nextInt(questionsMap.length);
      questions[i] = loadQuestion(questionsMap[i]);
    }
  }

  Question loadQuestion(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'maths':
        return generateMathQuestion();
      case 'mountains':
        return generateImagesQuestion(
            data['answers'], data['directory'], data['title']);
    }
  }

  Question generateMathQuestion() {
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
    return Question()
      ..answers = answers
      ..correctAnswer = correctAnswers
      ..title = title;
  }

  Question generateImagesQuestion(
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
    var image = FileImage(File(directory + '/' + correctTitle + '.jpg'));
    return Question()
      ..answers = answ
      ..correctAnswer = correct
      ..image = image
      ..title = title;
  }
}
