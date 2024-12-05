import 'package:flutter/material.dart';

class FinanceData {
  double income;
  double expense;
  double expenseLimit;

  FinanceData({
    required this.income,
    required this.expense,
    required this.expenseLimit,
  });

  double get predictedIncome => income * 1.1; // Predicted income with 10% increase
  bool get isOverLimit => expense > expenseLimit;

  String get suggestion {
    if (isOverLimit) {
      return "Pengeluaran Anda melebihi batas. Cobalah mengurangi belanja yang tidak penting atau meningkatkan pendapatan.";
    } else {
      return "Keuangan Anda terkendali. Pertahankan pola pengeluaran Anda!";
    }
  }
}

class PersonalizationPage extends StatefulWidget {
  @override
  _PersonalizationPageState createState() => _PersonalizationPageState();
}

class _PersonalizationPageState extends State<PersonalizationPage> {
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _expenseController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();

  double? _predictedIncome;
  String? _suggestion;

  void _analyzeFinance() {
    final income = double.tryParse(_incomeController.text) ?? 0.0;
    final expense = double.tryParse(_expenseController.text) ?? 0.0;
    final limit = double.tryParse(_limitController.text) ?? 0.0;

    final financeData = FinanceData(income: income, expense: expense, expenseLimit: limit);

    setState(() {
      _predictedIncome = financeData.predictedIncome;
      _suggestion = financeData.suggestion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Personalisasi Keuangan",
          style: TextStyle(
            fontFamily: 'Poppins', 
            fontSize: 28, 
            fontWeight: FontWeight.bold, 
            color: Colors.purpleAccent,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              icon: const Icon(Icons.person, color: Colors.purpleAccent),
              onPressed: () {
                Navigator.pushNamed(context, '/personalization');
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Income field
            TextField(
              controller: _incomeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Pemasukan Bulanan",
                prefixIcon: Icon(Icons.attach_money, color: Colors.purpleAccent),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 15),

            // Expense field
            TextField(
              controller: _expenseController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Pengeluaran Bulanan",
                prefixIcon: Icon(Icons.money_off, color: Colors.purpleAccent),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 15),

            // Limit field
            TextField(
              controller: _limitController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Batas Pengeluaran",
                prefixIcon: Icon(Icons.warning, color: Colors.orangeAccent),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Analyze Button
            ElevatedButton(
              onPressed: _analyzeFinance,
              child: Text(
                "Analisis Keuangan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            SizedBox(height: 30),

            // Results display
            if (_predictedIncome != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Prediksi Pemasukan Bulan Depan: Rp${_predictedIncome!.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ),
            SizedBox(height: 15),

            if (_suggestion != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _suggestion!.contains("melebihi") ? Colors.red[50] : Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _suggestion!,
                  style: TextStyle(
                    fontSize: 16,
                    color: _suggestion!.contains("melebihi") ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
