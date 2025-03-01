import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:georgenabil/App_Policy.dart';
import 'package:georgenabil/firebase_options.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Site Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: PolicyPage(),
    );
  }
}

class SiteCrudPage extends StatefulWidget {
  const SiteCrudPage({super.key});

  @override
  _SiteCrudPageState createState() => _SiteCrudPageState();
}

class _SiteCrudPageState extends State<SiteCrudPage> {
  final CollectionReference sites =
      FirebaseFirestore.instance.collection('sites');

  final TextEditingController siteNameController = TextEditingController();
  final TextEditingController siteUrlController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _searchQuery = '';
  // Fetch data from Firestore
  Stream<QuerySnapshot> _fetchSites() {
    return _firestore.collection('sites').snapshots();
  }

  Future<void> _exportToExcel(BuildContext context) async {
    // Check platform-specific permission handling (only for mobile platforms)
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        await Permission.storage.request();
        if (!await Permission.storage.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Storage permission is required!')),
          );
          return;
        }
      }
    }

    // Create a new Excel document
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Set headers in the Excel sheet
    sheetObject.appendRow(
      ['Site Name', 'Site URL', 'Username', 'Email', 'Phone', 'Password'],
    );

    // Fetch data from Firestore
    var snapshot = await FirebaseFirestore.instance.collection('sites').get();
    var sites = snapshot.docs;

    // Add data rows to Excel sheet
    for (var doc in sites) {
      var data = doc.data();
      sheetObject.appendRow([
        data['siteName'],
        data['siteUrl'],
        data['username'],
        data['email'],
        data['phone'],
        data['password'],
      ]);
    }

    // Handle file download for web and saving for mobile platforms
    if (kIsWeb) {
      // final bytes = excel.encode();
      // final blob = html.Blob([Uint8List.fromList(bytes!)]);
      // final url = html.Url.createObjectUrlFromBlob(blob);
      // final anchor = html.AnchorElement(href: url)
      //   ..target = 'blank'
      //   ..download = 'sites_data.xlsx';
      // anchor.click();
    } else {
      // Mobile platforms (Android/iOS): Save file locally
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/sites_data.xlsx';
      final file = File(filePath);

      // Write the Excel file to disk
      await file.writeAsBytes(excel.encode()!);

      // Show a message indicating success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excel file saved at $filePath')),
      );
    }
  }

  void _addOrUpdateSite([String? id]) async {
    if (siteNameController.text.isEmpty || siteUrlController.text.isEmpty) {
      return;
    }

    final siteData = {
      'siteName': siteNameController.text,
      'siteUrl': siteUrlController.text,
      'username': usernameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'password': passwordController.text,
    };

    if (id == null) {
      await sites.add(siteData);
    } else {
      await sites.doc(id).update(siteData);
    }

    _clearFields();
    Navigator.pop(context);
  }

  void _deleteSite(String id) async {
    await sites.doc(id).delete();
  }

  void _clearFields() {
    siteNameController.clear();
    siteUrlController.clear();
    usernameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
  }

  void _showForm([String? id, Map<String, dynamic>? data]) {
    if (data != null) {
      siteNameController.text = data['siteName'];
      siteUrlController.text = data['siteUrl'];
      usernameController.text = data['username'];
      emailController.text = data['email'];
      phoneController.text = data['phone'];
      passwordController.text = data['password'];
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(id == null ? 'Add Site' : 'Edit Site'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField('Site Name', siteNameController),
            _buildTextField('Site URL', siteUrlController),
            _buildTextField('Username', usernameController),
            _buildTextField('Email', emailController),
            _buildTextField('Phone', phoneController),
            _buildTextField('Password', passwordController),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () => _addOrUpdateSite(id),
            child: Text(id == null ? 'Add' : 'Update'),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Images/My_Logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => _showForm(),
                  child: Text('Add Site'),
                ),
                IconButton(
                  onPressed: () async {
                    await _exportToExcel(context);
                  },
                  icon: const Icon(Icons.download_rounded),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: sites.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(
                                label: Text(
                              'Site Name',
                              style: TextStyle(color: Colors.white),
                            )),
                            DataColumn(
                                label: Text(
                              'URL',
                              style: TextStyle(color: Colors.white),
                            )),
                            DataColumn(
                                label: Text(
                              'Username',
                              style: TextStyle(color: Colors.white),
                            )),
                            DataColumn(
                                label: Text(
                              'Email',
                              style: TextStyle(color: Colors.white),
                            )),
                            DataColumn(
                                label: Text(
                              'Phone',
                              style: TextStyle(color: Colors.white),
                            )),
                            DataColumn(
                                label: Text(
                              'Password',
                              style: TextStyle(color: Colors.white),
                            )),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: snapshot.data!.docs.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            return DataRow(cells: [
                              DataCell(Text(
                                data['siteName'],
                                style: TextStyle(color: Colors.white),
                              )),
                              DataCell(Text(
                                data['siteUrl'],
                                style: TextStyle(color: Colors.white),
                              )),
                              DataCell(Text(
                                data['username'],
                                style: TextStyle(color: Colors.white),
                              )),
                              DataCell(Text(
                                data['email'],
                                style: TextStyle(color: Colors.white),
                              )),
                              DataCell(Text(
                                data['phone'],
                                style: TextStyle(color: Colors.white),
                              )),
                              DataCell(Text(
                                data['password'],
                                style: TextStyle(color: Colors.white),
                              )),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () => _showForm(doc.id, data),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteSite(doc.id),
                                  ),
                                ],
                              )),
                            ]);
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
