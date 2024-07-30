import 'package:get/get.dart';
import 'package:taskmanager/data/models/network_response.dart';

import '../../data/models/login_model.dart';
import '../../data/network_caller/NetworkCaller.dart';
import '../../data/utilities/urls.dart';


class SignUpController extends GetxController{
  bool _signApiInProgress = false;
  String _errorMessage = '';

  bool get signUpApiInProgress => _signApiInProgress;

  String get errorMessage => _errorMessage;

  Future<bool> signUp(String email, String password,String firstName,String lastName,String mobile) async {
    bool isSuccess = false;
    _signApiInProgress = true;
    update();

    Map<String, dynamic> requestData = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
      "photo": ""
    };

    final NetworkResponse response =
    await NetworkCaller.postRequest(Urls.registration, body: requestData);
    if (response.isSuccess) {

      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Sign up fails';
    }

    _signApiInProgress = false;
    update();

    return isSuccess;
  }
}