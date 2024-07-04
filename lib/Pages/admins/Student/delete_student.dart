import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeleteStudentWidget extends StatefulWidget {
  @override
  _DeleteStudentWidgetState createState() => _DeleteStudentWidgetState();
}

class _DeleteStudentWidgetState extends State<DeleteStudentWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  String _selectedYear = 'Pilih Tahun';
  String _selectedClass = 'Pilih Kelas';
  String _selectedName =
      'Pilih Nama'; // Add _selectedName to store the selected student name
  List<String> _classOptions = ['Pilih Kelas'];

  @override
  void dispose() {
    nameController.dispose();
    classController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Padam Pengguna (Pelajar)',
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
            SizedBox(height: 8),
            _buildNameDropdown(),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: _handleSubmit,
                child: Text(
                  'Padam',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 43, 43),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nama',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        FutureBuilder<List<String>>(
          future: _fetchStudentNamesForClass(_selectedClass),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<String>? studentNames = snapshot.data;
              // Add debug print to check fetched student names
              print('Fetched student names: $studentNames');

              return DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                value:
                    studentNames != null && studentNames.contains(_selectedName)
                        ? _selectedName
                        : null,
                onChanged: (String? value) {
                  setState(() {
                    _selectedName = value!;
                    // Add debug print to check selected name
                    print('Selected name: $_selectedName');
                  });
                },
                items: _buildStudentDropdownItems(studentNames),
              );
            }
          },
        ),
      ],
    );
  }

  Future<List<String>> _fetchStudentNamesForClass(String className) async {
    List<String> studentNames = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Student')
          .where('Class', isEqualTo: className)
          .get();

      querySnapshot.docs.forEach((doc) {
        studentNames.add(doc['Name']);
      });
    } catch (e) {
      print('Error fetching student names: $e');
    }

    return studentNames;
  }

  List<DropdownMenuItem<String>> _buildStudentDropdownItems(
      List<String>? studentNames) {
    List<DropdownMenuItem<String>> items = [];

    if (studentNames == null || studentNames.isEmpty) {
      items.add(
        DropdownMenuItem(
          value: 'No students found',
          child: Text('No students found'),
        ),
      );
    } else {
      items.add(
        DropdownMenuItem(
          value: 'Pilih Nama',
          child: Text('Pilih Nama'),
        ),
      );

      for (String studentName in studentNames) {
        items.add(
          DropdownMenuItem(
            value: studentName,
            child: Text(studentName),
          ),
        );
      }
    }

    return items;
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

  Widget _buildClassDropdown() {
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
      onChanged: (String? value) {
        setState(() {
          _selectedClass = value ?? 'Pilih Kelas';
          // Fetch student names for the selected class
          _selectedName = 'Pilih Nama';
        });
      },
      items: _classOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      value: _selectedClass,
    );
  }

  Widget _buildYearDropdown() {
    return FutureBuilder<List<String>>(
      future: _fetchYearOptions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<String>? yearOptions = snapshot.data;

          return _buildDropdown(
            hint: 'Pilih Tahun',
            items: yearOptions!,
            onChanged: (String? value) {
              setState(() {
                _selectedYear = value ?? 'Pilih Tahun';
                _fetchClassesForYear(_selectedYear);
              });
            },
            value: _selectedYear,
          );
        }
      },
    );
  }

  Future<List<String>> _fetchYearOptions() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Class').get();
    List<String> yearOptions = querySnapshot.docs.map((doc) => doc.id).toList();
    yearOptions.insert(0, 'Pilih Tahun');
    return yearOptions;
  }

  Future<void> _fetchClassesForYear(String year) async {
    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('Class').doc(year).get();

    if (!snapshot.exists) {
      return;
    }

    final String classString = snapshot['Class'];

    if (classString.isEmpty) {
      return;
    }

    final List<String> classOptions = classString.split(',');
    setState(() {
      _classOptions = ['Pilih Kelas', ...classOptions];
      _selectedClass = 'Pilih Kelas';
    });
  }

  Future<void> _handleSubmit() async {
    String name = _selectedName.trim();
    String className = _selectedClass.trim();
    String year = _selectedYear.trim();

    // Debug statements to check values before validation
    print('Text entered: ${nameController.text}');
    print('Selected Year: $_selectedYear');
    print('Selected Class: $_selectedClass');
    print('Name: $_selectedName');

    if (name.isEmpty || className == 'Pilih Kelas' || year == 'Pilih Tahun') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sila isi semua maklumat.'),
      ));
      return;
    }

    try {
      QuerySnapshot studentSnapshot = await FirebaseFirestore.instance
          .collection('Student')
          .where('Name', isEqualTo: name)
          .where('Class', isEqualTo: className)
          .where('Year', isEqualTo: year)
          .get();

      if (studentSnapshot.docs.isNotEmpty) {
        for (var doc in studentSnapshot.docs) {
          await doc.reference.delete();
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Pengguna ($name) berjaya dipadam!'),
        ));

        nameController.clear();
        setState(() {
          _selectedClass = 'Pilih Kelas';
          _selectedYear = 'Pilih Tahun';
          _selectedName = 'Pilih Nama';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Tiada nama pengguna dalam sistem.'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: DeleteStudentWidget(),
  ));
}