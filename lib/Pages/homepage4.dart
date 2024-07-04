// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'loginpage.dart';

// class HomePage4 extends StatefulWidget {
//   final User? user;

//   const HomePage4({Key? key, this.user}) : super(key: key);

//   @override
//   _HomePage4State createState() => _HomePage4State();
// }

// class _HomePage4State extends State<HomePage4> {
//   void showAddStudentDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AddStudentDialog(),
//     );
//   }

//   void logout() {
//     FirebaseAuth.instance.signOut().then((value) {
//       Navigator.of(context)
//           .pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('HomePage4'),
//       ),
//       body: Stack(child: ElevatedButton(
                  //   onPressed: _handleSubmit,
                  //   child: Text(
                  //     'Hantar',
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.blue,
                  //   ),
                  // ),
//         children: [
//           // Background Gradient
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Colors.purple, Colors.white],
//               ),
//             ),
//           ),
//           // Main Content Area
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => showAddStudentDialog(context),
//                   child: Text('Add Button'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AddStudentDialog extends StatefulWidget {
//   @override
//   _AddStudentDialogState createState() => _AddStudentDialogState();
// }

// class _AddStudentDialogState extends State<AddStudentDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _classController = TextEditingController();
//   final TextEditingController _yearsController = TextEditingController();
//   final TextEditingController _matricsController = TextEditingController();

//   void _addOrUpdateStudent() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       String name = _nameController.text.trim();
//       String classInfo = _classController.text.trim();
//       String years = _yearsController.text.trim();
//       String matrics = _matricsController.text.trim();

//       CollectionReference students =
//           FirebaseFirestore.instance.collection('Student');

//       DocumentReference studentDoc = students.doc(matrics);

//       await studentDoc.set({
//         'Name': name,
//         'Class': classInfo,
//         'Matrics': matrics,
//         'Years': years,
//       }, SetOptions(merge: true));

//       Navigator.of(context).pop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Add Student'),
//       content: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _classController,
//                 decoration: InputDecoration(labelText: 'Class'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a class';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _yearsController,
//                 decoration: InputDecoration(labelText: 'Years'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter years';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _matricsController,
//                 decoration: InputDecoration(labelText: 'Matrics'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a matrics number';
//                   }
//                   return null;
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: _addOrUpdateStudent,
//           child: Text('Submit'),
//         ),
//       ],
//     );
//   }
// }

