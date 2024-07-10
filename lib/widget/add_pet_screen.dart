import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pethhealth/components/applocal.dart';
import 'package:pethhealth/constant/color.dart';

class AddPetScreen extends StatefulWidget {
  @override
  _AddPetScreenState createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  File? _imageFile;
  bool _uploading = false; // Track whether image is being uploaded
  //String indeximage ='image';

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadPet() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _uploading = true; // Set uploading status to true
      });

      final User? user = FirebaseAuth.instance.currentUser;

      final petData = {
        'name': _nameController.text.trim(),
        'owner_email': user!.email,
      };

      if (_imageFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('pet_images')
            .child('${_nameController.text}_pet.jpg');

        await ref.putFile(_imageFile!);

        final imageUrl = await ref.getDownloadURL();
        petData['image_url'] = imageUrl;
      }

      await FirebaseFirestore.instance.collection('pets').add(petData);

      setState(() {
        _uploading = false; // Set uploading status to false
      });

      Navigator.pop(context); // Return to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getLang(context, "addpet"),style: TextStyle(fontSize: 18.0),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _imageFile != null
                        ? Image.file(_imageFile!, fit: BoxFit.cover)
                        : Icon(Icons.add_photo_alternate,
                            size: 50, color: Colors.grey),
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: getLang(context, "namepet"),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return getLang(context, 'no1');
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Container(width: 180.0,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(mainColor)),
                    onPressed: _uploading ? null : _uploadPet, // Disable button if uploading
                    child: _uploading
                        ? CircularProgressIndicator(color: Colors.white,) // Show ProgressIndicator if uploading
                        : Text(getLang(context, "addpet"),style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
