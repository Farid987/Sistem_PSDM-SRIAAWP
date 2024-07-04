import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovalService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> handleApprove(
      String staffID, Map<String, dynamic>? data, List<int> inputMarks) async {
    if (data == null) {
      print('No data to approve for StaffID $staffID');
      return;
    }

    try {
      // Debug print to show the entire fetched data
      print('Assessment Data for StaffID $staffID: $data');

      // Initialize variables for calculating total fetched marks
      int totalFetchedMarks = 0;

      // Extracting PDP marks
      Map<String, dynamic>? pdpData = data['PDP'] as Map<String, dynamic>?;
      if (pdpData != null) {
        for (int i = 1; i <= 3; i++) {
          // Assuming there are 3 Markah fields under PDP
          String markKey = 'Markah$i';
          dynamic markValue = pdpData[markKey];
          if (markValue is int) {
            totalFetchedMarks += markValue;
          } else if (markValue is String) {
            // Parse the string to int if possible, else default to 0
            totalFetchedMarks += int.tryParse(markValue) ?? 0;
          }
          print(
              'Fetched Mark $i: $markValue'); // Debug print for each fetched mark
        }
      }

      // Extracting ProgramSekolah marks
      Map<String, dynamic>? programData =
          data['ProgramSekolah'] as Map<String, dynamic>?;
      if (programData != null) {
        for (int i = 4; i <= 8; i++) {
          // Assuming there are 5 Markah fields under ProgramSekolah
          String markKey = 'Markah$i';
          dynamic markValue = programData[markKey];
          if (markValue is int) {
            totalFetchedMarks += markValue;
          } else if (markValue is String) {
            // Parse the string to int if possible, else default to 0
            totalFetchedMarks += int.tryParse(markValue) ?? 0;
          }
          print(
              'Fetched Mark $i: $markValue'); // Debug print for each fetched mark
        }
      }

      // Extracting Tarbiyyah marks
      Map<String, dynamic>? tarbiyyahData =
          data['Tarbiyyah'] as Map<String, dynamic>?;
      if (tarbiyyahData != null) {
        for (int i = 9; i <= 10; i++) {
          // Assuming there are 2 Markah fields under Tarbiyyah
          String markKey = 'Markah$i';
          dynamic markValue = tarbiyyahData[markKey];
          if (markValue is int) {
            totalFetchedMarks += markValue;
          } else if (markValue is String) {
            // Parse the string to int if possible, else default to 0
            totalFetchedMarks += int.tryParse(markValue) ?? 0;
          }
          print(
              'Fetched Mark $i: $markValue'); // Debug print for each fetched mark
        }
      }

      // Extracting PeningkatanDiri marks
      Map<String, dynamic>? peningkatanData =
          data['PeningkatanDiri'] as Map<String, dynamic>?;
      if (peningkatanData != null) {
        for (int i = 11; i <= 12; i++) {
          // Assuming there are 2 Markah fields under PeningkatanDiri
          String markKey = 'Markah$i';
          dynamic markValue = peningkatanData[markKey];
          if (markValue is int) {
            totalFetchedMarks += markValue;
          } else if (markValue is String) {
            // Parse the string to int if possible, else default to 0
            totalFetchedMarks += int.tryParse(markValue) ?? 0;
          }
          print(
              'Fetched Mark $i: $markValue'); // Debug print for each fetched mark
        }
      }

      // Extracting PenglibatanLuar marks
      Map<String, dynamic>? penglibatanData =
          data['PenglibatanLuar'] as Map<String, dynamic>?;
      if (penglibatanData != null) {
        for (int i = 13; i <= 14; i++) {
          // Assuming there are 2 Markah fields under PenglibatanLuar
          String markKey = 'Markah$i';
          dynamic markValue = penglibatanData[markKey];
          if (markValue is int) {
            totalFetchedMarks += markValue;
          } else if (markValue is String) {
            // Parse the string to int if possible, else default to 0
            totalFetchedMarks += int.tryParse(markValue) ?? 0;
          }
          print(
              'Fetched Mark $i: $markValue'); // Debug print for each fetched mark
        }
      }

      double initialPercentage = (totalFetchedMarks / 1400) * 100;
      print(
          'Total Fetched Marks: $totalFetchedMarks, Initial Percentage: $initialPercentage'); // Debug print for total and percentage

      // Sum the input marks
      int totalInputMarks = inputMarks.fold(0, (sum, mark) => sum + mark);
      double finalPercentage = (totalInputMarks / 1400) * 100;
      print(
          'Total Input Marks: $totalInputMarks, Final Percentage: $finalPercentage'); // Debug print for total and percentage

      // Store the result in Firestore
      await _db
          .collection('Teacher_evaluation')
          .doc('Approved')
          .collection('teacher_approved_history')
          .doc(staffID)
          .update({
            'Penilaian_awal': initialPercentage,
            'Penilaian_akhir': finalPercentage,
            'StaffID': staffID,
            'time': FieldValue.serverTimestamp(),
          })
          .then((_) => print('Updated data for StaffID $staffID successfully'))
          .catchError((error) => print('Error updating data: $error'));

      print('Approved data for StaffID $staffID successfully stored');
    } catch (e) {
      print('Error storing approved data for StaffID $staffID: $e');
    }
  }
}