//good deeds code
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class GoodDeedsWidget extends StatefulWidget {
//   @override
//   _GoodDeedsWidgetState createState() => _GoodDeedsWidgetState();
// }

// class _GoodDeedsWidgetState extends State<GoodDeedsWidget> {
//   late DateTime selectedDate;
//   String? selectedName;
//   String? selectedClass;
//   String? selectedMerit;
//   String? selectedMatric;
//   List<String> names = [];
//   List<String> classes = [];
//   List<String> matrics = [];
//   List<String> merits = ['1', '2', '3', '4', '5'];

//   @override
//   void initState() {
//     super.initState();
//     selectedDate = DateTime.now();
//     fetchStudentsData();
//   }

//   Future<void> fetchStudentsData() async {
//     final snapshot =
//         await FirebaseFirestore.instance.collection('Student').get();

//     List<String> allNames = [];
//     List<String> allClasses = [];
//     List<String> allMatrics = [];

//     // Loop through each document in the collection
//     snapshot.docs.forEach((doc) {
//       // Extract the name, class, and matric fields from each document and add them to the respective lists
//       final name = doc.get('Name') as String?;
//       final className = doc.get('Class') as String?;
//       final matric = doc.get('Matric') as String?;
//       if (name != null) {
//         allNames.add(name);
//       }
//       if (className != null) {
//         allClasses.add(className);
//       }
//       if (matric != null) {
//         allMatrics.add(matric);
//       }
//     });

//     print('All Names: $allNames');
//     print('All Classes: $allClasses');
//     print('All Matrics: $allMatrics');

//     setState(() {
//       // Update the names, classes, and matrics lists with all values fetched from the collection
//       names = allNames;
//       classes = allClasses;
//       matrics = allMatrics;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Container(
//         padding: EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10.0),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.3),
//               spreadRadius: 3,
//               blurRadius: 5,
//               offset: Offset(0, 3), // changes position of shadow
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Good Deeds Report',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Name:',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       _buildNameDropdown(),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Class:',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       _buildClassDropdown(),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Matric:',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       _buildMatricDropdown(),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Merit:',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       _buildMeritDropdown(),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 40),
//             _buildTextField('Deed Category', hintText: 'Enter deed category'),
//             SizedBox(height: 40),
//             _buildDateTimePicker(context),
//             SizedBox(height: 40),
//             _buildTextField('Remark/Comment',
//                 hintText: 'Enter remark or comment', maxLines: 4),
//             SizedBox(height: 80),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Handle submit button action
//                   _handleSubmit();
//                 },
//                 child: Text(
//                   'Submit',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNameDropdown() {
//     return Container(
//       width: 200, // Adjust the width as needed
//       child: ListView(
//         shrinkWrap: true,
//         children: [
//           DropdownButton<String>(
//             value: selectedName,
//             hint: Text('Select Name'),
//             onChanged: (String? value) {
//               setState(() {
//                 selectedName = value;
//                 // Automatically select class based on name
//                 selectedClass = classes[names.indexOf(value!)];
//               });
//             },
//             items: names.map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildClassDropdown() {
//     return DropdownButton<String>(
//       value: selectedClass,
//       hint: Text('Select Class'),
//       onChanged: (String? value) {
//         setState(() {
//           selectedClass = value;
//         });
//       },
//       items: classes.map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildMatricDropdown() {
//     return DropdownButton<String>(
//       value: selectedMatric,
//       hint: Text('Select Matric'),
//       onChanged: (String? value) {
//         setState(() {
//           selectedMatric = value;
//         });
//       },
//       items: matrics.map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildMeritDropdown() {
//     return DropdownButton<String>(
//       value: selectedMerit,
//       hint: Text('Select Merit'),
//       onChanged: (String? value) {
//         setState(() {
//           selectedMerit = value;
//         });
//       },
//       items: merits.map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildTextField(String label, {String? hintText, int maxLines = 1}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         SizedBox(height: 8),
//         TextField(
//           maxLines: maxLines,
//           decoration: InputDecoration(
//             hintText: hintText,
//             border: OutlineInputBorder(),
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.blue, width: 2.0),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDateTimePicker(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Select Date',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             )),
//         SizedBox(height: 8),
//         Row(
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 final DateTime? pickedDate = await showDatePicker(
//                   context: context,
//                   initialDate: selectedDate,
//                   firstDate: DateTime(2000),
//                   lastDate: DateTime(2101),
//                 );
//                 if (pickedDate != null && pickedDate != selectedDate) {
//                   setState(() {
//                     selectedDate = pickedDate;
//                   });
//                 }
//               },
//               child: Text(
//                 'Select Date',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 10),
//         Text('Selected Date: ${DateFormat('dd-MM-yyyy').format(selectedDate)}',
//             style: TextStyle(fontSize: 16)),
//       ],
//     );
//   }

//   void _handleSubmit() {
//     // Implement your submit logic here, such as sending data to a server
//     // You can access the form data within this method
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       body: GoodDeedsWidget(),
//     ),
//   ));
// }
// import 'package:flutter/material.dart';
// import 'add_student_button.dart';
// import 'add_teacher_button.dart';
// import 'annual_update_button.dart';

// // Your existing code here...

// class NavigationPane extends StatelessWidget {
//   final Function(int) onSelectPage;

//   const NavigationPane({required this.onSelectPage});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       width: 200,
//       child: Column(
//         children: [
//           const SizedBox(height: 50),
//           Image.asset(
//             'assets/logo.png', // Update to use the asset image
//             width: 100,
//             height: 100,
//           ),
//           const SizedBox(height: 20),
//           AddStudentButton(
//             onPressed: () => onSelectPage(0),
//           ),
//           const SizedBox(height: 20), // Adjust the height here
//           AddTeacherButton(
//             onPressed: () => onSelectPage(1),
//           ),
//           const SizedBox(height: 20), // Adjust the height here
//           AnnualUpdateButton(
//             onPressed: () => onSelectPage(2),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Your remaining code here...
