import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/view_models/user_view_model.dart';

class LoginViewModel extends ChangeNotifier {
  // Form controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // Form validation states
  String? emailError;
  String? passwordError;
  bool isLoading = false;
  bool obscurePassword = true;


  // VARIABLES


  // GETTERS

  // SETTERS
  


  
  // Form validation methods
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
    return validateEmail() && validatePassword();
  }
  
  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }
  
  // Login method
  Future<bool> login(BuildContext context) async {

    UserViewModel userViewModel = Provider.of<UserViewModel>(context, listen: false);

    if (!validateForm()) {
      return false;
    }
    
    isLoading = true;
    notifyListeners();
    
    try {
      // Burada gerçek login işlemi yapılacak
      // Örnek olarak 2 saniyelik bir bekleme ekledim
      //await Future.delayed(const Duration(seconds: 2));
      await userViewModel.signInWithEmailAndPassword(emailController.text, passwordController.text, context);     
      
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      
      print("ERROR on LoginViewModel: $e");
      //notifyListeners();
      return false;
    }
  }


  
  // Reset form
  void resetForm() {
    emailController.clear();
    passwordController.clear();
    emailError = null;
    passwordError = null;
    isLoading = false;
    notifyListeners();
  }
  
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}