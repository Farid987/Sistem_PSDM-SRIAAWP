import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoodDeedsWidget extends StatefulWidget {
  final String staffID;
  final String studentID;

  const GoodDeedsWidget(
      {required this.staffID, required this.studentID, Key? key})
      : super(key: key);

  @override
  _GoodDeedsWidgetState createState() => _GoodDeedsWidgetState();
}

class _GoodDeedsWidgetState extends State<GoodDeedsWidget> {
  late DateTime selectedDate;
  String? selectedName;
  String? selectedClass;
  String? selectedYear;
  String? selectedMerit;
  String? selectedMatrics;
  List<String> names = [];
  List<String> classes = [];
  List<String> years = [];
  List<String> matrics = [];
  List<String> merits = ['1', '2', '3', '4', '5'];

  final TextEditingController deedCategoryController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    deedCategoryController.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    fetchStudentsData();
  }

  Future<void> fetchStudentsData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Student').get();

    List<String> allNames = [];
    List<String> allClasses = [];
    List<String> allMatrics = [];
    List<String> allYears = [];

    snapshot.docs.forEach((doc) {
      final name = doc.get('Name') as String?;
      final className = doc.get('Class') as String?;
      final matric = doc.get('Matrics') as String?;
      final year = doc.get('Year') as String?;
      if (name != null) {
        allNames.add(name);
      }
      if (className != null) {
        allClasses.add(className);
      }
      if (matric != null) {
        allMatrics.add(matric);
      }
      if (year != null) {
        allYears.add(year);
      }
    });

    setState(() {
      names = allNames.toSet().toList();
      classes = allClasses.toSet().toList();
      matrics = allMatrics.toSet().toList();
      years = allYears.toSet().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Borang Amalan Baik',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Table(
                  // border: TableBorder.all(),
                  columnWidths: const <int, TableColumnWidth>{
                    // 0: IntrinsicColumnWidth(),
                    // 1: FlexColumnWidth(),
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        // Container(
                        //   height: 32,
                        //   color: Colors.green,
                        // ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nama:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                _buildNameDropdown(),
                              ],
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kelas:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                _buildClassDropdown(),
                              ],
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tahun:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                _buildYearDropdown(),
                              ],
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'No. Matriks:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                _buildMatricsDropdown(),
                              ],
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Merit:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                _buildMeritDropdown(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Row(
                //   children: [
                //     Container(
                //       width: 70,
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Name:',
                //             style: TextStyle(
                //               fontSize: 16,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.black,
                //             ),
                //           ),
                //           _buildNameDropdown(),
                //         ],
                //       ),
                //     ),
                //     SizedBox(width: 20),
                //     Container(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Class:',
                //             style: TextStyle(
                //               fontSize: 16,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.black,
                //             ),
                //           ),
                //           _buildClassDropdown(),
                //         ],
                //       ),
                //     ),
                //     SizedBox(width: 20),
                //     Container(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Year:',
                //             style: TextStyle(
                //               fontSize: 16,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.black,
                //             ),
                //           ),
                //           _buildYearDropdown(),
                //         ],
                //       ),
                //     ),
                //     SizedBox(width: 20),
                //     Container(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Matrics:',
                //             style: TextStyle(
                //               fontSize: 16,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.black,
                //             ),
                //           ),
                //           _buildMatricsDropdown(),
                //         ],
                //       ),
                //     ),
                //     SizedBox(width: 20),
                //     Container(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Merit:',
                //             style: TextStyle(
                //               fontSize: 16,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.black,
                //             ),
                //           ),
                //           _buildMeritDropdown(),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: 40),
                _buildTextField('Ulasan Amalan Baik',
                    hintText: 'Masukkan Ulasan',
                    controller: deedCategoryController),
                SizedBox(height: 40),
                _buildDateTimePicker(context),
                SizedBox(height: 40),
                _buildTextField('Komen',
                    hintText: 'Masukkan Komen',
                    maxLines: 4,
                    controller: commentController),
                SizedBox(height: 80),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _handleSubmit();
                    },
                    child: Text(
                      'Submit',
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
      ),
    );
  }

  Widget _buildNameDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedName,
        hint: Text('Pilih Nama'),
        onChanged: (String? value) {
          setState(() {
            selectedName = value;
            if (value != null) {
              int index = names.indexOf(value);
              if (index != -1 &&
                  index < classes.length &&
                  index < matrics.length &&
                  index < years.length) {
                selectedClass = classes[index];
                selectedMatrics = matrics[index];
                selectedYear = years[index];
              }
            }
          });
        },
        items: names.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(
              width: 80, // Adjust the width of the dropdown items if necessary
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildClassDropdown() {
    return DropdownButton<String>(
      value: selectedClass,
      hint: Text('Pilih Kelas'),
      onChanged: (String? value) async {
        setState(() {
          selectedClass = value;
          selectedName = null;
          selectedMatrics = null;
          selectedYear = null;
        });
        if (value != null) {
          await fetchNamesAndMatrics(value);
        }
      },
      items: classes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildYearDropdown() {
    return DropdownButton<String>(
      value: selectedYear,
      hint: Text('Pilih Tahun'),
      onChanged: (String? value) async {
        setState(() {
          selectedYear = value;
          selectedName = null;
          selectedClass = null;
          selectedMatrics = null;
        });
        if (value != null) {
          await fetchClassesAndMatrics(value);
        }
      },
      items: years.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildMatricsDropdown() {
    return DropdownButton<String>(
      value: selectedMatrics,
      hint: Text('Pilih No.Matrik'),
      onChanged: (String? value) {
        setState(() {
          selectedMatrics = value;
          fetchMatricsData(value!);
        });
      },
      items: matrics.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Future<void> fetchMatricsData(String matric) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Student')
        .where('Matrics', isEqualTo: matric)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      final name = doc.get('Name') as String?;
      final className = doc.get('Class') as String?;
      final year = doc.get('Year') as String?;

      setState(() {
        selectedName = name;
        selectedClass = className;
        selectedYear = year;
      });
    }
  }

  Future<void> fetchNamesAndMatrics(String selectedClass) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Student')
        .where('Class', isEqualTo: selectedClass)
        .get();

    List<String> allNames = [];
    List<String> allMatrics = [];

    snapshot.docs.forEach((doc) {
      final name = doc.get('Name') as String?;
      final matric = doc.get('Matrics') as String?;
      if (name != null) {
        allNames.add(name);
      }
      if (matric != null) {
        allMatrics.add(matric);
      }
    });

    setState(() {
      names = allNames;
      matrics = allMatrics;
    });
  }

  Future<void> fetchClassesAndMatrics(String selectedYear) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Student')
        .where('Year', isEqualTo: selectedYear)
        .get();

    List<String> allClasses = [];
    List<String> allMatrics = [];

    snapshot.docs.forEach((doc) {
      final className = doc.get('Class') as String?;
      final matric = doc.get('Matrics') as String?;
      if (className != null) {
        allClasses.add(className);
      }
      if (matric != null) {
        allMatrics.add(matric);
      }
    });

    setState(() {
      classes = allClasses;
      matrics = allMatrics;
    });
  }

  Widget _buildMeritDropdown() {
    return DropdownButton<String>(
      value: selectedMerit,
      hint: Text('Select Merit'),
      onChanged: (String? value) {
        setState(() {
          selectedMerit = value;
        });
      },
      items: merits.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(String label,
      {String? hintText,
      int maxLines = 1,
      required TextEditingController controller}) {
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
          maxLines: maxLines,
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

  Widget _buildDateTimePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pilih Tarikh',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
        SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != selectedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: Text(
                'Pilih Tarikh',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text('Tarikh: ${DateFormat('dd-MM-yyyy').format(selectedDate)}',
            style: TextStyle(fontSize: 16)),
      ],
    );
  }

  void _handleSubmit() async {
    String deedCategory = deedCategoryController.text.trim();
    String comment = commentController.text.trim();
    String className = selectedClass ?? "";
    String year = selectedYear ?? "";
    String matrics = selectedMatrics ?? "";
    String deedScore = selectedMerit ?? "";
    String name = selectedName ?? "";
    DateTime now = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(now);

    Map<String, dynamic> deedData = {
      'Matrics': matrics,
      'DeedCategory': deedCategory,
      'DeedScore': deedScore,
      'DateTime': timestamp,
      'Comment': comment,
      'Name': name,
      'Class': className,
      'Year': year, // Add Year field
      'StaffID': widget.staffID,
    };

    try {
      // Add to Deed_report collection
      await FirebaseFirestore.instance.collection('Deed_report').add(deedData);

      // Add to report_history subcollection
      await FirebaseFirestore.instance
          .collection('Notification')
          .doc(widget.staffID)
          .collection('report_history')
          .add(deedData);

      // Add to all_notification subcollection with complete data
      await FirebaseFirestore.instance
          .collection('Notification')
          .doc('notification')
          .collection('all_notification')
          .add({
        'content': 'New deed report submitted by ${widget.staffID}',
        'Datetime': timestamp,
        'Matrics': matrics,
        'StaffID': widget.staffID,
      });

      if (widget.studentID.isNotEmpty) {
        // Update Student collection with the new Matrics field
        await FirebaseFirestore.instance
            .collection('Student')
            .doc(widget.studentID)
            .update({'Matrics': matrics});
      }

      _showSuccessMessage();
      _resetFields();
    } catch (error) {
      print('Error submitting deed report: $error');
      _showErrorMessage(error.toString());
    }

    addNotification(
        'New deed report submitted by ${widget.staffID}', widget.studentID);
  }

  void addNotification(String content, String studentID) {
    print('Notification: $content for student ID: $studentID');
  }

  void _resetFields() {
    setState(() {
      selectedName = null;
      selectedClass = null;
      selectedYear = null;
      selectedMatrics = null;
      selectedMerit = null;
      deedCategoryController.clear();
      commentController.clear();
      selectedDate = DateTime.now();
    });
  }

  void _showSuccessMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: Text('Success'),
          content: Text('Submission Successful'),
        );
      },
    );
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: GoodDeedsWidget(
        staffID: 'staff123',
        studentID: '',
      ),
    ),
  ));
}
