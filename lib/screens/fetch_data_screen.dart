import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Components/Textfield.dart';
import 'login_screen.dart';

class FetchDataScreen extends StatefulWidget {
  const FetchDataScreen({super.key});

  @override
  State<FetchDataScreen> createState() => _FetchDataScreenState();
}

class _FetchDataScreenState extends State<FetchDataScreen> {
  // Current user UID for subcollection tree
  String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  String user_name = '';
  String user_image = '';
  bool dataLoading = false;

  // ================= SHOW UPDATE DIALOG =================
  void _showEditDialog(BuildContext context, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    final nameController = TextEditingController(text: data['name']?.toString() ?? '');
    final fnameController = TextEditingController(text: data['fname']?.toString() ?? '');
    final ageController = TextEditingController(text: data['age']?.toString() ?? '');
    final emailController = TextEditingController(text: data['email']?.toString() ?? '');
    final phoneController = TextEditingController(text: data['phone']?.toString() ?? '');
    String? selectedGender = data['gender']?.toString().isNotEmpty == true ? data['gender']?.toString() : null;
    final addressController = TextEditingController(text: data['address']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Center(
                child: Text(
                  'Update Data',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: nameController,
                      labelText: 'Name',
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: fnameController,
                      labelText: "Father's Name",
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: ageController,
                      labelText: 'Age',
                      prefixIcon: Icons.calendar_today,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: emailController,
                      labelText: 'Email',
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: phoneController,
                      labelText: 'Phone',
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        prefixIcon: const Icon(Icons.person_pin),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blue, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      hint: const Text('Select Gender'),
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(value: 'Female', child: Text('Female')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (val) {
                        setDialogState(() {
                          selectedGender = val;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: addressController,
                      labelText: 'Address',
                      prefixIcon: Icons.location_on_outlined,
                    ),
                  ],
                ),
              ),
              actions: [
                // Cancel Button
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Container(
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('Cancel', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                // Update Button in Subcollection
                TextButton(
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    try {
                      // Subcollection update: users -> doc(currentUserId) -> collection('tasks') -> doc(doc.id)
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUserId)
                          .collection('tasks')
                          .doc(doc.id)
                          .update({
                        'name': nameController.text.trim(),
                        'fname': fnameController.text.trim(),
                        'age': ageController.text.trim(),
                        'email': emailController.text.trim(),
                        'phone': phoneController.text.trim(),
                        'gender': selectedGender ?? '',
                        'address': addressController.text.trim(),
                        'updated_at': FieldValue.serverTimestamp(),
                      });

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data updated successfully in subcollection'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error updating data: $e'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('Update', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ================= SHOW DELETE CONFIRMATION DIALOG =================
  void _showDeleteDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(
            child: Text(
              'Delete Data',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this item from subcollection?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            // No Button
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('No', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            // Yes Button: Subcollection delete
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUserId)
                      .collection('tasks')
                      .doc(docId)
                      .delete();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data deleted successfully from subcollection'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error deleting data: $e'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              child: Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('Yes', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _getUserProfile() async {
    dataLoading = true;
    setState(() {});
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (mounted) {
        setState(() {
          user_name = userData.data()?['name'] ?? '';
          user_image = userData.data()?['profile_image'] ?? '';
          dataLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  /*
  Task: Sub collections (Tree structure)
  -> main root --> sub branches
  -> main collection(users) -> doc(userId) -> sub collection('tasks') -> docs -> data
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white24,
            backgroundImage: user_image.isNotEmpty ? NetworkImage(user_image) : null,
            child: user_image.isEmpty ? const Icon(Icons.person, color: Colors.white) : null,
          ),
        ),
        title: Text(
          user_name.isNotEmpty ? 'Welcome, $user_name' : 'Subcollection Data',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),
        ],
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Tree Structure: main collection(users) -> doc(currentUserId) -> sub collection('tasks') -> snapshots
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .collection('tasks')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No Data Found in Subcollection',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>? ?? {};

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      (data['name'] != null && data['name'].toString().isNotEmpty)
                          ? data['name'].toString()[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  title: Text(
                    data['name']?.toString() ?? 'No Name',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (data['fname'] != null && data['fname'].toString().isNotEmpty)
                          Text("Father: ${data['fname']}", style: const TextStyle(fontSize: 13)),
                        if (data['age'] != null && data['age'].toString().isNotEmpty)
                          Text("Age: ${data['age']}", style: const TextStyle(fontSize: 13)),
                        if (data['email'] != null && data['email'].toString().isNotEmpty)
                          Text("Email: ${data['email']}", style: const TextStyle(fontSize: 13)),
                        if (data['phone'] != null && data['phone'].toString().isNotEmpty)
                          Text("Phone: ${data['phone']}", style: const TextStyle(fontSize: 13)),
                        if (data['gender'] != null && data['gender'].toString().isNotEmpty)
                          Text("Gender: ${data['gender']}", style: const TextStyle(fontSize: 13)),
                        if (data['address'] != null && data['address'].toString().isNotEmpty)
                          Text("Address: ${data['address']}", style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit Button
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditDialog(context, doc),
                      ),
                      // Delete Button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteDialog(context, doc.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}