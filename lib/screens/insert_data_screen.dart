import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/screens/fetch_data_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Components/Textfield.dart';
// Reusable TextField Import

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
  final _addresscontroller = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _fnameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _addresscontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Insert Data'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FetchDataScreen()),
              );
            },
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Name Field (Reusable)
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
              const SizedBox(height: 16),

              // Father's Name Field (Reusable)
              CustomTextField(
                controller: _fnameController,
                labelText: "Father's Name",
                hintText: "Enter father's name",
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter father's name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Age Field (Reusable)
              CustomTextField(
                controller: _ageController,
                labelText: 'Age',
                hintText: 'Enter your age',
                prefixIcon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field (Reusable)
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
              const SizedBox(height: 16),

              // Address Field (Reusable)
              CustomTextField(
                controller: _addresscontroller,
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
              const SizedBox(height: 24),

              // Submit Button
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                width: double.infinity,
                height: 50,
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
                          'email': _emailController.text.trim(),
                          'address': _addresscontroller.text.trim(),
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
                        _emailController.clear();
                        _addresscontroller.clear();

                        scaffoldMessenger.showSnackBar(
                          const SnackBar(
                            content: Text('Data Inserted Successfully!'),
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
                  child: const Text(
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