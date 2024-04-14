// Modelの定義
class QuestionModel {
  final String question;
  final dynamic answer;
  final String explanation;

  QuestionModel({
    required this.question,
    required this.answer,
    required this.explanation,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question: json['question'],
      answer: json['answer'],
      explanation: json['explanation'],
    );
  }
}
