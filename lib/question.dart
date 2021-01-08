import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Question {
  List<String> answers;
  int correctAnswer;
  String title;
  ImageProvider image;
  PictureProvider svgPicture;
  bool isCorrect;

  Question(
      {this.answers,
      this.correctAnswer,
      this.title,
      this.image,
      this.isCorrect,
      this.svgPicture});
}
