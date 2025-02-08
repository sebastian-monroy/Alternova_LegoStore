import 'package:flutter/material.dart';



class LoginFormProvider extends ChangeNotifier{

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool _isloading = false;
  bool get isloading => _isloading;

  set isLoading (bool value) {
    _isloading = value;
    notifyListeners();
  }


  bool isValidForm(){

    print(formKey.currentState?.validate());

    print('$email - $password');

    return formKey.currentState?.validate() ?? false;
  }

}