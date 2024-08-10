import 'package:get/get.dart';

import '../../data/models/login_model.dart';
import '../../data/models/network_response.dart';
import '../../data/network_caller/NetworkCaller.dart';
import '../../data/utilities/urls.dart';
import '../../widgets/snack_bar_message.dart';
import 'auth_controller.dart';


class SignInController extends GetxController {
  bool _signInApiInProgress = false;
  String _errorMessage = '';

  bool get signInApiInProgress => _signInApiInProgress;

  String get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async {
    bool isSuccess = false;
    _signInApiInProgress = true;
    update();

    Map<String, dynamic> requestData = {
      'email': email,
      'password': password,
    };

    final NetworkResponse response =
        await NetworkCaller.postRequest(Urls.login, body: requestData);
    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveUserAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.userModel!);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Login failed! Try again';
    }

    _signInApiInProgress = false;
    update();

    return isSuccess;
  }

  Future<bool> emailvarification(String email,context) async {
    bool isSuccess = false;


    final NetworkResponse response =
    await NetworkCaller.getRequest(Urls.emailvarification(email));
    if (response.isSuccess) {
      print(response.responseData["status"]);

      if(response.responseData["status"]=="fail"){
        showSnackBarMessage(context,response.responseData["data"]);
      }
      else{
        isSuccess = true;
      }
    } else {
      _errorMessage = response.errorMessage ?? " ";
    }

    return isSuccess;
  }
}
