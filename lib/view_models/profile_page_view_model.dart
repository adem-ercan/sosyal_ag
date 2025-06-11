import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sosyal_ag/repositories/repository.dart';
import 'package:sosyal_ag/utils/locator.dart';



class ProfilePageViewModel extends ChangeNotifier {

  //VARIABLES
  File? _profilePhotoImages;
  String? _fullName;
  String? _bio;
  String? _userName;
  

  Repository _repository =locator<Repository>();
  final ImagePicker _picker = ImagePicker();
  final formKey = GlobalKey<FormState>();




  //GETTERS
  File? get profilePhotoImages => _profilePhotoImages;
  String? get userName => _userName;
  String? get fullName => _fullName;
  String? get bio => _bio;


  //SETTERS
  set userName(value){
    _userName = value;
    notifyListeners();
  }

  set bio(value){
    _bio = value;
    notifyListeners();
  }

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

  Future<void> save() async{
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      print("isim: $_bio kullanıcı adı: $_userName bio: $_bio");

      try {
          await _repository.saveProfileEdit(_fullName ?? '', userName ?? '', _bio ?? '', image: _profilePhotoImages);

      } catch (e) {
        print('Profil kaydetme hatası: $e');

      }
  }

  }
} 