import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; // Import TableCalendar package


class ReviewStatsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Review Stats',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Color(0xFFF3E5F5), // Light purple background
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF4F3466), // Dark purple color #4f3466
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4F3466), // Dark purple buttons
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xFF4F3466)), // Icon color as #4f3466
      ),
      home: ReviewStatsPage(),
    );
  }
}

class ReviewStatsPage extends StatefulWidget {
  @override
  _ReviewStatsPageState createState() => _ReviewStatsPageState();
}

class _ReviewStatsPageState extends State<ReviewStatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Stats'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(child: buildContainer(TodayStatsWidget())), // New "Today" container
                  SizedBox(width: 10),
                  Flexible(child: buildContainer(FutureDueWidget())), // New "Future Due" container
                  SizedBox(width: 10),
                  Flexible(child: buildContainer(buildCalendar())), // New "Calendar" container

                ],
              ),
              SizedBox(height: 20),
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
              ),
            ],
          ),
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




class FutureDueChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 2,
        barGroups: [
          BarChartGroupData(
            x: 5,
            barRods: [BarChartRodData(toY: 1.5, color: Colors.green)],
          ),
          BarChartGroupData(
            x: 10,
            barRods: [BarChartRodData(toY: 1, color: Colors.green)],
          ),
          BarChartGroupData(
            x: 15,
            barRods: [BarChartRodData(toY: 1.2, color: Colors.green)],
          ),
          // Add more bars for each day or interval as required
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

// Placeholder widgets for "Today" and "Future Due" sections
class TodayStatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Today", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Divider(),
          Text(
            "Studied 2 cards in 4.84 seconds today (2.42s/card)\n"
                "Again count: 0 (0%)\n"
                "Learn: 2, Review: 0, Relearn: 0, Filtered: 0\n"
                "No mature cards were studied today.",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
class FutureDueWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Future Due", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Divider(),
          Text(
            "The number of reviews due in the future.\n"
                "Total: 2 reviews\n"
                "Average: 0 reviews/day\n"
                "Due tomorrow: 0 reviews",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          // Placeholder for the chart
          SizedBox(
            height: 200, // Height of the chart
            child: FutureDueChart(),
          ),
        ],
      ),
    );
  }
}


// Reviews Chart Widget
class ReviewsChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Reviews', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text('The number of questions you have answered.'),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(value: false, onChanged: (_) {}),
            Text("Time"),
            Radio(value: "1 month", groupValue: "1 month", onChanged: (_) {}),
            Text("1 month"),
            Radio(value: "3 months", groupValue: "1 month", onChanged: (_) {}),
            Text("3 months"),
            Radio(value: "1 year", groupValue: "1 month", onChanged: (_) {}),
            Text("1 year"),
          ],
        ),
        SizedBox(
          height: 200, // Specify a fixed height for the BarChart
          child: BarChart(
            BarChartData(
              maxY: 3,
              alignment: BarChartAlignment.spaceAround,
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: 3.0,
                      color: Colors.orange,
                      width: 20,
                    ),
                  ],
                ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      switch (value.toInt()) {
                        case 0:
                          return Text('Days studied: 1 of 31 (3.23%)');
                        default:
                          return Text('');
                      }
                    },
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
}

// Card Counts Chart Widget
class CardCountsChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Card Counts', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text('Separate suspended/buried cards'),
        SizedBox(height: 10),
        Checkbox(value: true, onChanged: (_) {}),
        SizedBox(
          height: 200, // Specify a fixed height for the PieChart
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: 100,
                  color: Colors.green,
                  title: '100%',
                ),
              ],
              sectionsSpace: 0,
              centerSpaceRadius: 40,
            ),
          ),
        ),
      ],
    );
  }
}

// Review Intervals Chart Widget
class ReviewIntervalsChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Review Intervals', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text('Delays until reviews are shown again.'),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(value: "1 month", groupValue: "95%", onChanged: (_) {}),
            Text("1 month"),
            Radio(value: "50%", groupValue: "95%", onChanged: (_) {}),
            Text("50%"),
            Radio(value: "95%", groupValue: "95%", onChanged: (_) {}),
            Text("95%"),
            Radio(value: "all", groupValue: "95%", onChanged: (_) {}),
            Text("all"),
          ],
        ),
        SizedBox(
          height: 200, // Specify a fixed height for the BarChart
          child: BarChart(
            BarChartData(
              maxY: 2,
              alignment: BarChartAlignment.spaceAround,
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: 1.0,
                      color: Colors.blue,
                      width: 20,
                    ),
                  ],
                ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) => Text('Average interval: 5 days'),
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
}



// CardEase Chart Widget
class CardEaseChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Card Ease', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text('The lower the ease, the more frequently a card will appear.'),
        SizedBox(height: 10),
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
                      toY: 2.0,
                      color: Colors.green,
                      width: 20,
                    ),
                  ],
                ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      switch (value.toInt()) {
                        case 0:
                          return Text('Average ease: 253%');
                        default:
                          return Text('');
                      }
                    },
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
}

// Hourly Breakdown Chart Widget
class HourlyBreakdownChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Hourly Breakdown', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text('Review success rate for each hour of the day.'),
        SizedBox(height: 10),
        // Radio buttons for interval selection
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(value: "1 month", groupValue: "1 year", onChanged: (_) {}),
            Text("1 month"),
            Radio(value: "3 months", groupValue: "1 year", onChanged: (_) {}),
            Text("3 months"),
            Radio(value: "1 year", groupValue: "1 year", onChanged: (_) {}),
            Text("1 year"),
          ],
        ),
        Expanded(
          child: BarChart(
            BarChartData(
              maxY: 3,
              alignment: BarChartAlignment.spaceAround,
              barGroups: [
                BarChartGroupData(
                  x: 17,
                  barRods: [
                    BarChartRodData(
                      toY: 3.0,
                      color: Colors.blue,
                      width: 20,
                    ),
                  ],
                ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      if (value.toInt() == 17) {
                        return Text('18');
                      }
                      return Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) => Text('${(value * 100).toInt()}%'),
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
}

// Answer Buttons Chart Widget
class AnswerButtonsChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Answer Buttons', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text('The number of times you have pressed each button.'),
        SizedBox(height: 10),
        // Radio buttons for interval selection
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(value: "1 month", groupValue: "1 year", onChanged: (_) {}),
            Text("1 month"),
            Radio(value: "3 months", groupValue: "1 year", onChanged: (_) {}),
            Text("3 months"),
            Radio(value: "1 year", groupValue: "1 year", onChanged: (_) {}),
            Text("1 year"),
          ],
        ),
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
                      toY: 1.0,
                      color: Colors.lightGreen,
                      width: 20,
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: 2.0,
                      color: Colors.green,
                      width: 20,
                    ),
                  ],
                ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      switch (value.toInt()) {
                        case 0:
                          return Text('Learning (100%)');
                        case 1:
                          return Text('Young (0%)');
                        default:
                          return Text('');
                      }
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
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
}


