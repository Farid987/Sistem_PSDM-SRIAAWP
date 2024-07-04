import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

// Global notification list
List<String> notifications = [];

// Function to add notifications
// void addNotification(String notification) {
//   notifications.add(notification);
// }
// Function to add notifications to Firestore
// Function to add notifications to Firestore
Future<void> addNotification(String content, String matrics) async {
  // Reference to the notification document under the 'Notification' collection
  DocumentReference notificationDocRef =
      FirebaseFirestore.instance.collection('Notification').doc('notification');

  try {
    // Add the notification to the subcollection 'all_notification' with a random document ID
    await notificationDocRef.collection('all_notification').add({
      'content': content,
      'timestamp': DateTime.now(),
      'matrics': matrics, // Include the 'Matrics' field
    });
  } catch (error) {
    print('Error adding notification: $error');
  }
}

// Notification Button
class NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int notificationCount = notifications.length;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Show a new drawer when the notification button is pressed
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
        if (notificationCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$notificationCount',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

Future<int> _loadNotificationCount() async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('notifications').get();
  return querySnapshot.docs.length;
}

// Notification Drawer Content
class NotificationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white, // Change background color
        child: Column(
          children: [
            Container(
              color: Color.fromARGB(
                  255, 176, 50, 208), // Change header background color
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Notification')
                    .doc('notification')
                    .collection('all_notification')
                    .orderBy('timestamp',
                        descending: true) // Order by timestamp descending
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No notifications',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot doc = snapshot.data!.docs[index];
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      DateTime timestamp = data['timestamp'].toDate();
                      String formattedTime = DateFormat.yMd()
                          .add_jm()
                          .format(timestamp); // Format the timestamp

                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${index + 1}. ${data['content']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Submitted: $formattedTime', // Display formatted time
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'navigator');
                          },
                          child: Text(
                            'Open',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
