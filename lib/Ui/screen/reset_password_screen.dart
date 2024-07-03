import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/Ui/screen/sign_in_screen.dart';

import '../../Style/Colors.dart';
import '../../data/models/network_response.dart';
import '../../data/network_caller/NetworkCaller.dart';
import '../../data/utilities/urls.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/snack_bar_message.dart';


class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  ResetPasswordScreen({super.key, required this.email, required this.otp});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    'Set Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Minimum length of password should be more than 6 letters and, combination of numbers and letters',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _passwordTEController,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    decoration:
                        const InputDecoration(hintText: 'Confirm Password'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _onTapConfirmButton,
                    child: const Text('Confirm'),
                  ),
                  const SizedBox(height: 36),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                        ),
                        text: "Haven account? ",
                        children: [
                          TextSpan(
                            text: 'Sign in',
                            style: const TextStyle(color: AppColors.themeColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _onTapSignInButton,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
          (route) => false,
    );
  }

  void _onTapConfirmButton() async {
   if(_passwordTEController.text.trim()==_confirmPasswordTEController.text.trim()){
     Map<String, dynamic> requestData = {
       'email': widget.email,
       "OTP":widget.otp,
       'password': _confirmPasswordTEController.text.trim(),
     };

     NetworkResponse response =
     await NetworkCaller.postRequest(Urls.RecoverResetPass,body:requestData);


     if (response.isSuccess) {
       if(response.responseData["status"]=="fail"){
         showSnackBarMessage(context,response.responseData["data"]);
       }
       else{


         Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => SignInScreen()),
         );
       }



     } else {
       if (mounted) {
         showSnackBarMessage(
           context,
           response.errorMessage ?? 'Get task count by status failed! Try again',
         );
       }
     }
   }
   else{
     showSnackBarMessage(context,"Password not match");
   }

  }

  @override
  void dispose() {
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
