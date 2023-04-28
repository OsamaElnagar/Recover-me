import 'package:collection/collection.dart';

class ScorePointsModel {
  final double x;
  final double y;

  ScorePointsModel({required this.x, required this.y});
}

List<ScorePointsModel> get scores {
  final data = <double>[4, 30, 35, 17, 45, 55, 23, 19, 20, 33, 22, 40];
  return data
      .mapIndexed(
        (index, element) => ScorePointsModel(
          x: index.toDouble(),
          y: element,
        )).toList();
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
