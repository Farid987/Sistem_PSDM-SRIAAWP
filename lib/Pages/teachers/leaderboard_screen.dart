import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardWidget extends StatefulWidget {
  @override
  _LeaderboardWidgetState createState() => _LeaderboardWidgetState();
}

class _LeaderboardWidgetState extends State<LeaderboardWidget> {
  List<Map<String, dynamic>> leaderboardData = [];
  List<String> yearList = [];
  List<String> classList = ['All Classes'];
  String? selectedYear;
  String? selectedClass;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchYearList();
    _fetchLeaderboardData();
  }

  Future<void> _fetchYearList() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('Class').get();

      setState(() {
        yearList = snapshot.docs
            .map((doc) => doc.get('Year') as String)
            .toSet() // Remove duplicates
            .toList();
      });
    } catch (error) {
      print('Error fetching year list: $error');
    }
  }

  Future<void> _fetchClassList() async {
    if (selectedYear == null) {
      return;
    }
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Class')
          .where('Year', isEqualTo: selectedYear)
          .get();

      setState(() {
        classList = snapshot.docs
            .expand((doc) => (doc.get('Class') as String).split(','))
            .map((e) => e.trim())
            .toList();
        classList.insert(0, 'All Classes'); // Add an option for 'All Classes'
        selectedClass = 'All Classes'; // Reset selected class
      });
    } catch (error) {
      print('Error fetching class list: $error');
    }
  }

  Future<void> _fetchLeaderboardData() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot snapshot;
      if (selectedClass == null || selectedClass == 'All Classes') {
        snapshot = await FirebaseFirestore.instance
            .collection('Leaderboard')
            .orderBy('DeedScore', descending: true)
            .limit(10)
            .get();
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection('Leaderboard')
            .where('Class', isEqualTo: selectedClass)
            .get();
      }

      List<Map<String, dynamic>> fetchedData = snapshot.docs
          .map((doc) {
            final name = doc.get('Name') as String?;
            final matrics = doc.get('Matrics') as String?;
            final deedScore = doc.get('DeedScore');

            int? score;
            if (deedScore is int) {
              score = deedScore;
            } else if (deedScore is String) {
              try {
                score = int.parse(deedScore);
              } catch (e) {
                print('Error parsing DeedScore for document ${doc.id}: $e');
                score = null;
              }
            }

            return {
              'Name': name,
              'Matrics': matrics,
              'DeedScore': score,
            };
          })
          .where((data) =>
              data['Name'] != null &&
              data['Matrics'] != null &&
              data['DeedScore'] != null)
          .toList();

      if (selectedClass != null && selectedClass != 'All Classes') {
        fetchedData.sort(
            (a, b) => (b['DeedScore'] as int).compareTo(a['DeedScore'] as int));
      }

      setState(() {
        leaderboardData = fetchedData;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching leaderboard data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            height: 750,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      yearList.isEmpty
                          ? CircularProgressIndicator()
                          : DropdownButton<String>(
                              value: selectedYear,
                              hint: Text("Pilih Tahun"),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedYear = newValue;
                                  selectedClass =
                                      'All Classes'; // Reset selected class
                                  classList = [
                                    'All Classes'
                                  ]; // Clear class list
                                });
                                _fetchClassList(); // Fetch class list based on selected year
                              },
                              items: yearList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                      SizedBox(width: 20),
                      DropdownButton<String>(
                        value: selectedClass,
                        hint: Text("Pilih kelas"),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedClass = newValue;
                          });
                          _fetchLeaderboardData(); // Refresh leaderboard data
                        },
                        items: classList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemExtent: 100.0,
                          shrinkWrap: true,
                          itemCount: leaderboardData.length,
                          itemBuilder: (context, index) {
                            final data = leaderboardData[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[100],
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          _buildRankIcon(index),
                                          SizedBox(width: 10),
                                          Text(
                                            (index + 1).toString(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              data['Name']!,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Matriks: ${data['Matrics']}',
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 15,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'Markah: ${data['DeedScore']}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRankIcon(int index) {
    switch (index) {
      case 0:
        return Icon(Icons.emoji_events, color: Colors.amber);
      case 1:
        return Icon(Icons.emoji_events, color: Colors.grey);
      case 2:
        return Icon(Icons.emoji_events, color: Colors.brown);
      default:
        return SizedBox.shrink();
    }
  }
}
