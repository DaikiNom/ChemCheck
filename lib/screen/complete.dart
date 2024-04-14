import 'package:flutter/cupertino.dart';
import 'package:chemcheck/model/wrong.dart';
import 'package:chemcheck/screen/home.dart';

class Result extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;
  final List<WrongAnswer> wrongAnswers;

  const Result({
    Key? key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.wrongAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double correctRatio = correctAnswers / totalQuestions;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('結果'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '正答率: ${(correctRatio * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            CupertinoButton(
                child: const Text('問題と解説'),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (context) =>
                          missedQuestions(wrongAnswers: wrongAnswers),
                    ),
                  );
                }),
            const SizedBox(height: 20),
            CupertinoButton(
              child: const Text('トップに戻る'),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute<void>(
                    builder: (context) => const Home(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class missedQuestions extends StatelessWidget {
  final List<WrongAnswer> wrongAnswers;

  const missedQuestions({Key? key, required this.wrongAnswers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('間違えた問題'),
        ),
        // CupertinoListTileに問題文を表示→押すと解説と正解を表示
        child: SafeArea(
          child: wrongAnswers.isEmpty
              ? const Center(
                  child: Text('間違えた問題はありません'),
                )
              : CupertinoListSection(
                  children: wrongAnswers
                      .map(
                        (wrongAnswer) => CupertinoListTile(
                          title: Text(
                              '問${wrongAnswer.id} ${wrongAnswer.question}'),
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute<void>(
                                builder: (context) => explanationOfQuestion(
                                  wrongAnswer: wrongAnswer,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
        ));
  }
}

class explanationOfQuestion extends StatelessWidget {
  final WrongAnswer wrongAnswer;

  const explanationOfQuestion({Key? key, required this.wrongAnswer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('問${wrongAnswer.id} - 解説'),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(wrongAnswer.question),
                const SizedBox(height: 30),
                Text('正解: ${wrongAnswer.correctAnswer}'),
                Text('あなたの解答: ${wrongAnswer.choice}',
                    style: const TextStyle(color: CupertinoColors.systemRed)),
                const SizedBox(height: 15),
                Text('解説: ${wrongAnswer.explanation}'),
                CupertinoButton(
                  child: const Text('戻る'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
