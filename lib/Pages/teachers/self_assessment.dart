import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Submit/submit.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: MonthlyEvaluationWidget(),
    ),
  ));
}

class MonthlyEvaluationWidget extends StatefulWidget {
  @override
  _MonthlyEvaluationWidgetState createState() =>
      _MonthlyEvaluationWidgetState();
}

class _MonthlyEvaluationWidgetState extends State<MonthlyEvaluationWidget> {
  final EvaluationService _databaseService = EvaluationService();

  // Controllers for PDP section
  final TextEditingController _comment1Controller = TextEditingController();
  final TextEditingController _markah1Controller = TextEditingController();
  final TextEditingController _comment2Controller = TextEditingController();
  final TextEditingController _markah2Controller = TextEditingController();
  final TextEditingController _comment3Controller = TextEditingController();
  final TextEditingController _markah3Controller = TextEditingController();

  // Controllers for PROGRAM SEKOLAH section
  final TextEditingController _markah4Controller = TextEditingController();
  final TextEditingController _markah5Controller = TextEditingController();
  final TextEditingController _markah6Controller = TextEditingController();
  final TextEditingController _markah7Controller = TextEditingController();
  final TextEditingController _markah8Controller = TextEditingController();

  // Controllers for TARBIYYAH section
  final TextEditingController _markah9Controller = TextEditingController();
  final TextEditingController _markah10Controller = TextEditingController();

  // Controllers for PENINGKATAN DIRI section
  final TextEditingController _markah11Controller = TextEditingController();
  final TextEditingController _markah12Controller = TextEditingController();

  // Controllers for PENGLIBATAN LUAR section
  final TextEditingController _markah13Controller = TextEditingController();
  final TextEditingController _markah14Controller = TextEditingController();
  bool _isButtonEnabled = false;

  void handleSubmit(BuildContext context) async {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    final Map<String, dynamic> formData = {
      'PDP': {
        'Comment1': _comment1Controller.text,
        'Markah1': _markah1Controller.text,
        'Comment2': _comment2Controller.text,
        'Markah2': _markah2Controller.text,
        'Comment3': _comment3Controller.text,
        'Markah3': _markah3Controller.text,
      },
      'ProgramSekolah': {
        'Markah4': _markah4Controller.text,
        'Markah5': _markah5Controller.text,
        'Markah6': _markah6Controller.text,
        'Markah7': _markah7Controller.text,
        'Markah8': _markah8Controller.text,
      },
      'Tarbiyyah': {
        'Markah9': _markah9Controller.text,
        'Markah10': _markah10Controller.text,
      },
      'PeningkatanDiri': {
        'Markah11': _markah11Controller.text,
        'Markah12': _markah12Controller.text,
      },
      'PenglibatanLuar': {
        'Markah13': _markah13Controller.text,
        'Markah14': _markah14Controller.text,
      },
      'SubmissionTime': formattedDate, // Add the submission time
    };

    // Reset all the fields after submission
    _comment1Controller.clear();
    _markah1Controller.clear();
    _comment2Controller.clear();
    _markah2Controller.clear();
    _comment3Controller.clear();
    _markah3Controller.clear();
    _markah4Controller.clear();
    _markah5Controller.clear();
    _markah6Controller.clear();
    _markah7Controller.clear();
    _markah8Controller.clear();
    _markah9Controller.clear();
    _markah10Controller.clear();
    _markah11Controller.clear();
    _markah12Controller.clear();
    _markah13Controller.clear();
    _markah14Controller.clear();

    await _databaseService.submitEvaluation(formData);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Data submitted successfully')));
  }

