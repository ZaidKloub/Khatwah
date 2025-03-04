import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class MyProfileScreen extends StatefulWidget {
  final String userID;

  MyProfileScreen({required this.userID});

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  bool isEditMode = false;
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController emailController;
  File? _profileImage;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    emailController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.userID)
          .get();
      if (snapshot.exists) {
        var data = snapshot.data();
        setState(() {
          fullNameController.text = data?['FullName'] ?? '';
          emailController.text = data?['Email'] ?? '';
          addressController.text = data?['Address']?? '';
          phoneController.text = data?['Phone']?? '';
          _imageUrl = data?['Profile Image'];
        });
      } else {
        print('Document does not exist!');
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF416C77),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        actions: [
          isEditMode
              ? IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveUserData();
              setState(() {
                isEditMode = false;
              });
            },
          )
              : IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                isEditMode = true;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(
                  child: _profileImage != null
                      ? Image.file(_profileImage!, fit: BoxFit.cover)
                      : _imageUrl != null
                      ? Image.network(_imageUrl!, fit: BoxFit.cover)
                      : Image.asset('assets/placeholder_image.png', fit: BoxFit.cover),
                ),
              ),
              TextButton(
                onPressed: isEditMode ? _getImageFromGallery : null,
                child: Text("Choose Profile Image"),
              ),
              const SizedBox(height: 10),
              buildTextField('Full Name', fullNameController, isEditMode),
              const SizedBox(height: 10),
              buildTextField('Phone', phoneController, isEditMode),
              const SizedBox(height: 10),
              buildTextField('Address', addressController, isEditMode),
              const SizedBox(height: 10),
              buildTextField('Email', emailController, isEditMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, bool isEnabled) {
    return TextField(
      controller: controller,
      enabled: isEnabled,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    try {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedImage != null) {
          _profileImage = File(pickedImage.path);
          _uploadImageToFirebase();
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadImageToFirebase() async {
    if (_profileImage != null) {
      try {
        Reference ref = FirebaseStorage.instance.ref().child('profile_images/${DateTime.now().toString()}');
        UploadTask uploadTask = ref.putFile(_profileImage!);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        setState(() {
          _imageUrl = imageUrl;
        });
      } catch (e) {
        print('Error uploading image to Firebase Storage: $e');
      }
    }
  }

  Future<void> _saveUserData() async {
    try {
      await FirebaseFirestore.instance.collection("Users").doc(widget.userID).update({
        'FullName': fullNameController.text,
        'Phone': phoneController.text,
        'Address': addressController.text,
        'Email': emailController.text,
        'Profile Image': _imageUrl ?? '',
      });
    } catch (e) {
      print('Error saving user data: $e');
    }
  }
}
