class WrongAnswer {
  final int id;
  final dynamic choice;
  final String question;
  final String correctAnswer;
  final String explanation;

  WrongAnswer(
      {required this.id,
      required this.choice,
      required this.question,
      required this.correctAnswer,
      required this.explanation});
}
