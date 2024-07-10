import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pethhealth/components/applocal.dart';
import 'dart:io';

import 'package:pethhealth/constant/color.dart';
import 'package:pethhealth/screen/auth/login_screen.dart';
import 'package:pethhealth/screen/home/profile/order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Placeholder until user data is fetched
        } else {
          if (snapshot.hasData) {
            return ProfileDetails(user: snapshot.data!);
          } else {
            return Text(
                'User not logged in'); // Handle case where user is not logged in
          }
        }
      },
    );
  }
}

class ProfileDetails extends StatefulWidget {
  final User user;

  const ProfileDetails({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  void refreshProfile() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.user.uid)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(); // Placeholder until user data is fetched
                } else {
                  if (snapshot.hasData) {
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return ProfileHeader(
                      avatar: NetworkImage(userData['profileImageUrl'] ??
                          ""), // Update with user's profile image
                      coverImage: NetworkImage(userData['profileImageUrl'] ??
                          ""), // Update with user's cover image
                      title: userData['username'] ?? "Name Not Available",
                      //subtitle: userData['email'] ?? "Email Not Available",
                      actions: <Widget>[
                        MaterialButton(
                          color: Colors.white,
                          shape: const CircleBorder(),
                          elevation: 0,
                          child: const Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return EditProfileDialog(
                                  userId: widget.user.uid,
                                  refreshProfile: refreshProfile,
                                );
                              },
                            );
                          },
                        )
                      ],
                    );
                  } else {
                    return Text('User data not found');
                  }
                }
              },
            ),
            const SizedBox(height: 10.0),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.user.uid)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(); // Placeholder until user data is fetched
                } else {
                  if (snapshot.hasData) {
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return UserInfo(
                      email: userData['email'] ?? "Email Not Available",
                      phone: userData['phone'] ?? "Number Not Available",
                      location: userData['city'] ?? "location Not Available",
                    );
                  } else {
                    return Text('User data not found');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfo extends StatefulWidget {
  final String email;
  final String? phone;
  final String? location;

  const UserInfo({Key? key, required this.email, this.phone, this.location})
      : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  bool _isArabic = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            alignment: Alignment.center,
            child:  Text(
              getLang(context, "info"),
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...ListTile.divideTiles(
                        color: Colors.grey,
                        tiles: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            leading: Icon(Icons.my_location),
                            title: Text(getLang(context, "location")),
                            subtitle: Text(widget.location!),
                          ),
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text(getLang(context, "email")),
                            subtitle: Text(widget.email), // Display email here
                          ),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text(getLang(context,"phone")),
                            subtitle: Text(widget.phone!),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderHistoryScreen(),));
                            },
                            child: ListTile(
                              leading: Icon(Icons.history),
                              subtitle: ListTile(
                                
                                title: Text(getLang(context, "history")),
                                subtitle:Text(getLang(context, "history_text")),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                  (route) => false);
                            },
                            child: ListTile(
                              leading: Icon(Icons.exit_to_app_outlined),
                              title: Text(getLang(context, "signout")),
                              subtitle: Text(getLang(context, "signout_text")),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> coverImage;
  final ImageProvider<dynamic> avatar;
  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  const ProfileHeader({
    Key? key,
    required this.coverImage,
    required this.avatar,
    required this.title,
    this.subtitle,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: coverImage as ImageProvider<Object>, fit: BoxFit.cover),
          ),
        ),
        Ink(
          height: 200,
          decoration: const BoxDecoration(
            color: Colors.black38,
          ),
        ),
        if (actions != null)
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            ),
          ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 120),
          child: Column(
            children: <Widget>[
              Avatar(
                image: avatar,
                radius: 70,
                backgroundColor: Colors.white,
                borderColor: Colors.grey.shade300,
                borderWidth: 4.0,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  final ImageProvider<dynamic> image;
  final Color borderColor;
  final Color? backgroundColor;
  final double radius;
  final double borderWidth;

  const Avatar({
    Key? key,
    required this.image,
    this.borderColor = Colors.grey,
    this.backgroundColor,
    this.radius = 30,
    this.borderWidth = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWidth,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        child: CircleAvatar(
          radius: radius - borderWidth,
          backgroundColor: Colors.grey,
          // child: Icon(
          //   Icons.camera_alt_outlined,
          //   size: 75,
          //   color: Colors.white,
          // ), // Change the background color to yellow
          backgroundImage: image as ImageProvider<Object>?,
        ),
      ),
    );
  }
}

class EditProfileDialog extends StatefulWidget {
  final String userId;
  final Function refreshProfile;

  const EditProfileDialog(
      {Key? key, required this.userId, required this.refreshProfile})
      : super(key: key);

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _nameController;
  File? _image;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(getLang(context, "editprofile")),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: getLang(context, "editname")),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                // Pick image from gallery
                final picker = ImagePicker();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _image = File(pickedFile.path);
                  });
                }
              },
              label: Text(getLang(context, "editimage")),
              icon: Icon(Icons.camera_alt_outlined),
            ),
            if (_image != null) // Display the selected image if available
              Image.file(
                _image!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(getLang(context, "cancel")),
        ),
        ElevatedButton(
          onPressed: () async {
            // Update name
            final newName = _nameController.text.trim();
            if (newName.isNotEmpty) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.userId)
                  .update({
                'username': newName,
              });
            }

            // Update profile image
            if (_image != null) {
              // Show circular progress indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: mainColor2,
                    ),
                  );
                },
              );

              final storageRef = FirebaseStorage.instance
                  .ref()
                  .child('profile_images')
                  .child('${widget.userId}.jpg');
              await storageRef.putFile(_image!);
              final imageUrl = await storageRef.getDownloadURL();
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.userId)
                  .update({
                'profileImageUrl': imageUrl,
              });

              // Hide circular progress indicator
              Navigator.of(context).pop();
            }

            widget.refreshProfile();

            Navigator.of(context).pop();
          },
          child: Text(getLang(context, "save")),
        ),
      ],
    );
  }
}
