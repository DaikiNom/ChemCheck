class RawQuestionsModel {
  final String category;
  final String type;
  final List questions;

  RawQuestionsModel({
    required this.category,
    required this.type,
    required this.questions,
  });

  factory RawQuestionsModel.fromJson(Map<String, dynamic> json) {
    return RawQuestionsModel(
      category: json['category'],
      type: json['type'],
      questions: json['questions'],
    );
  }
}
