import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hw/components/custom_form_field.dart';
import 'package:flutter_hw/consts.dart';
import 'package:flutter_hw/models/profile.dart';
import 'package:flutter_hw/services/auth_service.dart';
import 'package:flutter_hw/services/firestore_service.dart';
import 'package:flutter_hw/services/media_service.dart';
import 'package:flutter_hw/services/navigation_service.dart';
import 'package:flutter_hw/services/storage_service.dart';
import 'package:flutter_hw/services/toast_service.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _registerFormKey = GlobalKey();

  late AuthService _authService;
  late NavigationService _navigationService;
  late MediaService _mediaService;
  late ToastService _toastService;
  late StorageService _storageService;
  late FirestoreService _firestoreService;

  String? name, email, password;
  File? selectedImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _mediaService = _getIt.get<MediaService>();
    _toastService = _getIt.get<ToastService>();
    _storageService = _getIt.get<StorageService>();
    _firestoreService = _getIt.get<FirestoreService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 20.0,
      ),
      child: Column(
        children: [
          _headerText(),
          if (isLoading) ...{
            const Center(
              child: CircularProgressIndicator(),
            )
          } else ...{
            _registerForm(),
          },
          _loginText(),
        ],
      ),
    ));
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's get started",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            "Hello again, you've been missed",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
          )
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.6,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.05),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profilePicSelection(),
            CustomFormField(
              label: 'Name',
              onSaved: (value) {
                setState(() {
                  email = name;
                });
              },
              height: MediaQuery.sizeOf(context).height * 0.1,
            ),
            CustomFormField(
              label: 'Email',
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
              height: MediaQuery.sizeOf(context).height * 0.1,
              validationRegex: emailValidationRegex,
            ),
            CustomFormField(
              label: 'Password',
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
              height: MediaQuery.sizeOf(context).height * 0.1,
              validationRegex: passwordValidationRegex,
              obscureText: true,
            ),
            _registerButton()
          ],
        ),
      ),
    );
  }

  Widget _profilePicSelection() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
          radius: MediaQuery.of(context).size.width * 0.15,
          backgroundImage: selectedImage != null
              ? FileImage(selectedImage!)
              : null // : NetworkImage() as ImageProvider,
          ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          try {
            if (_registerFormKey.currentState?.validate() ?? false) {
              _registerFormKey.currentState?.save();
              bool result = await _authService.signUp(email!, password!);
              if (result) {
                String? profilePicUrl = await _storageService.uploadProfilePic(
                  file: selectedImage!,
                  uid: _authService.user!.uid,
                );
                if (profilePicUrl != null) {
                  await _firestoreService.createUserProfile(
                    userProfile: Profile(
                      uid: _authService.user!.uid,
                      name: name!,
                      email: email!,
                      profilePicUrl: profilePicUrl,
                    ),
                  );
                  _toastService.showToast(
                    text: 'Registration successful!',
                    icon: Icons.check,
                  );
                } else {
                  throw Exception('Failed to upload profile picture');
                }
                // _navigationService.goBack();
                _navigationService.pushReplacementNamed("/");
              } else {
                throw Exception('Unable to register user');
              }
            }
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
            _toastService.showToast(
              text: 'Failed to register. Please try again.',
              icon: Icons.error,
            );
          } finally {
            setState(() {
              isLoading = false;
            });
          }
        },
        color: Theme.of(context).colorScheme.primary,
        child: const Text(
          "Register",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _loginText() {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text("Already have an account?"),
          GestureDetector(
            onTap: () {
              _navigationService.goBack();
            },
            child: const Text(
              "Log in",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          )
        ],
      ),
    );
  }
}
