class AIAnalysisModel {
  final int healthScore;
  final String explanation;

  AIAnalysisModel({
    required this.healthScore,
    required this.explanation,
  });

  factory AIAnalysisModel.fromJson(
      Map<String, dynamic> json) {
    return AIAnalysisModel(
      healthScore: json['healthScore'] ?? 0,
      explanation: json['explanation'] ?? '',
    );
  }
}