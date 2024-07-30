import 'package:get/get.dart';
import 'package:taskmanager/Ui/controllers/Sign_up_controller.dart';
import 'package:taskmanager/Ui/controllers/new_task_controller.dart';
import 'package:taskmanager/Ui/controllers/sign_in_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut(()=>SignInController());
   Get.lazyPut(()=>SignUpController());
   Get.lazyPut(()=>NewTaskController());
  }

}