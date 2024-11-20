import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatelessWidget {
  final List<Map<String, dynamic>> topSpending = [
    {
      'icon': Icons.credit_card,
      'title': 'Transfer',
      'date': '24-8-2024',
      'amount': 100,
      'color': Colors.green,
    },
    {
      'icon': Icons.directions_car,
      'title': 'Transportation',
      'date': '21-8-2024',
      'amount': 600,
      'color': Colors.red,
    },
    {
      'icon': Icons.credit_card,
      'title': 'Transfer',
      'date': '22-8-2024',
      'amount': 600,
      'color': Colors.green,
    },
    {
      'icon': Icons.credit_card,
      'title': 'Transfer',
      'date': '24-8-2024',
      'amount': 5000,
      'color': Colors.green,
    },
  ];

  StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Statistics",
          style: TextStyle(fontFamily: 'Inter'),
        ),
      ),
      body: Column(
        children: [
          // Tabs (Day, Week, Month, Year)
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: Colors.orange.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabButton(context, "Day", false),
                _buildTabButton(context, "Week", false),
                _buildTabButton(context, "Month", true),
                _buildTabButton(context, "Year", false),
              ],
            ),
          ),

          // Graph Section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(show: true),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 4000),
                        FlSpot(1, 6000),
                        FlSpot(2, 10000),
                      ],
                      isCurved: true,
                      color: Colors.orange,
                      barWidth: 4,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Top Spending Section
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Top Spending",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: topSpending.length,
                      itemBuilder: (context, index) {
                        final item = topSpending[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.shade200,
                            child: Icon(item['icon'], color: Colors.orange),
                          ),
                          title: Text(
                            item['title'],
                            style: TextStyle(fontFamily: 'Inter'),
                          ),
                          subtitle: Text(
                            item['date'],
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Text(
                            "${item['amount']}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              color: item['color'],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/'); // Navigate to Home
              },
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add_income'); // Navigate to Add Income
              },
              icon: const Icon(Icons.add, color: Colors.orange),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/statistics'); // Navigate to Statistics
              },
              icon: const Icon(Icons.bar_chart),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String text, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}