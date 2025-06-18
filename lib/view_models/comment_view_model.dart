import 'package:flutter/material.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/repositories/repository.dart';
import 'package:sosyal_ag/utils/locator.dart';



class CommentViewModel extends ChangeNotifier { 

  final Repository _repository = locator<Repository>();

 

}