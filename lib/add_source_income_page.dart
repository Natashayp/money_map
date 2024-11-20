import 'package:flutter/material.dart';

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

  DateTime? _selectedDate; // Variabel untuk menyimpan tanggal yang dipilih

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
            _buildDropdownField("Jenis Kategori", "Category"),
            SizedBox(height: 20),
            _buildInputField("Nominal", "Amount"),
            SizedBox(height: 20),
            _buildInputField("Pesan Tambahan", "Notes"),
            SizedBox(height: 20),
            _buildDatePickerField(context),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showConfirmationDialog(context);
                },
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

  Widget _buildDropdownField(String label, String placeholder) {
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
          onChanged: (value) {},
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
            hintText: placeholder,
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

  Widget _buildInputField(String label, String placeholder) {
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
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
            hintText: placeholder,
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
            // Tampilkan date picker
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

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 16),
              Text(
                "Pengeluaran Berhasil Disimpan",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context); // Menutup dialog
                },
                child: Text(
                  "OK",
                  style: TextStyle(fontFamily: 'Inter', color: Colors.orange),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}