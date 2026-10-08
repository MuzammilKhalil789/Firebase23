import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Components/Textfield.dart';
import 'package:firebase/screens/fetch_data_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InsertDataScreen extends StatefulWidget {
  const InsertDataScreen({super.key});

  @override
  State<InsertDataScreen> createState() => _InsertDataScreenState();
}

class _InsertDataScreenState extends State<InsertDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fnameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressControler = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _fnameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _addressControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Insert Data'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 4,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FetchDataScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Fetch Data', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10),
              CustomTextField(
                controller: _nameController,
                labelText: 'Name',
                hintText: 'Enter your name',
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _fnameController,
                labelText: 'Father Name',
                hintText: 'Enter father name',
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter father name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                labelText: 'Age',
                hintText: 'Enter your age',
                prefixIcon: Icons.calendar_today,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter age';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _addressControler,
                labelText: 'Address',
                hintText: 'Enter your address',
                prefixIcon: Icons.location_on_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      final nav = Navigator.of(context);
                      try {
                        String userId = FirebaseAuth.instance.currentUser!.uid;
                        await FirebaseFirestore.instance
                            .collection(userId)
                            .add({
                              'name': _nameController.text.trim(),
                              'fname': _fnameController.text.trim(),
                              'age': _ageController.text.trim(),
                              'address': _addressControler.text.trim(),
                              'timestamp': FieldValue.serverTimestamp(),
                              'userId': userId,
                            });
                        if (!mounted) return;
                        setState(() {
                          isLoading = false;
                        });
                        _nameController.clear();
                        _fnameController.clear();
                        _ageController.clear();
                        _addressControler.clear();
                        _emailController.clear();
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text('Data Inserted Successfully'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        if (nav.canPop()) {
                          nav.pop();
                        }
                      } catch (error) {
                        if (!mounted) return;
                        setState(() {
                          isLoading = false;
                        });
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text(error.toString()),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    'Insert Data',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
