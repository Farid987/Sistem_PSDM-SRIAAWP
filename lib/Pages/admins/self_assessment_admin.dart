import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Approve_assessment.dart';
import 'Rejected_assessment.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: SelfassessmentWidgets(),
    ),
  ));
}

class EvaluationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getAssessmentData(String staffID) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('Teacher_evaluation')
          .doc('Submission')
          .collection('all_submission')
          .doc(staffID)
          .collection('history')
          .orderBy('SubmissionTime', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var latestDocument = querySnapshot.docs.first;
        Map<String, dynamic>? data =
            latestDocument.data() as Map<String, dynamic>?;

        if (data != null) {
          print('Assessment Data for StaffID $staffID: $data');
          return data;
        } else {
          print('No assessment data found for StaffID $staffID');
          return null;
        }
      } else {
        print('No documents found for StaffID $staffID');
        return null;
      }
    } catch (e) {
      print("Error fetching assessment data: $e");
      return null;
    }
  }

  Future<List<String>> getDropdownOptions() async {
    List<String> options = [];
    try {
      QuerySnapshot snapshot = await _db.collection('Auth_teacher').get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('StaffID')) {
          options.add(data['StaffID']);
        }
      }
    } catch (e) {
      print("Error fetching dropdown options: $e");
    }
    return options;
  }

  Future<void> updateAssessmentStatus(String staffID, String status) async {
    try {
      DocumentSnapshot documentSnapshot = await _db
          .collection('Teacher_evaluation')
          .doc('Submission')
          .collection('all_submission')
          .doc(staffID)
          .collection('history')
          .orderBy('SubmissionTime', descending: true)
          .limit(1)
          .get()
          .then((querySnapshot) => querySnapshot.docs.first);

      if (documentSnapshot.exists) {
        await documentSnapshot.reference.update({'Status': status});
        print('Assessment status for StaffID $staffID updated to $status');
      }
    } catch (e) {
      print("Error updating assessment status: $e");
    }
  }
}

class SelfassessmentWidgets extends StatefulWidget {
  @override
  _SelfassessmentWidgetsState createState() => _SelfassessmentWidgetsState();
}

class _SelfassessmentWidgetsState extends State<SelfassessmentWidgets> {
  String selectedOption = '';
  final EvaluationService _evaluationService = EvaluationService();
  final RejectionService _rejectionService = RejectionService();
  final ApprovalService _approvalService = ApprovalService();
  Map<String, dynamic>? assessmentData;

  List<TextEditingController> markahControllers =
      List.generate(14, (_) => TextEditingController());

