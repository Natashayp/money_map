import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 2); // Create a NumberFormat for currency

  // Fungsi untuk mengambil transaksi dari Firebase
  Future<List<Map<String, dynamic>>> _getTransactions() async {
    var querySnapshot = await _firestore.collection('db-money-mab').get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 241, 230, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.black),
          onPressed: () {
            // Tindakan ketika ikon home ditekan
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: CircleAvatar(
                backgroundColor: Colors.black12,
                child: IconButton(
                  icon: const Icon(Icons.account_balance_wallet, color: Colors.black),
                  onPressed: () {
                    // Navigasi ke halaman analisis keuangan
                    Navigator.pushNamed(context, '/personalization');
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hello, Gabjes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            const Text(
              "Transaction History",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(  
                future: _getTransactions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching data.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No transactions available.'));
                  } else {
                    var transactions = snapshot.data!;
                    double totalBalance = transactions.fold(0.0, (previousValue, transaction) {
                      final amount = transaction['amount'] as num? ?? 0;
                      final source = transaction['source'] ?? 'Unknown';
                      return source == 'Expense' ? previousValue - amount : previousValue + amount;
                    });

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBalanceCard(totalBalance),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: transactions.length,
                            itemBuilder: (context, index) {
                              final transaction = transactions[index];
                              final category = transaction['category'] ?? "Unknown";
                              final amount = transaction['amount'] as num? ?? 0;
                              final date = transaction['date']?.toDate() ?? DateTime.now();
                              final notes = transaction['notes'] ?? "No notes";
                              final source = transaction['source'] ?? "Unknown";
                              final isExpense = source == 'Expense';

                              return _buildTransactionTile(category, amount, date, notes, isExpense);
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add_income');
              },
              icon: const Icon(Icons.add, color: Colors.orange),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/statistics');
              },
              icon: const Icon(Icons.bar_chart),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(double totalBalance) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Balance",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currencyFormat.format(totalBalance),  // Format the total balance with commas
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(
    String category,
    num amount,
    DateTime date,
    String notes,
    bool isExpense,
  ) {
    IconData categoryIcon;
    switch (category) {
      case 'Food':
        categoryIcon = Icons.fastfood;
        break;
      case 'Transportation':
        categoryIcon = Icons.directions_car;
        break;
      case 'Income':
        categoryIcon = Icons.attach_money;
        break;
      default:
        categoryIcon = Icons.category;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange.shade100,
            child: Icon(categoryIcon, color: Colors.orange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notes,
                  style: const TextStyle(fontFamily: 'Inter', color: Colors.black54),
                ),
                Text(
                  "${date.day}-${date.month}-${date.year}",
                  style: const TextStyle(fontFamily: 'Inter', color: Colors.black45),
                ),
              ],
            ),
          ),
          Text(
            (isExpense ? "- " : "+ ") + _currencyFormat.format(amount.abs()),  // Format the amount with commas
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: isExpense ? Colors.red : Colors.green,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
