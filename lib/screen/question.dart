import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:chemcheck/model/question_model.dart';
import 'package:chemcheck/model/question_raw.dart';
import 'package:chemcheck/model/wrong.dart';
import 'package:chemcheck/screen/complete.dart';

// Questionはjsonへのpathを受け取る
class Question extends StatefulWidget {
  final String link;
  const Question({Key? key, required this.link}) : super(key: key);

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  List<QuestionModel> questions = [];
  List<WrongAnswer> wrongAnswers = [];
  List<String> multipleChoices = [];
  String type = '';
  String category = '';
  int currentQuestionIndex = 0;
  int correctAnswerCount = 0;
  bool showAfterAnswer = false;
  bool isCorrect = false;
  bool disableButton = false;

  @override
  void initState() {
    super.initState();
    fetchQuestionModels();
  }

  Future<void> fetchQuestionModels() async {
    final responseData;
    // get json from the server
    final response = await http.get(Uri.parse(widget.link));
    late final List<QuestionModel> parsedQuestionModels;
    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      responseData = parseRawQuestionModels(body);
      parsedQuestionModels = responseData.questions
          .map<QuestionModel>((json) => QuestionModel.fromJson(json))
          .toList();
      parsedQuestionModels.shuffle();
      type = responseData.type;
    } else {
      throw Exception('Failed to load question models');
    }
    if (responseData.category == null) {
      throw Exception('Failed to load category');
    }
    setState(() {
      questions = parsedQuestionModels;
      category = responseData.category;

      if (type == 'Multiple') {
        generateMultipleChoices();
      }
    });
  }

  RawQuestionsModel parseRawQuestionModels(response) {
    final parsed = jsonDecode(response);
    // parse json
    final data = RawQuestionsModel.fromJson(parsed);
    return data;
  }

  void checkAnswer(dynamic selectedAnswer) {
    if (questions[currentQuestionIndex].answer == selectedAnswer) {
      correctAnswerCount++;
    } else {
      wrongAnswers.add(
        WrongAnswer(
          id: currentQuestionIndex + 1,
          choice: selectedAnswer,
          question: questions[currentQuestionIndex].question,
          correctAnswer: type == 'T/F'
              ? questions[currentQuestionIndex].answer.toString()
              : questions[currentQuestionIndex].answer,
          explanation: questions[currentQuestionIndex].explanation,
        ),
      );
    }
    setState(() {
      showAfterAnswer = true;
      isCorrect = questions[currentQuestionIndex].answer == selectedAnswer;
      disableButton = true;
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        currentQuestionIndex = 0;
      }

      showAfterAnswer = false;
      isCorrect = false;
      disableButton = false;
      if (type == 'Multiple') {
        generateMultipleChoices();
      }
    });
  }

  void generateMultipleChoices() {
    final correctAnswer = questions[currentQuestionIndex].answer;
    final choices = questions
        .where((question) => question.answer != correctAnswer)
        .map((question) => question.answer)
        .toList()
      ..shuffle();
    // setにして重複を削除→take(3)で3つだけ取得
    final randomChoices = choices.toSet().take(3).toList();
    multipleChoices = [
      ...randomChoices,
      correctAnswer,
    ]..shuffle();
    setState(() {
      multipleChoices = multipleChoices;
      print(multipleChoices);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
              '$category [${currentQuestionIndex + 1}/${questions.length}]'),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.systemGrey),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: questions.isEmpty
                    ? const CupertinoActivityIndicator()
                    : Text(
                        questions[currentQuestionIndex].question,
                      ),
              ),
              const SizedBox(height: 16),
              // 選択肢（typeで分岐）
              if (type == 'T/F')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CupertinoButton.filled(
                      child: const Text('True'),
                      onPressed: disableButton
                          ? null
                          : () {
                              checkAnswer(true);
                            },
                    ),
                    CupertinoButton.filled(
                      child: const Text('False'),
                      onPressed: disableButton
                          ? null
                          : () {
                              checkAnswer(false);
                            },
                    ),
                  ],
                )
              else
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: multipleChoices
                      .map((choice) => CupertinoButton(
                            child: Text(choice.toString()),
                            onPressed: disableButton
                                ? null
                                : () {
                                    checkAnswer(choice);
                                  },
                          ))
                      .toList(),
                ),
              const SizedBox(height: 16),
              if (showAfterAnswer)
                Text(
                  questions[currentQuestionIndex].answer.toString(),
                  style: TextStyle(
                    color: isCorrect
                        ? CupertinoColors.systemGreen
                        : CupertinoColors.systemRed,
                  ),
                )
              else
                Container(),
              if (showAfterAnswer)
                Text(questions[currentQuestionIndex].explanation)
              else
                Container(),
              if (showAfterAnswer)
                CupertinoButton(
                  // 次の問題がなかったらボタンの表示を変える
                  child: Text(currentQuestionIndex < questions.length - 1
                      ? 'Next Question'
                      : 'Finish'),
                  onPressed: () {
                    if (currentQuestionIndex < questions.length - 1) {
                      nextQuestion();
                    } else {
                      Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute<void>(
                          builder: (context) => Result(
                            correctAnswers: correctAnswerCount,
                            totalQuestions: questions.length,
                            wrongAnswers: wrongAnswers,
                          ),
                        ),
                        (route) => false,
                      );
                    }
                  },
                ),
            ],
          ),
        ));
  }
}
