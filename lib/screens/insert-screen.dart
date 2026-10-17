/*

-=>TextButton(){
//insert data intosub collection
docid = DateTime.now().millisecondsSinceEpoch.toString();
 final uid = userCredential.user!.uid;
await FIrebasefirestore.insatnce.collection('users).doc(uid).
('tasks').doc(docid).set({
  'title': _titleController.text.trim(),// textformfiled
  'description': _descriptionController.text.trim(),//textformfield
  'timestamp': FieldValue.serverTimestamp(),//auto --> no need to set textformfiled
  'status': 'pending',//auto 
  'docId': docId,//auto
}
}

*/