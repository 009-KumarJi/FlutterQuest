import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:photugram/services/firebase_service.dart';

class RegisterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage>{
  double? _deviceHeight, _deviceWidth;

  FirebaseService? _firebaseService;

  String? _name, _email, _password;
  final TextEditingController _dateController = TextEditingController();
  DateTime? selectedDate;

  File? _image;

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth! * 0.05,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _titleWidget(),
                _displayPictureWidget(),
                _registerationForm(),
                _registerButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerationForm(){
    return Container(
      height: _deviceHeight! * 0.30,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _nameTextField(),
            _emailTextField(),
            _DOBTextField(),
            _passTextField(),
          ],
        ),
      ),
    );
  }

  Widget _nameTextField(){
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Name...',
      ),
      validator: (_val) => _val!.length > 0 ? null : 'Please Enter a Name',
      onSaved: (_val) => setState(() {
        _name = _val;
      }),
    );
  }

  Widget _titleWidget(){
    return const Text(
      'PhotuGram',
      style: TextStyle(
        color: Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _registerButton(){
    return MaterialButton(
      onPressed: _registerUser,
      minWidth: _deviceWidth! *0.70,
      height: _deviceHeight! * 0.06,
      color: Colors.redAccent,
      child: const Text(
        "Register",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 25,
        ),
      ),
    );
  }

  Widget _emailTextField(){
    return TextFormField(
      decoration: const InputDecoration(
        hintText: "Email...",
      ),
      onSaved: (_value){
        setState(() {
          _email = _value;
        });
      },
      validator: (_value){
        bool isValidEmail = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(_value!);
        return isValidEmail ? null : "Please Enter a Valid Email...";
      },
    );
  }

  Widget _passTextField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
        hintText: "Password...",
      ),
      onSaved: (_value) {
        _password = _value;
      },
      validator: (value) {
        if (value!.isEmpty) return 'Password is required';
        if (value.length < 8) return 'Password must be at least 8 characters long';
        return null;
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Widget _DOBTextField() {
    return TextFormField(
      onTap: () {
        _selectDate(context);
      },
      decoration: const InputDecoration(
        hintText: 'Date of Birth',
      ),
      readOnly: true,
      controller: _dateController,
      validator: (_value) => _dateController.text.isEmpty ? 'Please select your Date of Birth' : null,
    );
  }


  Widget _displayPictureWidget() {
    var _imageProvider = _image != null
        ? FileImage(_image!)
        : AssetImage('assets/images/upload_img.jpg');

    return GestureDetector(
      onTap: () {
        FilePicker.platform.pickFiles(type: FileType.image).then((_result) {
          if (_result != null && _result.files.isNotEmpty) {
            setState(() {
              _image = File(_result.files.first.path!); // Assigning the selected file
            });
          }
        }).catchError((error) {
          print("Error picking image: $error");
        });
      },
      child: Container(
        height: _deviceHeight! * 0.15,
        width: _deviceHeight! * 0.15,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: _imageProvider as ImageProvider,
          ),
        ),
      ),
    );
  }

  void _registerUser() async {
    if (_registerFormKey.currentState!.validate()){ // to invoke validator
      _registerFormKey.currentState!.save(); // to invoke onSaved
      print('$_name, $_email, $selectedDate');
      bool _result = await _firebaseService!.registerUser(name: _name!, email: _email!, password: _password!, dob: selectedDate!, image: _image!);
      if (_result) {
        print('registered');
        Navigator.popAndPushNamed(context, 'login');
      }
    }
  }
}

