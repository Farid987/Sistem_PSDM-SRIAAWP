import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Import HomePage for reuse
import '../Teachers/leaderboard_screen.dart';
import '../loginpage.dart';

class Parents extends StatefulWidget {
  final User? user;

  const Parents({Key? key, this.user}) : super(key: key);

  @override
  _ParentsPageState createState() => _ParentsPageState();
}

class _ParentsPageState extends State<Parents> {
  bool showLeaderboard = false;

  void toggleLeaderboard() {
    setState(() {
      showLeaderboard = !showLeaderboard;
    });
  }

  void logout() {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[900],
        iconTheme: IconThemeData(
          color: Colors.white, // Change the drawer icon color
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 1.0), // Add some padding for better appearance
              decoration: BoxDecoration(
                color: Colors.purple[900], // Fill color inside the container
                border: Border.all(color: Colors.white), // Border color
                borderRadius: BorderRadius.circular(
                    8.0), // Optional: make the border rounded
              ),
              child: Text(
                'Sistem Penilaian Sahsiah Diri Murid',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        Colors.white), // Adjust font size and color as needed
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(
        toggleLeaderboard: toggleLeaderboard,
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'lib/assets/Background.png'), // Replace with your image path
                fit: BoxFit.fill, // Adjust fit as needed
              ),
            ),
          ),
          // Main Content Area
          Positioned(
            left: MediaQuery.of(context).size.width * 0.2,
            top: 70,
            bottom: 45,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Container(
              color: Colors.transparent, // Make the container transparent
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showLeaderboard) ...[
                      LeaderboardWidget(),
                    ]
                  ],
                ),
              ),
            ),
          ),
          // Welcome Text
        ],
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  final VoidCallback toggleLeaderboard;

  MyDrawer({
    Key? key,
    required this.toggleLeaderboard,
  }) : super(key: key);

  final TextStyle drawerTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/Logo.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: null,
          ),
          SizedBox(height: 24.0),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: const Icon(Icons.leaderboard_outlined),
                    title: Center(
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: toggleLeaderboard,
                          child: Text(
                            'Leaderboard',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: Center(
                child: Text(
                  'Log Keluar',
                  style: drawerTextStyle,
                ),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

bool showLeaderboard = false;
