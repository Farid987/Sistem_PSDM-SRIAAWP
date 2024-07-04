import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void handleRejectAction(
    BuildContext outerContext, Map<String, dynamic> reportDetails) async {
  try {
    showDialog(
      context: outerContext,
      builder: (BuildContext context) {
        return Builder(
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Reject Action'),
              content: Text('Are you sure you want to reject this action?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    // Call the function passing the valid context
                    await _rejectAction(context, reportDetails);
                  },
                  child: Text('Reject'),
                ),
              ],
            );
          },
        );
      },
    );
  } catch (e) {
    ScaffoldMessenger.of(outerContext).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

Future<void> _rejectAction(
    BuildContext context, Map<String, dynamic> reportDetails) async {
  // Get a reference to the Rejected_report collection
  CollectionReference rejectedReportCollection =
      FirebaseFirestore.instance.collection('Rejected_report');

  // Generate a random document ID
  String randomDocumentId = rejectedReportCollection.doc().id;

  // Create a reference to the new document in Rejected_report collection
  DocumentReference newDocumentRef =
      rejectedReportCollection.doc(randomDocumentId);

  // Store the report details in the new document in Rejected_report collection
  await newDocumentRef.set({
    'Name': reportDetails['Name'],
    'Matrics': reportDetails['Matrics'],
    'DeedCategory': reportDetails['DeedCategory'],
    'DeedScore': reportDetails['DeedScore'],
    'Comment': reportDetails['Comment'],
    'Class': reportDetails['Class'],
  });

  // Close the dialog
  Navigator.pop(context);

  // Show a snackbar to indicate success
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Deed report rejected and stored successfully!'),
      duration: Duration(seconds: 2),
    ),
  );
}
