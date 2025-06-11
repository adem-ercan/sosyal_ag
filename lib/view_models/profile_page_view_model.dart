import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



class ProfilePageViewModel extends ChangeNotifier {

  //VARIABLES
  File? _profilePhotoImages;
  String? _fullName;
  


  final ImagePicker _picker = ImagePicker();
  final formKey = GlobalKey<FormState>();




  //GETTERS
  File? get profilePhotoImages => _profilePhotoImages;
  String? get fullName => _fullName;


  //SETTERS
  set fullName(value){
    _fullName = value;
    notifyListeners();
  }

  set profilePhotoImages(value){
    _profilePhotoImages = value;
    notifyListeners();
  }

  //METHODS
   Future<void> mediaPick() async {
    try {
      final XFile? xFile = await _picker.pickImage(source: ImageSource.gallery);

      if (xFile != null) {
        profilePhotoImages = File(xFile.path);
      }
    } catch (e) {
      print('Resim seçme hatası: $e');
    }
  }


} 