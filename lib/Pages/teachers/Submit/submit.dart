import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EvaluationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to fetch the StaffID associated with the user's email
  Future<String?> getStaffID() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String? email = user.email;
        if (email != null) {
          DocumentSnapshot? snapshot = await _db
              .collection('Auth_teacher')
              .where('Email', isEqualTo: email)
              .get()
              .then((querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              return querySnapshot.docs.first;
            } else {
              return null;
            }
          });

          if (snapshot != null) {
            return snapshot.get('StaffID');
          }
        }
      }
    } catch (e) {
      print("Error fetching StaffID: $e");
    }
    return null;
  }

  // Function to submit evaluation data to Firestore
  Future<void> submitEvaluation(Map<String, dynamic> data) async {
    try {
      String? staffID = await getStaffID();
      if (staffID != null) {
        data['StaffID'] = staffID;
        // Generate a new document in the 'all_submission' sub-collection
        DocumentReference docRef = _db
            .collection('Teacher_evaluation')
            .doc('Submission') // Ensure 'Submission' document exists
            .collection('all_submission')
            .doc(staffID) // Sub-collection document also named by StaffID
            .collection('history')
            .doc();

        // Update the document if it exists, otherwise create it
        await docRef.set(data, SetOptions(merge: true));
        print("Data successfully added/updated in Firestore");
      } else {
        print("StaffID not found.");
      }
    } catch (e) {
      print("Failed to add data: $e");
    }
  }
}
