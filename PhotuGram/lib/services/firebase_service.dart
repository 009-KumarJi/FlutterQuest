// path: /services/firebase_service.dart

import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String USER_COLLECTION = 'users';
const String POSTS_COLLECTION = 'posts';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Map? currentUser;

  FirebaseService();

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required DateTime dob,
    required File image,
  }) async {
    try {
      UserCredential _userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String _userID = _userCredential.user!.uid;
      String _filename = Timestamp.now().microsecondsSinceEpoch.toString() +
          p.extension(image.path);
      UploadTask _task = _storage
          .ref('images/$_userID/$_filename')
          .putFile(image);
      TaskSnapshot _snapshot = await _task;
      String _downloadURL = await _snapshot.ref.getDownloadURL();
      await _db.collection(USER_COLLECTION).doc(_userID).set({
        'name': name,
        'email': email,
        'image': _downloadURL,
        'dob': DateFormat('dd/MM/yyyy').format(dob),
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (_userCredential.user != null) {
        currentUser = await getUserData(uid: _userCredential.user!.uid);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map> getUserData({required String uid}) async {
    DocumentSnapshot _doc =
        await _db.collection(USER_COLLECTION).doc(uid).get();
    return _doc.data() as Map;
  }

  Stream<QuerySnapshot> getLatestPosts() {
    return _db
        .collection(POSTS_COLLECTION)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getPostsByUser() {
    String _userID = _auth.currentUser!.uid;
    return _db
        .collection(POSTS_COLLECTION)
        .where('userID', isEqualTo: _userID)
        .snapshots();
  }

  Future<void> logout() async {
    return _auth.signOut();
  }

  Future<bool> postImage(File _image) async {
    try {
      String _userID = _auth.currentUser!.uid;

      String _fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
          p.extension(_image.path);

      UploadTask _task = _storage
          .ref('images/$_userID/$_fileName')
          .putFile(_image);
      TaskSnapshot _snapshot = await _task;
      String _downloadURL = await _snapshot.ref.getDownloadURL();
      await _db.collection(POSTS_COLLECTION).add({
        'userID': _userID,
        'timestamp': Timestamp.now(),
        'image': _downloadURL,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