  @override
  void initState() {
    super.initState();
    _comment1Controller.addListener(_checkIfAllFieldsAreFilled);
    _markah1Controller.addListener(_checkIfAllFieldsAreFilled);
    _comment2Controller.addListener(_checkIfAllFieldsAreFilled);
    _markah2Controller.addListener(_checkIfAllFieldsAreFilled);
    _comment3Controller.addListener(_checkIfAllFieldsAreFilled);
    _markah3Controller.addListener(_checkIfAllFieldsAreFilled);
    _markah4Controller.addListener(_checkIfAllFieldsAreFilled);
    _markah5Controller.addListener(_checkIfAllFieldsAreFilled);
    _markah6Controller.addListener(_checkIfAllFieldsAreFilled);
    _markah7Controller.addListener(_checkIfAllFieldsAreFilled);
    _markah8Controller.addListener(_checkIfAllFieldsAreFilled);
    _markah9Controller.addListener(_checkIfAllFieldsAreFilled);
    _markah10Controller.addListener(_checkIfAllFieldsAreFilled);
    _markah11Controller.addListener(_checkIfAllFieldsAreFilled);
    _markah12Controller.addListener(_checkIfAllFieldsAreFilled);
    _markah13Controller.addListener(_checkIfAllFieldsAreFilled);
    _markah14Controller.addListener(_checkIfAllFieldsAreFilled);
  }

