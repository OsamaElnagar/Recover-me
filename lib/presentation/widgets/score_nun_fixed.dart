// ignore_for_file: depend_on_referenced_packages

import 'package:collection/collection.dart';
import '../../data/models/score_model.dart';

List<ScorePointsModel> get scores {
  final data = <double>[4, 30, 35, 17, 45, 55, 23, 19, 20, 33, 22, 40];
  return data
      .mapIndexed(
        (index, element) => ScorePointsModel(
          x: index.toDouble(),
          y: element,
        ),
      )
      .toList();
}
