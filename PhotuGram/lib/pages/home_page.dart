// path: /pages/home_page.dart

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:photugram/pages/feed_page.dart';
import 'package:photugram/pages/profile_page.dart';
import 'package:photugram/services/firebase_service.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  bool _isPosting = false;
  FirebaseService? _firebaseService;
  final List<Widget> _pages = [FeedPage(), ProfilePage()];

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("PhotuGram"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo_rounded),
            onPressed: _postImage,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0),
            child: IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: _logout,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_isPosting) const LinearProgressIndicator(),
          _pages[_currentPage],
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  void _logout() async {
    await _firebaseService!.logout();
    Navigator.popAndPushNamed(context, 'login');
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentPage,
      onTap: (idx) => setState(() => _currentPage = idx),
      items: const [
        BottomNavigationBarItem(
          label: 'Feed',
          icon: Icon(Icons.feed_rounded),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(Icons.account_circle_rounded),
        ),
      ],
    );
  }

  void _postImage() async {
    try {
      FilePickerResult? _result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (_result != null) {
        File _image = File(_result.files.first.path!);
        setState(() => _isPosting = true);
        await _firebaseService!.postImage(_image);
        setState(() => _isPosting = false);
      }
    } catch (e) {
      showErrorDialog(context);
    }
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          backgroundColor: Colors.red,
          title: Text(
            'Upload Failed',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          content: Text('Please try again.'),
        );
      },
    );
    Future.delayed(const Duration(seconds: 2),
        () => Navigator.popAndPushNamed(context, 'home'));
  }
}
