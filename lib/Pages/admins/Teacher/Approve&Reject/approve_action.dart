import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

bool isNotificationShown = false; // Flag to track notification state

Future<void> _approveAction(BuildContext context, Map<String, dynamic> reportDetails) async {
  try {
    // Get a reference to the Approved_report collection
    CollectionReference approvedReportCollection = FirebaseFirestore.instance.collection('Approved_report');

    // Generate a random document ID
    String randomDocumentId = approvedReportCollection.doc().id;

    // Create a reference to the new document in Approved_report collection
    DocumentReference newDocumentRef = approvedReportCollection.doc(randomDocumentId);

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
    CollectionReference leaderboardCollection = FirebaseFirestore.instance.collection('Leaderboard');

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
    await leaderboardCollection.doc(reportDetails['Name']).set(data, SetOptions(merge: true));

    // Check if context is not null before popping and showing snackbar
    Navigator.pop(context);

    // Show a snackbar to indicate success only if it's not shown already
    if (!isNotificationShown) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deed report approved and stored successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
      isNotificationShown = true; // Update flag
    }

    print('Deed report approved and stored successfully!');
  } catch (e) {
    print('Error approving report: $e');
    // Handle error as needed
  }
}

void resetNotificationFlag() {
  isNotificationShown = false;
}
