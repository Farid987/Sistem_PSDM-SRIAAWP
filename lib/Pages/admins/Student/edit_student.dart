import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditStudentWidget extends StatefulWidget {
  @override
  _EditStudentWidgetState createState() => _EditStudentWidgetState();
}

class _EditStudentWidgetState extends State<EditStudentWidget> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String _selectedClass = 'Pilih Kelas';
  String _selectedYear = 'Pilih Tahun';
  String _selectedName = 'Pilih Nama';
  List<String> _classOptions = ['Pilih Kelas'];
  List<String> _yearOptions = ['Pilih Tahun'];
  List<String> _studentNames = ['Pilih Nama'];

  @override
  void initState() {
    super.initState();
    _fetchYearOptions();
  }

  Future<void> _fetchYearOptions() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Class').get();
    final List<String> yearOptions =
        snapshot.docs.map((doc) => doc.id).toList();
    setState(() {
      _yearOptions = ['Pilih Tahun', ...yearOptions];
    });
  }

  Future<void> _fetchClassesForYear(String year) async {
    if (year == 'Pilih Tahun') return;

    print('Fetching classes for year: $year');

    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('Class').doc(year).get();
    final List<String> classOptions =
        (snapshot.data() as Map<String, dynamic>)['Class'].split(',');
    setState(() {
      _classOptions = ['Pilih Kelas', ...classOptions];
      _selectedClass = 'Pilih Kelas';
      _studentNames = ['Pilih Nama', ...classOptions];
      _selectedName = 'Pilih Nama';
    });

    print('Classes fetched: $classOptions');
  }

  Future<void> _fetchStudentsForClass(String year, String className) async {
    if (className == 'Pilih Kelas' || year == 'Pilih Tahun') return;

    print('Fetching students for year: $year, class: $className');

    try {
      final QuerySnapshot studentSnapshot = await FirebaseFirestore.instance
          .collection('Student')
          .where('Year', isEqualTo: year)
          .where('Class', isEqualTo: className)
          .get();

      print('Number of students fetched: ${studentSnapshot.docs.length}');

      studentSnapshot.docs.forEach((doc) {
        print('Document data: ${doc.data()}');
      });

      final List<String> studentNames =
          studentSnapshot.docs.map((doc) => doc['Name'] as String).toList();

      print('Fetched Student Names: $studentNames');

      setState(() {
        _studentNames = ['Pilih Nama', ...studentNames];
        _selectedName = 'Pilih Nama';
      });
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  Future<void> _fetchAuthDataForSelectedStudent(String studentName) async {
    if (studentName == 'Pilih Nama') return;

    print('Fetching auth data for student: $studentName');

    try {
      final QuerySnapshot authSnapshot = await FirebaseFirestore.instance
          .collection('Auth_parent')
          .where('Student_name', isEqualTo: studentName)
          .limit(1)
          .get();

      if (authSnapshot.docs.isEmpty) {
        print('No auth data found for student: $studentName');
        return;
      }

      final authDoc = authSnapshot.docs.first;
      final String email = authDoc['Email'];
      final String password = authDoc['Password'];

      print('Fetched Email: $email');
      print('Fetched Password: $password');

      setState(() {
        emailController.text = email;
        passwordController.text = password;
      });
    } catch (e) {
      print('Error fetching auth data: $e');
    }
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
                'Ubah Suai (Pelajar)',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
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
              Text(
                "Nama",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              _buildNameDropdown(),
              SizedBox(height: 20),
              _buildTextField('E-mel',
                  hintText: 'Masukkan E-mel', controller: emailController),
              SizedBox(height: 20),
              _buildTextField('Kata laluan',
                  hintText: 'Masukkan Kata laluan',
                  controller: passwordController),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  child: Text(
                    'Ubah Suai',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 202, 87),
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

  Widget _buildYearDropdown() {
    return _buildDropdown(
      hint: 'Pilih Tahun',
      items: _yearOptions,
      onChanged: (String? value) {
        setState(() {
          _selectedYear = value!;
          _fetchClassesForYear(_selectedYear);
        });
      },
      value: _selectedYear,
    );
  }

  Widget _buildClassDropdown() {
    return _buildDropdown(
      hint: 'Pilih Kelas',
      items: _classOptions,
      onChanged: (String? value) {
        setState(() {
          _selectedClass = value!;
          _fetchStudentsForClass(_selectedYear, _selectedClass);
        });
      },
      value: _selectedClass,
    );
  }

  Widget _buildNameDropdown() {
    return _buildDropdown(
      hint: 'Pilih Nama',
      items: _studentNames,
      onChanged: (String? value) {
        setState(() {
          _selectedName = value!;
          _fetchAuthDataForSelectedStudent(_selectedName);
        });
      },
      value: _selectedName,
    );
  }

  Future<void> _handleSubmit() async {
    String password = passwordController.text.trim();
    String email = emailController.text.trim();

    // Validate input fields and selected values
    if (_selectedClass == 'Pilih Kelas' ||
        _selectedYear == 'Pilih Tahun' ||
        _selectedName == 'Pilih Nama' ||
        password.isEmpty ||
        email.isEmpty) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sila isi semua maklumat.'),
        ),
      );
      return;
    }

    try {
      // Register user with email and password for authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Access the authenticated user
      User? user = userCredential.user;

      // Fetch auth data in Firestore using the student name
      final QuerySnapshot authSnapshot = await FirebaseFirestore.instance
          .collection('Auth_parent')
          .where('Student_Name', isEqualTo: _selectedName)
          .limit(1)
          .get();

      String authDocId;

      if (!authSnapshot.docs.isEmpty) {
        authDocId = authSnapshot.docs.first.id;

        // Delete the existing document (if desired)
        await FirebaseFirestore.instance
            .collection('Auth_parent')
            .doc(authDocId)
            .delete();
      }

      // Create a new document with the specified structure
      await FirebaseFirestore.instance
          .collection('Auth_parent')
          .doc(email) // Assuming email is unique and used as document ID
          .set({
        'Email': email,
        'Password': password,
        'Student_Name': _selectedName,
        // Optionally, store additional user data if needed
        'UserId': user?.uid, // Store the user's ID in Firestore
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Student data updated successfully!'),
        ),
      );

      // Clear the text fields and reset selected values
      passwordController.clear();
      emailController.clear();
      setState(() {
        _selectedClass = 'Pilih Kelas';
        _selectedYear = 'Pilih Tahun';
        _selectedName = 'Pilih Nama';
      });
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: EditStudentWidget(),
  ));
}
