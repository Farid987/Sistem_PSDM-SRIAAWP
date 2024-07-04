import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddStudentWidget extends StatefulWidget {
  @override
  _AddStudentWidgetState createState() => _AddStudentWidgetState();
}

class _AddStudentWidgetState extends State<AddStudentWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController matricsController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String _selectedClass = 'Pilih Kelas';
  String _selectedYear = 'Pilih Tahun';

  @override
  void dispose() {
    nameController.dispose();
    matricsController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: 1200,
        height: 600,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambah Pengguna (Pelajar)',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField('Nama',
                  hintText: 'Masukkan Nama', controller: nameController),
              SizedBox(height: 20),
              _buildTextField('No.Matriks',
                  hintText: 'Masukkan No.Matriks',
                  controller: matricsController),
              SizedBox(height: 20),
              Text(
                "Tahun",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              _buildYearDropdown(),
              SizedBox(height: 20),
              Text(
                "Kelas",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              _buildClassDropdown(),
              SizedBox(height: 20),
              _buildTextField('E-mel',
                  hintText: 'Masukkan E-mel', controller: emailController),
              SizedBox(height: 20),
              _buildTextField('Kata laluan',
                  hintText: 'Masukkan kata laluan',
                  controller: passwordController),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  child: Text(
                    'Hantar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {String? hintText, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String value,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue.shade500,
            width: 2,
          ),
        ),
      ),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      value: value,
    );
  }

  Future<List<String>> _fetchClassOptions(String selectedYear) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Class')
        .where('Year', isEqualTo: selectedYear)
        .get();

    List<String> classOptions = [];
    querySnapshot.docs.forEach((doc) {
      String classes = doc['Class'] as String;
      classOptions.addAll(classes.split(','));
    });
    classOptions.insert(0, 'Pilih Kelas'); // Add default option
    return classOptions;
  }

  Widget _buildClassDropdown() {
    return FutureBuilder<List<String>>(
      future: _fetchClassOptions(_selectedYear),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<String>? classOptions = snapshot.data;

          return _buildDropdown(
            hint: 'Pilih Kelas',
            items: classOptions!,
            onChanged: (String? value) {
              setState(() {
                _selectedClass = value!;
              });
            },
            value: _selectedClass,
          );
        }
      },
    );
  }

  Widget _buildYearDropdown() {
    return _buildDropdown(
      hint: 'Pilih Tahun',
      items: [
        'Pilih Tahun',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
      ],
      onChanged: (String? value) {
        setState(() {
          _selectedYear = value!;
        });
      },
      value: _selectedYear,
    );
  }

  Future<void> _handleSubmit() async {
    String name = nameController.text.trim();
    String matrics = matricsController.text.trim();
    String password = passwordController.text.trim();
    String email = emailController.text.trim();

    if (name.isEmpty ||
        matrics.isEmpty ||
        password.isEmpty ||
        email.isEmpty ||
        _selectedClass == 'Pilih Kelas' ||
        _selectedYear == 'Pilih Tahun') {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sila lengkap maklumat di atas.'),
      ));
      return;
    }

    try {
      // Create a new user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get the user's UID
      String uid = userCredential.user!.uid;

      // Add student data to Firestore
      await FirebaseFirestore.instance.collection('Student').doc(uid).set({
        'Name': name,
        'Matrics': matrics,
        'Class': _selectedClass,
        'Year': _selectedYear,
      });

      // Add auth data to Firestore
      await FirebaseFirestore.instance
          .collection('Auth_parent')
          .doc(email)
          .set({
        'Email': email,
        'Password': password,
        'Student_name': name,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Pengguna pelajar berjaya dicipta!'),
      ));

      // Clear the text fields
      nameController.clear();
      matricsController.clear();
      passwordController.clear();
      emailController.clear();
      setState(() {
        _selectedClass = 'Pilih Kelas';
        _selectedYear = 'Pilih Tahun';
      });
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }
}
