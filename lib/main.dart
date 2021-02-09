import 'package:asmatzen/question.dart';
import 'package:asmatzen/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool playing = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('asmatzen'),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: FutureBuilder<List<Question>>(
            future: QuizModel.loadQuestions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: ChangeNotifierProvider(
                    create: (context) => QuizModel(snapshot.data),
                    builder: (context, child) {
                      if (!playing) {
                        return Container(
                            child: ElevatedButton(
                          child:
                              Text("Jokatu!", textDirection: TextDirection.ltr),
                          onPressed: () {
                            setState(() {
                              playing = true;
                            });
                          },
                        ));
                      } else {
                        return Container(child: QuizWidget());
                      }
                    },
                  ),
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class QuizWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuizModel>(
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
        } else {
          return SizedBox(
            height: 400,
            child: QuestionWidget(
              question: value.questions[value.currectQuestion],
            ),
          );
        }
      },
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(widget.question.title),
          if (widget.question.image != null)
            Image(
              image: widget.question.image,
            ),
          if (widget.question.svgPicture != null)
            SvgPicture(widget.question.svgPicture),
          //if (widget.question.image != null) Image(image: widget.question.image),
          SizedBox(
            height: 200,
            child: ListView(
              children: widget.question.answers
                  .map(
                    (a) => Expanded(
                      child: ElevatedButton(
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
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
