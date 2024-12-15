import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';

class AddSourceIncomePage extends StatefulWidget {
  @override
  _AddSourceIncomePageState createState() => _AddSourceIncomePageState();
}

class _AddSourceIncomePageState extends State<AddSourceIncomePage> {
  String? _selectedSourceType;
  String? _selectedCategory;
  DateTime? _selectedDate;

  final List<Map<String, dynamic>> incomeCategories = [
    {"label": "Salary", "icon": Icons.money},
    {"label": "Investment", "icon": Icons.trending_up},
    {"label": "Bonus", "icon": Icons.card_giftcard},
    {"label": "Other", "icon": Icons.category},
  ];

  final List<Map<String, dynamic>> expenseCategories = [
    {"label": "Shopping", "icon": Icons.shopping_bag},
    {"label": "Food", "icon": Icons.fastfood},
    {"label": "Groceries", "icon": Icons.local_grocery_store},
    {"label": "Entertainment", "icon": Icons.mic},
    {"label": "Health", "icon": Icons.favorite},
  ];

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  Future<void> _saveToFirebase() async {
    if (_selectedSourceType != null &&
        _selectedCategory != null &&
        _selectedDate != null &&
        _amountController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('db-money-mab').add({
        'source': _selectedSourceType,
        'category': _selectedCategory,
        'amount': double.parse(_amountController.text),
        'notes': _noteController.text,
        'date': _selectedDate,
      });

      _showSuccessDialog();
    } else {
      _showErrorDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            const Text(
              "Data Berhasil Disimpan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); 
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()), 
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9575),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "OK",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            const Text(
              "Tolong isi semua data",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9575),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "OK",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          Container(
            height: 175,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF9575), Color(0xFFFFCFC0)], 
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      const Text(
                        "Add Source",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 30), 
                  Center(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(24, 0, 24, 32), 
                      padding: const EdgeInsets.symmetric(vertical: 27, horizontal: 27),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F1E6), 
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 5), 
                          _buildDropdownField(
                            "Jenis Sumber",
                            [
                              {"label": "Income", "icon": Icons.attach_money},
                              {"label": "Expense", "icon": Icons.money_off},
                            ],
                            _selectedSourceType,
                            "Sumber",
                            (value) => setState(() {
                              _selectedSourceType = value;
                              _selectedCategory = null; 
                            }),
                          ),
                          const SizedBox(height: 20),
                          _buildDropdownField(
                            "Jenis Kategori",
                            _selectedSourceType == "Income"
                                ? incomeCategories
                                : expenseCategories,
                            _selectedCategory,
                            "Category",
                            (value) => setState(() => _selectedCategory = value),
                            enabled: _selectedSourceType != null,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField("Nominal", "Amount", _amountController),
                          const SizedBox(height: 20),
                          _buildTextField("Pesan Tambahan", "Notes", _noteController),
                          const SizedBox(height: 20),
                          _buildDatePickerField(),
                          const SizedBox(height: 20),
                          Center(
                            child: SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: _saveToFirebase,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF9575), 
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Save",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16), 
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    List<Map<String, dynamic>> items,
    String? selectedValue,
    String hint,
    ValueChanged<String?> onChanged, {
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item["label"],
                  child: Row(
                    children: [
                      Icon(item["icon"], size: 20, color: Colors.black54),
                      const SizedBox(width: 8),
                      Text(item["label"]),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade200,
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          style: const TextStyle(fontSize: 14, color: Colors.black),
          iconEnabledColor: Colors.black54,
          iconDisabledColor: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Tanggal", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null && picked != _selectedDate) {
              setState(() {
                _selectedDate = picked;
              });
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: "Pilih Tanggal",
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
            child: Text(
              _selectedDate == null
                  ? "Pilih Tanggal"
                  : "${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}",
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
