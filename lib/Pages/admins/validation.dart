import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Teacher/Approve&Reject/Reject.dart';

CollectionReference authTeachers =
    FirebaseFirestore.instance.collection('Auth_teacher');

void main() {
  runApp(MaterialApp(
    home: ValidationWidget(),
  ));
}

class ValidationWidget extends StatefulWidget {
  @override
  _ValidationWidgetState createState() => _ValidationWidgetState();
}

class _ValidationWidgetState extends State<ValidationWidget> {
  CollectionReference notifications = FirebaseFirestore.instance
      .collection('Notification')
      .doc('notification')
      .collection('all_notification');
  CollectionReference deedsReport =
      FirebaseFirestore.instance.collection('Deed_report');
  CollectionReference authTeachers =
      FirebaseFirestore.instance.collection('Auth_teacher');

  Map<String, bool> isOpenedMap = {};
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _loadOpenedDialogs();
  }

  Future<void> _loadOpenedDialogs() async {
    if (prefs != null) {
      Map<String, bool>? openedDialogs =
          prefs!.getBool('openedDialogs') as Map<String, bool>?;
      if (openedDialogs != null) {
        setState(() {
          isOpenedMap = openedDialogs;
        });
      }
    }
  }

  Future<void> _saveOpenedDialog(String dialogId) async {
    if (prefs != null) {
      await prefs!.setBool('openedDialogs.$dialogId', true);
      setState(() {
        isOpenedMap[dialogId] = true;
      });
    }
  }

  bool isNotificationShown = false; // Flag to track notification state

  Future<void> _approveReportDetails(Map<String, dynamic> reportDetails,
      DocumentReference reportDocRef) async {
    try {
      // Get a reference to the Approved_report collection
      CollectionReference approvedReportCollection =
          FirebaseFirestore.instance.collection('Approved_report');

      // Generate a random document ID
      String randomDocumentId = approvedReportCollection.doc().id;

      // Create a reference to the new document in Approved_report collection
      DocumentReference newDocumentRef =
          approvedReportCollection.doc(randomDocumentId);

      // Store the report details in the new document in Approved_report collection
      await newDocumentRef.set({
        'Name': reportDetails['Name'],
        'Matrics': reportDetails['Matrics'],
        'DeedCategory': reportDetails['DeedCategory'],
        'DeedScore': reportDetails['DeedScore'],
        'Comment': reportDetails['Comment'],
        'Class': reportDetails['Class'],
      });

      // Get a reference to the Leaderboard collection
      CollectionReference leaderboardCollection =
          FirebaseFirestore.instance.collection('Leaderboard');

      // Parse DeedScore as an integer
      int? newDeedScore = int.tryParse(reportDetails['DeedScore']);

      if (newDeedScore == null) {
        throw Exception('DeedScore must be a valid integer');
      }

      // Update or add the DeedScore in the Leaderboard collection
      var data = {
        'Name': reportDetails['Name'],
        'Matrics': reportDetails['Matrics'],
        'Class': reportDetails['Class'],
        'DeedScore': FieldValue.increment(newDeedScore),
      };
      await leaderboardCollection
          .doc(reportDetails['Name'])
          .set(data, SetOptions(merge: true));

      // Delete the document from the Deed_report collection
      await reportDocRef.delete();

      print(
          'Deed report approved, stored successfully, and original report deleted!');
    } catch (e) {
      print('Error approving report: $e');
      // Handle error as needed
    }
  }

  Future<void> _approveAllReports(
      List<DocumentSnapshot> notificationDocs) async {
    for (DocumentSnapshot notificationDoc in notificationDocs) {
      Map<String, dynamic> notificationData =
          notificationDoc.data() as Map<String, dynamic>;

      // Check if the "Datetime" field exists and is of type Timestamp
      if (!notificationData.containsKey('Datetime') ||
          notificationData['Datetime'] is! Timestamp) {
        print(
            'Missing or invalid Datetime field for document ID: ${notificationDoc.id}');
        continue;
      }

      Timestamp timestamp = notificationData['Datetime'];
      String staffID = notificationData['StaffID'];

      String teacherName = await fetchTeacherName(staffID);

      if (teacherName.isEmpty) {
        print('Teacher not found for StaffID: $staffID');
        continue;
      }

      Map<String, dynamic> reportDetails =
          await fetchReportDetails(staffID, timestamp);

      if (reportDetails.isEmpty) {
        print(
            'No report details found for $teacherName at timestamp ${timestamp.toDate()}');
        continue;
      }

      await _approveReportDetails(reportDetails, notificationDoc.reference);
      setState(() {
        isOpenedMap['${notificationDoc.id}'] = true;
      });
      await _saveOpenedDialog(notificationDoc.id);
    }

    // Show a snackbar to indicate success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All fetched reports approved successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<String> fetchTeacherName(String staffID) async {
    print('Fetching teacher name for StaffID: $staffID');
    QuerySnapshot teacherSnapshot =
        await authTeachers.where('StaffID', isEqualTo: staffID).get();

    if (teacherSnapshot.docs.isEmpty) {
      print('Teacher with StaffID $staffID not found');
      return '';
    }

    DocumentSnapshot teacherDoc = teacherSnapshot.docs.first;
    String teacherName = teacherDoc['Name'];
    print('Teacher name for StaffID $staffID: $teacherName');
    return teacherName;
  }

  Future<Map<String, dynamic>> fetchReportDetails(
      String staffID, Timestamp timestamp) async {
    try {
      print(
          'Fetching report details for StaffID: $staffID at ${timestamp.toDate()}');
      QuerySnapshot reportSnapshot = await FirebaseFirestore.instance
          .collection('Deed_report')
          .where('StaffID', isEqualTo: staffID)
          .where('DateTime', isEqualTo: timestamp)
          .get();

      print('QuerySnapshot size: ${reportSnapshot.size}');
      if (reportSnapshot.docs.isNotEmpty) {
        DocumentSnapshot reportDoc = reportSnapshot.docs.first;
        Map<String, dynamic> reportData =
            reportDoc.data() as Map<String, dynamic>;
        print('Found report details: $reportData');
        return reportData;
      } else {
        print('No documents found for the query.');
      }
    } catch (e) {
      print('Error fetching report details: $e');
    }
    print(
        'No report details found for StaffID: $staffID at ${timestamp.toDate()}');
    return {};
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pengesahan Laporan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: notifications.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot notificationDoc =
                                    snapshot.data!.docs[index];
                                Map<String, dynamic> notificationData =
                                    notificationDoc.data()
                                        as Map<String, dynamic>;

                                // Check if the "Datetime" field exists and is of type Timestamp
                                if (!notificationData.containsKey('Datetime') ||
                                    notificationData['Datetime']
                                        is! Timestamp) {
                                  print(
                                      'Missing or invalid Datetime field for document ID:                                      notificationDoc.id}');
                                  return ListTile(
                                    title: Text(
                                        'Missing or invalid Datetime field'),
                                    subtitle: Text(
                                        'Document ID: ${notificationDoc.id}'),
                                  );
                                }

                                Timestamp timestamp =
                                    notificationData['Datetime'];
                                String staffID = notificationData['StaffID'];

                                return FutureBuilder<String>(
                                  future: fetchTeacherName(staffID),
                                  builder: (context, teacherNameSnapshot) {
                                    if (teacherNameSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    if (teacherNameSnapshot.hasError) {
                                      return Text(
                                          'Error: ${teacherNameSnapshot.error}');
                                    }
                                    final teacherName =
                                        teacherNameSnapshot.data;

                                    if (teacherName == null ||
                                        teacherName.isEmpty) {
                                      print(
                                          'Teacher not found for StaffID: $staffID');
                                      return ListTile(
                                        title: Text(
                                            'Teacher not found for StaffID: $staffID'),
                                        subtitle: Text(
                                            'Timestamp: ${timestamp.toDate()}'),
                                      );
                                    }

                                    return FutureBuilder<Map<String, dynamic>>(
                                      future: fetchReportDetails(
                                          staffID, timestamp),
                                      builder:
                                          (context, reportDetailsSnapshot) {
                                        if (reportDetailsSnapshot
                                                .connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }
                                        if (reportDetailsSnapshot.hasError) {
                                          return Text(
                                              'Error: ${reportDetailsSnapshot.error}');
                                        }
                                        final reportDetails =
                                            reportDetailsSnapshot.data;

                                        if (reportDetails == null ||
                                            reportDetails.isEmpty) {
                                          print(
                                              'No report details found for $teacherName at timestamp ${timestamp.toDate()}');
                                          return ListTile(
                                            title: Text(
                                                'No report details found for $teacherName'),
                                            subtitle: Text(
                                                'Timestamp: ${timestamp.toDate()}'),
                                          );
                                        }

                                        bool isOpened = isOpenedMap[
                                                '${notificationDoc.id}'] ??
                                            false;

                                        return ListTile(
                                          title: Text(
                                              'Laporan Amalan Baik by $teacherName'),
                                          subtitle: Text(
                                              'Tarikh/Masa: ${timestamp.toDate()}'),
                                          trailing: isOpened
                                              ? Text('Opened')
                                              : ElevatedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Maklumat Terperinci Amalan Baik'),
                                                          content: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  'Nama Penghantar: ${reportDetails['Name']}'),
                                                              Text(
                                                                  'No.Matriks: ${reportDetails['Matrics']}'),
                                                              Text(
                                                                  'Kelas: ${reportDetails['Class']}'),
                                                              Text(
                                                                  'Jenis Amalan Baik : ${reportDetails['DeedCategory']}'),
                                                              Text(
                                                                  'Markah Amalan Baik: ${reportDetails['DeedScore']}'),
                                                              Text(
                                                                  'Ulasan: ${reportDetails['Comment']}'),
                                                            ],
                                                          ),
                                                          actions: [
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                _approveReportDetails(
                                                                    reportDetails,
                                                                    notificationDoc
                                                                        .reference); // Pass the DocumentReference
                                                                Navigator.pop(
                                                                    context);
                                                                setState(() {
                                                                  isOpenedMap[
                                                                          '${notificationDoc.id}'] =
                                                                      true;
                                                                });
                                                                _saveOpenedDialog(
                                                                    notificationDoc
                                                                        .id);
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                              ),
                                                              child: Text(
                                                                'Lulus',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                handleRejectAction(
                                                                    context,
                                                                    reportDetails); // Handle reject action
                                                                Navigator.pop(
                                                                    context);
                                                                setState(() {
                                                                  isOpenedMap[
                                                                          '${notificationDoc.id}'] =
                                                                      true;
                                                                });
                                                                _saveOpenedDialog(
                                                                    notificationDoc
                                                                        .id);
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors.red,
                                                              ),
                                                              child: Text(
                                                                'Tolak',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text('Buka'),
                                                ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                  onPressed: () async {
                    // Fetch the notification documents
                    QuerySnapshot snapshot = await notifications.get();
                    List<DocumentSnapshot> notificationDocs = snapshot.docs;

                    // Approve all reports
                    await _approveAllReports(notificationDocs);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    'Lulus semua',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ],
              ),
            ),
          ],
          
        ),
      ),
    );
  }
}
