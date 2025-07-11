
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/utils/locator.dart';
import 'package:sosyal_ag/view_models/user_view_model.dart';

class Init extends ChangeNotifier{

  UserModel? _user = locator<UserModel>();

  UserModel? get user => _user;

  set user(UserModel? value) {
    _user = value;
    notifyListeners();
  }

  // Bu değişkeni navigator işlemlerinde pop olurken 
  // SplashScreen çalışmasın diye InitRoute'ta kullanıyoruz.
  bool isFirstInit = true;

  Future<void> start(BuildContext context) async{
   
   if (context.mounted) {
    await getCurrentUserAllData(context);
   }
    if (isFirstInit) {
      await Future.delayed(const Duration(seconds: 3));
    }
   isFirstInit = false;
   
  }


  Future<UserModel?> getCurrentUserAllData(BuildContext context) async {

    UserViewModel userViewModel = Provider.of<UserViewModel>(context, listen: false);

    // Burada uygulama açılırken locator ile uygulamanın her yerinde çağırıp kullanacağımız 
    // singleton UserModel ataması yapıyoruz.
    // UserViewModel'de zaten hata yakalandığı için try-catch yapılmadı.
    user = await userViewModel.getCurrentUserAllData(context); 
    
    return user;
  }



}
