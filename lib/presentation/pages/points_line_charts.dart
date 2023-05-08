import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:recover_me/data/models/score_model.dart';

class LineChartsWidget extends StatelessWidget {
  const LineChartsWidget({Key? key, required this.points}) : super(key: key);

  final List<ScorePointsModel> points;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child : LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: points.map((e) => FlSpot(e.x, e.y)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