  void _checkIfAllFieldsAreFilled() {
    setState(() {
      _isButtonEnabled = _comment1Controller.text.isNotEmpty &&
          _markah1Controller.text.isNotEmpty &&
          _comment2Controller.text.isNotEmpty &&
          _markah2Controller.text.isNotEmpty &&
          _comment3Controller.text.isNotEmpty &&
          _markah3Controller.text.isNotEmpty &&
          _markah4Controller.text.isNotEmpty &&
          _markah5Controller.text.isNotEmpty &&
          _markah6Controller.text.isNotEmpty &&
          _markah7Controller.text.isNotEmpty &&
          _markah8Controller.text.isNotEmpty &&
          _markah9Controller.text.isNotEmpty &&
          _markah10Controller.text.isNotEmpty &&
          _markah11Controller.text.isNotEmpty &&
          _markah12Controller.text.isNotEmpty &&
          _markah13Controller.text.isNotEmpty &&
          _markah14Controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _comment1Controller.dispose();
    _markah1Controller.dispose();
    _comment2Controller.dispose();
    _markah2Controller.dispose();
    _comment3Controller.dispose();
    _markah3Controller.dispose();
    _markah4Controller.dispose();
    _markah5Controller.dispose();
    _markah6Controller.dispose();
    _markah7Controller.dispose();
    _markah8Controller.dispose();
    _markah9Controller.dispose();
    _markah10Controller.dispose();
    _markah11Controller.dispose();
    _markah12Controller.dispose();
    _markah13Controller.dispose();
    _markah14Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: 1200,
          height: 700,
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Penilaian Prestasi Tahunan ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Markah Keberhasilan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ExpansionTile(
                      title: Text(
                        'PDP (40%)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contoh Penulisan',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Contoh : 90% murid tahun 2 & 3 yang saya ajar mendapat Band 5 dalam pentaskiran akhir tahun untuk subjek English',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Contoh : 30% murid tahun 2 & 3 yang saya ajar dapat menguasai komunikasi dalam bahasa Inggeris dengan baik',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Contoh : 30% murid tahun 2 & 3 dapat membaca petikan Bahasa Inggeris dengan baik',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ExpansionTile(
                          title: Text(
                            'Mencapai sekurang-kurangnya 85% penghantaran PDPC.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        600, // Set the width for the first text box
                                    child: TextFormField(
                                      controller: _comment1Controller,
                                      decoration: InputDecoration(
                                        hintText: 'Ulasan',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          20), // Space between the text fields
                                  Container(
                                    width:
                                        150, // Set the width for the second text box
                                    child: TextFormField(
                                      controller: _markah1Controller,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                        _RangeTextInputFormatter(
                                            min: 1, max: 100),
                                      ],
                                      decoration: InputDecoration(
                                        hintText: 'Markah (1-100)',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                            'Menyediakan sekurang-kurangnya satu Bahan Bantu Mengajar BBM dalam setahun.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        600, // Set the width for the first text box
                                    child: TextFormField(
                                      controller: _comment2Controller,
                                      decoration: InputDecoration(
                                        hintText: 'Ulasan',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          20), // Space between the text fields
                                  Container(
                                    width:
                                        150, // Set the width for the second text box
                                    child: TextFormField(
                                      controller: _markah2Controller,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                        _RangeTextInputFormatter(
                                            min: 1, max: 100),
                                      ],
                                      decoration: InputDecoration(
                                        hintText: 'Markah (1-100)',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                            'Mempelajari sekurang-kurangnya satu kemahiran baru dan dapat mengamalkan di dalam PDPC.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        600, // Set the width for the first text box
                                    child: TextFormField(
                                      controller: _comment3Controller,
                                      decoration: InputDecoration(
                                        hintText: 'Ulasan',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          20), // Space between the text fields
                                  Container(
                                    width:
                                        150, // Set the width for the second text box
                                    child: TextFormField(
                                      controller: _markah3Controller,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                        _RangeTextInputFormatter(
                                            min: 1, max: 100),
                                      ],
                                      decoration: InputDecoration(
                                        hintText: 'Markah (1-100)',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ExpansionTile(
                      title: Text(
                        'PROGRAM SEKOLAH (30%)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        ExpansionTile(
                          title: Text(
                            'Memberi sumbangan yang signifikan dalam program sekolah',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextFormField(
                                controller: _markah4Controller,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  _RangeTextInputFormatter(min: 1, max: 100),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Markah (1-100)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                            'Melaksanakan aktiviti ko-kurikulum dengan aktif',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextFormField(
                                controller: _markah5Controller,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  _RangeTextInputFormatter(min: 1, max: 100),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Markah (1-100)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                            'Mempromosikan budaya sihat di sekolah',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextFormField(
                                controller: _markah6Controller,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  _RangeTextInputFormatter(min: 1, max: 100),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Markah (1-100)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                            'Menganjurkan program motivasi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextFormField(
                                controller: _markah7Controller,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  _RangeTextInputFormatter(min: 1, max: 100),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Markah (1-100)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                            'Mengelola pertandingan antara kelas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextFormField(
                                controller: _markah8Controller,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  _RangeTextInputFormatter(min: 1, max: 100),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Markah (1-100)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ExpansionTile(
                      title: Text(
                        'TARBIYYAH (15%)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        ExpansionTile(
                          title: Text(
                            'Menghadiri sekurang-kurangnya 90% daripada program tarbiyah anjuran sekolah',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextFormField(
                                controller: _markah9Controller,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  _RangeTextInputFormatter(min: 1, max: 100),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Markah (1-100)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                            'Memberi sumbangan dalam program tarbiyah sekolah',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextFormField(
                                controller: _markah10Controller,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  _RangeTextInputFormatter(min: 1, max: 100),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Markah (1-100)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ExpansionTile(
                      title: Text(
                        'PENINGKATAN DIRI (10%)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        ExpansionTile(
                          title: Text(
                            'Menyertai sekurang-kurangnya satu kursus peningkatan diri dalam setahun',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextFormField(
                                controller: _markah11Controller,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  _RangeTextInputFormatter(min: 1, max: 100),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Markah (1-100)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                            'Membaca sekurang-kurangnya satu buku peningkatan diri dalam setahun',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextFormField(
                                controller: _markah12Controller,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  _RangeTextInputFormatter(min: 1, max: 100),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Markah (1-100)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ExpansionTile(
                      title: Text(
                        'PENGLIBATAN LUAR (5%)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        ExpansionTile(
                          title: Text(
                            'Menghadiri sekurang-kurangnya dua program luar sekolah',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextFormField(
                                controller: _markah13Controller,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  _RangeTextInputFormatter(min: 1, max: 100),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Markah (1-100)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                            'Menyertai sekurang-kurangnya satu pertandingan sukan peringkat negeri/sekolah',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextFormField(
                                controller: _markah14Controller,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  _RangeTextInputFormatter(min: 1, max: 100),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Markah 14 (1-100)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed:
                          _isButtonEnabled ? () => handleSubmit(context) : null,
                      child: Text('Hantar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RangeTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  _RangeTextInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    } else {
      final int value = int.tryParse(newValue.text) ?? 0;
      if (value < min) {
        return TextEditingValue(
          text: min.toString(),
          selection: TextSelection.collapsed(offset: min.toString().length),
        );
      } else if (value > max) {
        return TextEditingValue(
          text: max.toString(),
          selection: TextSelection.collapsed(offset: max.toString().length),
        );
      }
      return newValue;
    }
  }
}
