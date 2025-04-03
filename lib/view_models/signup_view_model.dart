import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/view_models/user_view_model.dart';

class SignupViewModel extends ChangeNotifier {
  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // Form validation states
  String? nameError;
  String? emailError;
  String? passwordError;
  bool isLoading = false;
  bool obscurePassword = true;
  
  // Form validation methods
  bool validateName() {
    if (nameController.text.isEmpty) {
      nameError = 'Ad Soyad alanı boş bırakılamaz';
      notifyListeners();
      return false;
    } else if (nameController.text.length < 3) {
      nameError = 'Ad Soyad en az 3 karakter olmalıdır';
      notifyListeners();
      return false;
    } else {
      nameError = null;
      notifyListeners();
      return true;
    }
  }
  
  bool validateEmail() {
    if (emailController.text.isEmpty) {
      emailError = 'E-posta alanı boş bırakılamaz';
      notifyListeners();
      return false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text)) {
      emailError = 'Geçerli bir e-posta adresi giriniz';
      notifyListeners();
      return false;
    } else {
      emailError = null;
      notifyListeners();
      return true;
    }
  }
  
  bool validatePassword() {
    if (passwordController.text.isEmpty) {
      passwordError = 'Şifre alanı boş bırakılamaz';
      notifyListeners();
      return false;
    } else if (passwordController.text.length < 6) {
      passwordError = 'Şifre en az 6 karakter olmalıdır';
      notifyListeners();
      return false;
    } else {
      passwordError = null;
      notifyListeners();
      return true;
    }
  }
  
  bool validateForm() {
    return validateName() && validateEmail() && validatePassword();
  }
  
  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }
  
  // Signup method
  Future<void> signup(BuildContext context) async {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context, listen: false);
     isLoading = true;
    notifyListeners();


    if (validateForm()) {
      try {
    
      
      print("validdate çalıştı");
      await userViewModel.createUserWithEmailAndPassword(emailController.text, passwordController.text, nameController.text, context);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("ERROR on SignupViewModel: $e");
      isLoading = false;
      notifyListeners();
    }
      
    } else {
      isLoading = false;
    }
    
   
  }
  
  // Reset form
  void resetForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    nameError = null;
    emailError = null;
    passwordError = null;
    isLoading = false;
    notifyListeners();
  }
  
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}