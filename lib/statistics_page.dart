import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int selectedPage = 2;
  int activeTab = 2;

  List<FlSpot> chartData = [];
  List<Map<String, dynamic>> allSpendings = [];
  List<Map<String, dynamic>> filteredSpendings = [];
  List<FlSpot> incomeData = [];
  List<FlSpot> expenseData = [];

  @override
  void initState() {
    super.initState();
    _getSpendings();
  }

  Future<void> _getSpendings() async {
    var querySnapshot = await FirebaseFirestore.instance.collection('db-money-mab').get();

    for (var doc in querySnapshot.docs) {
      DateTime date = doc['date'].toDate();
      String formattedDate = DateFormat('dd-MM-yyyy').format(date);

      setState(() {
        var source = doc['source'];
        allSpendings.add({
          'notes': doc['notes'],
          'category': doc['category'],
          'amount': doc['amount'].toString(),
          'date': formattedDate,
          'source': source,
        });
      });
    }
    _filterSpendings();
  }

  void _filterSpendings() {
    setState(() {
      filteredSpendings = allSpendings;
    });

    _generateChartData();
  }

  void navigateToPage(int index) {
    setState(() {
      selectedPage = index;
    });
    if (index == 0) {
      Navigator.pushNamed(context, '/');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/add_income');
    }
  }

  void _generateChartData() {
    Map<int, double> incomeMonthlyTotals = {};
    Map<int, double> expenseMonthlyTotals = {};

    for (var spending in filteredSpendings) {
      DateTime date = DateFormat('dd-MM-yyyy').parse(spending['date']);
      int month = date.month;
      double amount = double.parse(spending['amount']);
      String source = spending['source'];

      if (source == 'Income') {
        incomeMonthlyTotals[month] = (incomeMonthlyTotals[month] ?? 0) + amount;
      } else if (source == 'Expense') {
        expenseMonthlyTotals[month] = (expenseMonthlyTotals[month] ?? 0) + amount;
      }
    }

    List<FlSpot> incomeSpots = [];
    List<FlSpot> expenseSpots = [];
    double accumulatedIncome = 0;
    double accumulatedExpense = 0;

    for (int i = 1; i <= 12; i++) {
      if (incomeMonthlyTotals.containsKey(i)) {
        accumulatedIncome += incomeMonthlyTotals[i]!;
      }
      incomeSpots.add(FlSpot(i.toDouble(), accumulatedIncome));

      if (expenseMonthlyTotals.containsKey(i)) {
        accumulatedExpense += expenseMonthlyTotals[i]!;
      }
      expenseSpots.add(FlSpot(i.toDouble(), accumulatedExpense));
    }

    setState(() {
      incomeData = incomeSpots;
      expenseData = expenseSpots;
    });
  }

  Icon _getCategoryIcon(String category) {
    switch (category) {
      case 'Salary':
        return const Icon(Icons.attach_money, color: Colors.green);
      case 'Investment':
        return const Icon(Icons.trending_up, color: Colors.blue);
      case 'Bonus':
        return const Icon(Icons.card_giftcard, color: Colors.orange);
      case 'Other':
        return const Icon(Icons.category, color: Colors.grey);
      case 'Shopping':
        return const Icon(Icons.shopping_cart, color: Colors.purple);
      case 'Food':
        return const Icon(Icons.fastfood, color: Colors.red);
      case 'Groceries':
        return const Icon(Icons.local_grocery_store, color: Colors.brown);
      case 'Entertainment':
        return const Icon(Icons.movie, color: Colors.indigo);
      case 'Health':
        return const Icon(Icons.health_and_safety, color: Colors.pink);
      default:
        return const Icon(Icons.error, color: Colors.red);
    }
  }

  String formatRupiah(double amount) {
    final format = NumberFormat.simpleCurrency(locale: 'id_ID');
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_income');
        },
        backgroundColor: const Color(0xFFFF9575),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavigationBarIcon(Icons.home, 0),
            const SizedBox(width: 48),
            _buildNavigationBarIcon(Icons.bar_chart, 2),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton(context, 'Rekap Income dan Expense', activeTab == 2, 2),
              ],
            ),
          ),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    if (activeTab == 2) ...[
                      LineChartBarData(
                        isCurved: false,
                        color: const Color(0xFF00A900),
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                        spots: incomeData,
                      ),
                      LineChartBarData(
                        isCurved: false,
                        color: const Color(0xFFFF0000),
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                        spots: expenseData,
                      ),
                    ],
                  ],
                  minY: 0,
                  maxY: incomeData.isNotEmpty || expenseData.isNotEmpty
                      ? (incomeData.isNotEmpty
                          ? incomeData.reduce((a, b) => a.y > b.y ? a : b).y
                          : 0) > (expenseData.isNotEmpty
                              ? expenseData.reduce((a, b) => a.y > b.y ? a : b).y
                              : 0)
                          ? incomeData.reduce((a, b) => a.y > b.y ? a : b).y
                          : expenseData.reduce((a, b) => a.y > b.y ? a : b).y
                      : 0,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString(),
                              style: const TextStyle(fontSize: 14, color: Colors.grey));
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey,
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(color: Colors.grey),
                      bottom: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Spending',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...filteredSpendings.map((spending) {
                  return SpendingItem(
                    icon: _getCategoryIcon(spending['category']),
                    title: spending['notes'],
                    category: spending['category'],
                    amount: formatRupiah(double.parse(spending['amount'])),
                    date: spending['date'],
                    amountColor: spending['source'] == 'Income'
                        ? Colors.green
                        : Colors.red,
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String text, bool isSelected, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          activeTab = index;
        });
        _filterSpendings();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE6F9F5) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? const Color(0xFF00A900) : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationBarIcon(IconData icon, int index) {
    return GestureDetector(
      onTap: () => navigateToPage(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Icon(
          icon,
          size: 32,
          color: selectedPage == index ? const Color(0xFFFF9575) : Colors.grey,
        ),
      ),
    );
  }
}

class SpendingItem extends StatelessWidget {
  final Icon icon;
  final String title;
  final String category;
  final String amount;
  final String date;
  final Color amountColor;

  const SpendingItem({
    required this.icon,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(category, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: TextStyle(fontSize: 16, color: amountColor)),
              const SizedBox(height: 4),
              Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
