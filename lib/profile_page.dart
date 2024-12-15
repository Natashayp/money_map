import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); 

  String? _selectedLanguage;
  String? _selectedCurrency;
  bool _isEditing = false;

  final List<String> languages = ["Indonesia", "English"];
  final List<String> currencies = ["Rupiah", "Dollar"];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() async {
    DocumentSnapshot profileData = await FirebaseFirestore.instance.collection('profil').doc('user_profile').get();
    if (profileData.exists) {
      setState(() {
        _nameController.text = profileData['name'] ?? '';
        _phoneController.text = profileData['phone'] ?? '';
        _emailController.text = profileData['email'] ?? '';
        _passwordController.text = profileData['password'] ?? ''; 
        _selectedLanguage = profileData['language'] ?? '';
        _selectedCurrency = profileData['currency'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context, '/home'),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: _deleteAccount, 
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Profile Picture Section
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.black54,
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField("Nama", _nameController),
            const SizedBox(height: 16),
            _buildTextField("Nomor Telepon", _phoneController),
            const SizedBox(height: 16),
            _buildTextField("Alamat Email", _emailController),
            const SizedBox(height: 16),
            _buildTextField("Password", _passwordController, obscureText: true), 
            const SizedBox(height: 16),
            _buildDropdownField("Bahasa", languages, _selectedLanguage),
            const SizedBox(height: 16),
            _buildDropdownField("Mata Uang", currencies, _selectedCurrency),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_isEditing) {
                    _saveProfile();
                  }
                  _isEditing = !_isEditing;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9575),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _isEditing ? "Simpan" : "Edit",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            enabled: _isEditing, 
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: "", 
              filled: true,
              fillColor: const Color(0xFFFFE8E1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String? selectedValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedValue,
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: _isEditing ? (value) => setState(() {
              if (label == "Bahasa") {
                _selectedLanguage = value;
              } else if (label == "Mata Uang") {
                _selectedCurrency = value;
              }
            }) : null, 
            decoration: InputDecoration(
              hintText: "Pilih $label",
              filled: true,
              fillColor: const Color(0xFFFFE8E1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveProfile() async {
    FirebaseFirestore.instance.collection('profil').doc('user_profile').set({
      'name': _nameController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'password': _passwordController.text, 
      'language': _selectedLanguage,
      'currency': _selectedCurrency,
    });

    setState(() {
    });

    _showSaveDialog(context);
  }

  void _deleteAccount() async {
    await FirebaseFirestore.instance.collection('profil').doc('user_profile').delete();
    _showDeleteDialog(context);
  }

  void _showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              size: 64,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            const Text(
              "Perubahan Profil Berhasil Disimpan",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text("OK"),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.delete_forever,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              "Akun Berhasil Dihapus",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text("OK"),
            ),
          ],
        ),
      ),
    );
  }
}
