import 'package:cloud_firestore/cloud_firestore.dart';

class RejectionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> handleReject(String staffID, Map<String, dynamic>? data) async {
    if (data == null) {
      print('No data to reject for StaffID $staffID');
      return;
    }

    try {
      await _db.collection('Teacher_evaluation')
          .doc('Rejected')
          .collection('teacher_rejected_history')
          .doc(staffID)
          .set(data);

      print('Rejected data for StaffID $staffID successfully stored');
    } catch (e) {
      print('Error storing rejected data for StaffID $staffID: $e');
    }
  }
}
