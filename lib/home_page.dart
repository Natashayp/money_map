import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 2);
  int selectedTab = 0; // Default tab: Home

  Future<List<Map<String, dynamic>>> _getTransactions() async {
    var querySnapshot = await _firestore.collection('db-money-mab').get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<String> _getUserName() async {
    var userProfile = await _firestore.collection('profil').doc('user_profile').get();
    return userProfile.data()?['name'] ?? 'Unknown';
  }

  void navigateToPage(int index) {
    if (index == 1) {
      Navigator.pushNamed(context, '/add_income');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/statistics').then((_) {
        setState(() {
          selectedTab = 0;
        });
      });
    } else {
      setState(() {
        selectedTab = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 235,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF9575), Color(0xFFFFCBA4)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder<String>(
                        future: _getUserName(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text('Error fetching name');
                          } else {
                            final userName = snapshot.data ?? 'Unknown';
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Hello,",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.account_balance_wallet, color: Colors.black),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.person, color: Colors.black),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProfilePage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _getTransactions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text('Error fetching data.');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No transactions available.');
                    } else {
                      var transactions = snapshot.data!;
                      double totalBalance = transactions.fold(0.0, (previousValue, transaction) {
                        final amount = transaction['amount'] as num? ?? 0;
                        final source = transaction['source'] ?? 'Unknown';
                        return source == 'Expense' ? previousValue - amount : previousValue + amount;
                      });

                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              spreadRadius: 1.0,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total Balance",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _currencyFormat.format(totalBalance),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(34),
                      topRight: Radius.circular(34),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Transaction History",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder<List<Map<String, dynamic>>>(
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
                            return ListView.builder(
                              shrinkWrap: true,  // Ensure the list doesn't take more space than needed
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                final transaction = transactions[index];
                                final category = transaction['category'] ?? "Unknown";
                                final amount = transaction['amount'] as num? ?? 0;
                                final date = transaction['date']?.toDate() ?? DateTime.now();
                                final source = transaction['source'] ?? "Unknown";
                                final isExpense = source == 'Expense';

                                return TransactionItem(
                                  icon: _getCategoryIcon(category),
                                  title: category,
                                  category: source,
                                  amount: _currencyFormat.format(amount.abs()),
                                  date: "${date.day}-${date.month}-${date.year}",
                                  amountColor: isExpense ? Colors.red : Colors.green,
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_income');
        },
        backgroundColor: const Color(0xFFFF9575),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavigationBarIcon(Icons.home, 0),
            const SizedBox(width: 48), // Space for FAB
            _buildNavigationBarIcon(Icons.bar_chart, 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBarIcon(IconData icon, int index) {
    return GestureDetector(
      onTap: () => navigateToPage(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: selectedTab == index ? const Color(0xFF00A900) : Colors.grey,
          ),
          if (selectedTab == index)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF00A900),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
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
}

class TransactionItem extends StatelessWidget {
  final Icon icon;
  final String title;
  final String category;
  final String amount;
  final String date;
  final Color amountColor;

  const TransactionItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.amountColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
