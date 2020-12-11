import 'package:asmatzen/question.dart';
import 'package:asmatzen/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      child: Text("Jokatu!"),
    ));
  }
}

class QuizWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<QuizModel>(
          builder: (context, value, child) {
            if (value.currectQuestion == value.questions.length) {
              return ListView(
                children: value.questions
                    .map(
                      (q) => ListTile(
                        title: Text(q.title),
                        leading: q.isCorrect ? Icon(Icons.check) : Text('x'),
                      ),
                    )
                    .toList(),
              );
            }
            return QuestionWidget(
              question: value.questions[value.currectQuestion],
            );
          },
        )
      ],
    );
  }
}

class QuestionWidget extends StatefulWidget {
  final Question question;

  const QuestionWidget({Key key, this.question}) : super(key: key);
  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.question.title),
        if (widget.question.image != null) Image(image: widget.question.image),
        ListView(
          children: widget.question.answers
              .map(
                (a) => ElevatedButton(
                  child: Text(a),
                  onPressed: () {
                    // Erantzuna zuzena da
                    if (widget.question.correctAnswer ==
                        widget.question.answers.indexOf(a)) {
                      Provider.of<QuizModel>(context, listen: false)
                          .setCorrect();
                      // Erantzuna ez da zuzena
                    } else {
                      Provider.of<QuizModel>(context, listen: false)
                          .setIncorrect();
                    }
                  },
                ),
              )
              .toList(),
        )
      ],
    );
  }
}
