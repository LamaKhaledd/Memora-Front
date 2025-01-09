
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../statistics_screen.dart';

class ReviewStatsPage extends StatefulWidget {
  @override
  _ReviewStatsPageState createState() => _ReviewStatsPageState();
}

class _ReviewStatsPageState extends State<ReviewStatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Statistics",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
              ),
            ),
            // New Block: Flashcard Statistics Overview
            //  buildContainer(FlashcardStatsOverview()),

            //   SizedBox(height: 20),

            // Existing Rows for "Today", "Future Due", etc.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(child: buildContainer(TodayStatsWidget())),
                SizedBox(width: 10),
                Flexible(child: buildContainer(FutureDueWidget())),
                SizedBox(width: 10),
                Flexible(child: buildContainer(buildCalendar())),
              ],
            ),

            SizedBox(height: 20),

            /*
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(child: buildContainer(CardEaseChart())),
                  SizedBox(width: 10),
                  Flexible(child: buildContainer(HourlyBreakdownChart())),
                  SizedBox(width: 10),
                  Flexible(child: buildContainer(AnswerButtonsChart())),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(child: buildContainer(ReviewsChart())),
                  SizedBox(width: 10),
                  Flexible(child: buildContainer(CardCountsChart())),
                  SizedBox(width: 10),
                  Flexible(child: buildContainer(ReviewIntervalsChart())),
                ],
              ),*/
          ],
        ),

      ),

    );

  }

  Widget buildContainer(Widget child) {
    return Container(
      height: 400,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
// Flashcard Stats Overview - Dummy Data Block
Widget FlashcardStatsOverview() {
  return Column(
    children: [
      Text('Flashcard Statistics', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      SizedBox(height: 10),
      Text('Overview of your recent flashcard reviews', style: TextStyle(fontSize: 16)),
      SizedBox(height: 20),
      // Example BarChart for Average Time per Card (Dummy Data)
      Expanded(
        child: BarChart(
          BarChartData(
            maxY: 2,
            alignment: BarChartAlignment.spaceAround,
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: 1.5,
                    color: Colors.blue,
                    width: 20,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: 1.2,
                    color: Colors.green,
                    width: 20,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(
                    toY: 0.8,
                    color: Colors.red,
                    width: 20,
                  ),
                ],
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Text('Card ${value.toInt() + 1}'),
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    ],
  );
}



// Calendar widget
Widget buildCalendar() {
  return TableCalendar(
    firstDay: DateTime.utc(2020, 1, 1),
    lastDay: DateTime.utc(2030, 12, 31),
    focusedDay: DateTime.now(),
    calendarFormat: CalendarFormat.month,
    headerStyle: HeaderStyle(formatButtonVisible: false),
  );
}
}


class FlashcardStatsBlock extends StatelessWidget {
  final int totalReviewed;
  final int correctAnswers;
  final int incorrectAnswers;
  final int dueForReview;

  FlashcardStatsBlock({
    required this.totalReviewed,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.dueForReview,
  });

  @override
  Widget build(BuildContext context) {
    double accuracy = totalReviewed > 0
        ? (correctAnswers / totalReviewed) * 100
        : 0.0;

    return Card(
      margin: EdgeInsets.all(16),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Reduced padding from 24.0 to 16.0
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Flashcard Stats',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20, // Reduced font size
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 12), // Reduced space

            // Total Reviewed
            StatCardItem(
              label: 'Total Reviewed:',
              value: '$totalReviewed',
              valueStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Reduced font size
            ),
            SizedBox(height: 8), // Reduced space

            // Correct Answers
            StatCardItem(
              label: 'Correct Answers:',
              value: '$correctAnswers',
              valueStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green), // Reduced font size
            ),
            SizedBox(height: 8), // Reduced space

            // Incorrect Answers
            StatCardItem(
              label: 'Incorrect Answers:',
              value: '$incorrectAnswers',
              valueStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red), // Reduced font size
            ),
            SizedBox(height: 8), // Reduced space

            // Due for Review
            StatCardItem(
              label: 'Due for Review:',
              value: '$dueForReview',
              valueStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange), // Reduced font size
            ),
            SizedBox(height: 12), // Reduced space

            // Accuracy with Progress Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Accuracy:',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]), // Reduced font size
                ),
                Text(
                  '${accuracy.toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: accuracy >= 80 ? Colors.green : Colors.red),
                ),
              ],
            ),
            SizedBox(height: 6), // Reduced space
            LinearProgressIndicator(
              value: accuracy / 100,
              backgroundColor: Colors.grey[200],
              color: accuracy >= 80 ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

class StatCardItem extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle valueStyle;

  StatCardItem({
    required this.label,
    required this.value,
    required this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
        Text(
          value,
          style: valueStyle,
        ),
      ],
    );
  }
}
