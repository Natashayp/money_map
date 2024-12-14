import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import 'home_page.dart';

class AddSourceIncomePage extends StatefulWidget {
  AddSourceIncomePage({super.key});

  @override
  _AddSourceIncomePageState createState() => _AddSourceIncomePageState();
}

class _AddSourceIncomePageState extends State<AddSourceIncomePage> {
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.shopping_bag, 'name': 'Shopping'},
    {'icon': Icons.fastfood, 'name': 'Food'},
    {'icon': Icons.shopping_cart, 'name': 'Groceries'},
    {'icon': Icons.music_note, 'name': 'Entertainment'},
    {'icon': Icons.health_and_safety, 'name': 'Health'},
  ];

  DateTime? _selectedDate;
  String? selectedCategory;
  String? selectedSourceType;
  TextEditingController amountController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Add Source Income",
          style: TextStyle(color: Colors.white, fontFamily: 'Inter'),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(249, 241, 230, 1),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSourceTypeDropdown(),
            SizedBox(height: 20),
            _buildDropdownField("Jenis Kategori"),
            SizedBox(height: 20),
            _buildInputField("Nominal", amountController),
            SizedBox(height: 20),
            _buildInputField("Pesan Tambahan", notesController),
            SizedBox(height: 20),
            _buildDatePickerField(context),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _saveToFirebase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Jenis Sumber",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          items: [
            DropdownMenuItem(value: "Income", child: Text("Income")),
            DropdownMenuItem(value: "Expense", child: Text("Expense")),
          ],
          onChanged: (value) {
            setState(() {
              selectedSourceType = value;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
            hintText: "Pilih Jenis Sumber",
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5),
        DropdownButtonFormField<Map<String, dynamic>>(
          items: categories
              .map(
                (category) => DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Icon(category['icon']),
                      SizedBox(width: 10),
                      Text(category['name'], style: TextStyle(fontFamily: 'Inter')),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedCategory = value?['name'];
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
            hintText: "Pilih Kategori",
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
            hintText: "Masukkan $label",
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tanggal Input",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              setState(() {
                _selectedDate = pickedDate;
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              _selectedDate != null
                  ? "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}"
                  : "Pilih Tanggal",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.normal,
                color: _selectedDate != null ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveToFirebase() async {
    if (selectedSourceType != null &&
        selectedCategory != null &&
        amountController.text.isNotEmpty &&
        notesController.text.isNotEmpty &&
        _selectedDate != null) {
      await FirebaseFirestore.instance.collection('db-money-mab').add({
        'source': selectedSourceType,
        'category': selectedCategory,
        'amount': double.parse(amountController.text),
        'notes': notesController.text,
        'date': _selectedDate,
      });

      _showDialog("Data Saved Successfully", Colors.green);
    } else {
      _showDialog("Please fill all fields", Colors.red);
    }
  }

  void _showDialog(String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info, color: color, size: 50),
              SizedBox(height: 10),
              Text(message),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
                );
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
