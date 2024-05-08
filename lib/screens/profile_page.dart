
/*
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../model/profile.dart';
import '../model/users.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.profiles}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
  final List<Profile> profiles;
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  final picker = ImagePicker();

  Future<void> _uploadImage() async {
    try {
      if (_profileImage == null) {
        throw Exception('No image selected.');
      }

      var stream = http.ByteStream(_profileImage!.openRead());
      var length = await _profileImage!.length();

      var uri = Uri.parse('http://127.0.0.1/phalc/upload-image'); 
      var request = http.MultipartRequest("POST", uri);
      
    
      request.files.add(await http.MultipartFile.fromPath("file", _profileImage!.path));
      var response = await request.send();

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to upload image. Status Code: ${response.statusCode}');
      }

      String reply = await response.stream.transform(utf8.decoder).join();
      print(reply);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully.'))
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $error'))
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 73, 4),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(children: [
              Text(
                "Profile Page",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ]),
            Row(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage(profiles: profile)),
                        );
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 12,
                        child: Icon(Icons.person, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 2.0),
                    Text(
                      user.userfirstName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20.0),
            Container(
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color.fromARGB(255, 44, 219, 138), width: 2.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                 image: _profileImage == null
  //? const AssetImage('assets/images/default-profile-pic.png') as ImageProvider<Object>
  ? const AssetImage('assets/images/A7.jpg') as ImageProvider<Object>
  : FileImage(_profileImage!),

                ),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6.0, bottom: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Choose Image Source",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                ElevatedButton(
                                  onPressed: () {
                                    _pickImage(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Take Photo'),
                                ),
                                const SizedBox(height: 8.0),
                                ElevatedButton(
                                  onPressed: () {
                                    _pickImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Choose from Gallery'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: ClipOval(
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(4.0),
                        child: const Icon(Icons.camera_alt, size: 18.0, color: Color.fromARGB(255, 225, 228, 226)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6.0),
            ElevatedButton(
              onPressed: _profileImage != null ? _uploadImage : null,
              child: const Text("Upload"),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Icon(Icons.person, color: Color.fromARGB(255, 2, 126, 95)),
                Text(
                  user.useruserName,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Icon(Icons.phone, color: Color.fromARGB(255, 2, 126, 95)),
                Text(
                  user.userphoneNumber,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Username'),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Phone Number'),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              // Add logic here to save the edited details
                              // For example, you can update the state with setState
                              // or call a function to update the user's details
                              // Once done, you can close the modal bottom sheet
                              Navigator.pop(context); // Close the modal bottom sheet
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Row(
                children: [
                  Icon(Icons.edit, color: Color.fromARGB(255, 2, 126, 95)),
                  Text(
                    " Edit profile",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/



import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../model/profile.dart';
import '../model/users.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.profiles}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
  final List<Profile> profiles;
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  final picker = ImagePicker();

  Future<void> _uploadImage() async {
    try {
      if (_profileImage == null) {
        throw Exception('No image selected.');
      }

      var stream = http.ByteStream(_profileImage!.openRead());
      var length = await _profileImage!.length();

      var uri = Uri.parse('http://127.0.0.1/phalc/upload-image');
      var request = http.MultipartRequest("POST", uri);
      
      request.files.add(await http.MultipartFile.fromPath("file", _profileImage!.path));
      var response = await request.send();

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to upload image. Status Code: ${response.statusCode}');
      }

      String reply = await response.stream.transform(utf8.decoder).join();
      print(reply);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully.'))
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $error'))
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 73, 4),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(children: [
              Text(
                "Profile Page",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ]),
            Row(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage(profiles: profile)),
                        );
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 12,
                        child: Icon(Icons.person, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 2.0),
                    Text(
                      user.userfirstName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20.0),
            Container(
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color.fromARGB(255, 44, 219, 138), width: 2.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                 image: _profileImage == null
                  ? const AssetImage('assets/images/A1.jpg') as ImageProvider<Object>
                  : FileImage(_profileImage!),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6.0, bottom: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Choose Image Source",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                ElevatedButton(
                                  onPressed: () {
                                    _pickImage(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Take Photo'),
                                ),
                                const SizedBox(height: 8.0),
                                ElevatedButton(
                                  onPressed: () {
                                    _pickImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Choose from Gallery'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: ClipOval(
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(4.0),
                        child: const Icon(Icons.camera_alt, size: 18.0, color: Color.fromARGB(255, 225, 228, 226)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6.0),
            ElevatedButton(
              onPressed: _profileImage != null ? _uploadImage : null,
              child: const Text("Upload"),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Icon(Icons.person, color: Color.fromARGB(255, 2, 126, 95)),
                Text(
                  user.useruserName,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Icon(Icons.phone, color: Color.fromARGB(255, 2, 126, 95)),
                Text(
                  user.userphoneNumber,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Username'),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Phone Number'),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              // Add logic here to save the edited details
                              // For example, you can update the state with setState
                              // or call a function to update the user's details
                              // Once done, you can close the modal bottom sheet
                              Navigator.pop(context); // Close the modal bottom sheet
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Row(
                children: [
                  Icon(Icons.edit, color: Color.fromARGB(255, 2, 126, 95)),
                  Text(
                    " Edit profile",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
