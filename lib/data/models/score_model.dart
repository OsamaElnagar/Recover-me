
class ScorePointsModel {
  final double x;
  final double y;

  ScorePointsModel({required this.x, required this.y});
}

class ScoreModel {
  final String dateTime;
  final double score;

  ScoreModel({required this.dateTime, required this.score});

  Map<String, dynamic> toMap() {
    return {'dateTime': dateTime, 'score': score};
  }

  factory ScoreModel.fromMap(Map<String, dynamic> map) {
    return ScoreModel(
      dateTime: map['dateTime'] as String,
      score: map['score'] as double,
    );
  }
}
