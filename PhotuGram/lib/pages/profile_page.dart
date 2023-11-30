// path: /pages/profile_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:photugram/services/firebase_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late double _deviceHeight, _deviceWidth;

  FirebaseService? _firebaseService;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.05,
        vertical: _deviceHeight * 0.05,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _displayImage(),
          _postGridView(),
        ],
      ),
    );
  }

  Widget _displayImage() {
    return Container(
      margin: EdgeInsets.only(
        bottom: _deviceHeight * 0.02,
      ),
      height: _deviceHeight * 0.15,
      width: _deviceHeight * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(55),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            _firebaseService!.currentUser!['image'],
          ),
        ),
      ),
    );
  }

  Widget _postGridView() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firebaseService!.getPostsByUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List _posts = snapshot.data!.docs.map((e) => e.data()).toList();
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemBuilder: (context, index) {
                Map _post = _posts[index];
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        _post['image'],
                      ),
                    ),
                  ),
                );
              },
              itemCount: _posts.length,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrange,
              ),
            );
          }
        },
      ),
    );
  }
}
