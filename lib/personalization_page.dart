import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalizationPage extends StatefulWidget {
  const PersonalizationPage({super.key});

  @override
  State<PersonalizationPage> createState() => _PersonalizationPageState();
}

class _PersonalizationPageState extends State<PersonalizationPage> {
  final TextEditingController _limitController = TextEditingController();
  double _income = 0;
  double _expense = 0;

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('db-money-mab').get();

    double totalIncome = 0;
    double totalExpense = 0;

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data['source'] == 'Income') {
        totalIncome += data['amount'];
      } else if (data['source'] == 'Expense') {
        totalExpense += data['amount'];
      }
    }

    setState(() {
      _income = totalIncome;
      _expense = totalExpense;
    });
  }

  void _analyzeFinances() {
    if (_limitController.text.isEmpty) {
      _showDialog(
        "Batas Pengeluaran Belum Diisi",
        "Silakan isi batas pengeluaran terlebih dahulu.",
        Colors.red,
      );
      return;
    }

    final double? limit = double.tryParse(_limitController.text);
    if (limit == null) {
      _showDialog(
        "Input Tidak Valid",
        "Masukkan angka saja yang diperbolehkan.",
        Colors.red,
      );
      return;
    }

    String message;
    Color messageColor;
    Widget content;

    if (_expense <= limit) {
      message = "Pengeluaran Tidak Melebihi Batas";
      messageColor = Colors.green;
      content = const Text(
        "Selamat! Pengeluaran Anda sesuai dengan batas yang ditentukan.",
        textAlign: TextAlign.center,
      );
    } else if (_expense > limit && _expense <= limit * 1.5) {
      message = "Pengeluaran Melebihi Batas";
      messageColor = Colors.yellow;
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            "Saran yang bisa Anda lakukan:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text("1. Tinjau kebutuhan prioritas"),
          Text("2. Kurangi pengeluaran tidak penting"),
        ],
      );
    } else if (_expense > limit * 1.5 && _expense <= limit * 2) {
      message = "Pengeluaran Sangat Jauh dari Batas";
      messageColor = Colors.orange;
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            "Saran yang bisa Anda lakukan:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text("1. Memantau pengeluaran secara ketat"),
          Text("2. Mencegah sifat konsumtif"),
          Text("3. Cari alternatif yang lebih murah"),
        ],
      );
    } else {
      message = "Pengeluaran Anda Ekstrim";
      messageColor = Colors.red;
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Saran yang bisa Anda lakukan:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("1. Menyimpan dana darurat"),
          const Text("2. Mencari bantuan dari ahli keuangan"),
          const Text("3. Membuat anggaran yang lebih ketat"),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {},
            child: const Text(
              "Klik di sini untuk belajar lebih lanjut tentang manajemen keuangan",
              style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
        ],
      );
    }

    _showDialog(message, content, messageColor);
  }

  void _showDialog(String title, dynamic content, Color titleColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        content: content is Widget ? content : Text(content, textAlign: TextAlign.center),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9575),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Tutup",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Personalization",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDisplayField(
                "Pemasukan Bulanan",
                _income,
                Icons.attach_money,
              ),
              const SizedBox(height: 16),
              _buildDisplayField(
                "Pengeluaran Bulanan",
                _expense,
                Icons.money_off,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                "Batas Pengeluaran",
                "Masukkan Batas Pengeluaran",
                _limitController,
                Icons.warning,
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _analyzeFinances,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9575),
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Analisis Keuangan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisplayField(String label, double value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE8E1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                value.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFFFFE8E1),
            prefixIcon: Icon(icon, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