  @override
  void dispose() {
    for (var controller in markahControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool allFieldsFilled() {
    for (var controller in markahControllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  void resetForm() {
    setState(() {
      selectedOption = '';
      assessmentData = null;
      for (var controller in markahControllers) {
        controller.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: 1200,
        height: 700,
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
              Row(
                children: [
                  Text(
                    'Penilaian Prestasi Tahunan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 20),
                  FutureBuilder<List<String>>(
                    future: _evaluationService.getDropdownOptions(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No options available');
                      } else {
                        return DropdownButton<String>(
                          hint: Text('StaffID'),
                          value: selectedOption.isEmpty
                              ? snapshot.data!.first
                              : selectedOption,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedOption = newValue!;
                              _evaluationService
                                  .getAssessmentData(newValue)
                                  .then((data) {
                                setState(() {
                                  assessmentData =
                                      data as Map<String, dynamic>?;
                                });
                              });
                            });
                          },
                          items: snapshot.data!
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Markah Keberhasilan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 40),
              assessmentData != null
                  ? Column(
                      children: [
                        buildExpansionTile(
                          'PDP (40%)',
                          [
                            buildDataTile(
                                'Mencapai sekurang-kurangnya 85% penghantaran PDPC.',
                                [
                                  buildDataRow('Comment 1',
                                      assessmentData?['PDP']?['Comment1']),
                                  buildDataRow(
                                      'Markah 1',
                                      assessmentData?['PDP']?['Markah1'],
                                      markahControllers[0]),
                                ]),
                            buildDataTile(
                                'Menyediakan sekurang-kurangnya satu Bahan Bantu Mengajar BBM dalam setahun.',
                                [
                                  buildDataRow('Comment 2',
                                      assessmentData?['PDP']?['Comment2']),
                                  buildDataRow(
                                      'Markah 2',
                                      assessmentData?['PDP']?['Markah2'],
                                      markahControllers[1]),
                                ]),
                            buildDataTile(
                                'Mempelajari sekurang-kurangnya satu kemahiran baru dan dapat mengamalkan di dalam PDPC.',
                                [
                                  buildDataRow('Comment 3',
                                      assessmentData?['PDP']?['Comment3']),
                                  buildDataRow(
                                      'Markah 3',
                                      assessmentData?['PDP']?['Markah3'],
                                      markahControllers[2]),
                                ]),
                          ],
                        ),
                        buildExpansionTile(
                          'PROGRAM SEKOLAH (30%)',
                          [
                            buildDataTile(
                                'Memberi sumbangan yang signifikan dalam program sekolah',
                                [
                                  buildDataRow(
                                      'Markah 4',
                                      assessmentData?['ProgramSekolah']
                                          ?['Markah4'],
                                      markahControllers[3]),
                                ]),
                            buildDataTile(
                                'Melaksanakan aktiviti ko-kurikulum dengan aktif',
                                [
                                  buildDataRow(
                                      'Markah 5',
                                      assessmentData?['ProgramSekolah']
                                          ?['Markah5'],
                                      markahControllers[4]),
                                ]),
                            buildDataTile(
                                'Mempromosikan budaya sihat di sekolah', [
                              buildDataRow(
                                  'Markah 6',
                                  assessmentData?['ProgramSekolah']?['Markah6'],
                                  markahControllers[5]),
                            ]),
                            buildDataTile('Menganjurkan program motivasi', [
                              buildDataRow(
                                  'Markah 7',
                                  assessmentData?['ProgramSekolah']?['Markah7'],
                                  markahControllers[6]),
                            ]),
                            buildDataTile(
                                'Mengelola pertandingan antara kelas', [
                              buildDataRow(
                                  'Markah 8',
                                  assessmentData?['ProgramSekolah']?['Markah8'],
                                  markahControllers[7]),
                            ]),
                          ],
                        ),
                        buildExpansionTile(
                          'TARBIYYAH (15%)',
                          [
                            buildDataTile(
                                'Menghadiri sekurang-kurangnya 80% pertemuan tarbiyah',
                                [
                                  buildDataRow(
                                      'Markah 9',
                                      assessmentData?['Tarbiyyah']?['Markah9'],
                                      markahControllers[8]),
                                ]),
                            buildDataTile(
                                'Memberi sumbangan dalam program tarbiyah sekolah',
                                [
                                  buildDataRow(
                                      'Markah 10',
                                      assessmentData?['Tarbiyyah']?['Markah10'],
                                      markahControllers[9]),
                                ]),
                          ],
                        ),
                        buildExpansionTile(
                          'PENINGKATAN DIRI (10%)',
                          [
                            buildDataTile(
                                'Menyertai sekurang-kurangnya satu kursus peningkatan diri dalam setahun',
                                [
                                  buildDataRow(
                                      'Markah 11',
                                      assessmentData?['PeningkatanDiri']
                                          ?['Markah11'],
                                      markahControllers[10]),
                                ]),
                            buildDataTile(
                                'Membaca sekurang-kurangnya satu buku peningkatan diri dalam setahun',
                                [
                                  buildDataRow(
                                      'Markah 12',
                                      assessmentData?['PeningkatanDiri']
                                          ?['Markah12'],
                                      markahControllers[11]),
                                ]),
                          ],
                        ),
                        buildExpansionTile(
                          'PENGLIBATAN LUAR (5%)',
                          [
                            buildDataTile(
                                'Mengambil bahagian dalam aktiviti luar sekolah',
                                [
                                  buildDataRow(
                                      'Markah 13',
                                      assessmentData?['PenglibatanLuar']
                                          ?['Markah13'],
                                      markahControllers[12]),
                                ]),
                            buildDataTile('Memberi sumbangan kepada komuniti', [
                              buildDataRow(
                                  'Markah 14',
                                  assessmentData?['PenglibatanLuar']
                                      ?['Markah14'],
                                  markahControllers[13]),
                            ]),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: allFieldsFilled()
                                  ? () {
                                      List<int> inputMarks = markahControllers
                                          .map((controller) =>
                                              int.tryParse(controller.text) ??
                                              0)
                                          .toList();

                                      _approvalService.handleApprove(
                                        selectedOption,
                                        assessmentData,
                                        inputMarks,
                                      );

                                      resetForm(); // Reset form after approval
                                    }
                                  : null,
                              child: Text(
                                'Lulus',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _rejectionService.handleReject(
                                    selectedOption, assessmentData);

                                resetForm(); // Reset form after rejection
                              },
                              child: Text(
                                'Tolak',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Center(
                      child: Text('Select a StaffID to view assessment data'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  ExpansionTile buildExpansionTile(String title, List<Widget> children) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: children,
    );
  }

  Widget buildDataTile(String title, List<Widget> children) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.blue,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget buildDataRow(String title, String? value,
      [TextEditingController? controller]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          controller == null
              ? Text(value ?? '')
              : SizedBox(
                  width: 100,
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^([1-9]|[1-9][0-9]|100)$')),
                    ],
                    decoration: InputDecoration(
                      hintText: value ?? '1 -100',
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
