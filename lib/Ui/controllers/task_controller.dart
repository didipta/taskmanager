import 'package:get/get.dart';
import 'package:taskmanager/data/utilities/urls.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/NetworkCaller.dart';

class TaskController extends GetxController {
  bool _getNewTasksInProgress = false;
  bool _addnewTasksInProgress = false;
  String _errorMessage = '';
  List<TaskModel> _taskList = [];
  String _adderrorMessage = '';

  bool get getNewTasksInProgress => _getNewTasksInProgress;
  bool get addNewTasksInProgress => _addnewTasksInProgress;

  List<TaskModel> get newTaskList => _taskList;

  String get errorMessage => _errorMessage;
  String get adderrorMessage => _adderrorMessage;

  Future<bool> getNewTasks(Url) async {
    bool isSuccess = false;
    _getNewTasksInProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(Url);
    print(response);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);

      _taskList = taskListWrapperModel.taskList ?? [];
    } else {
      _errorMessage = response.errorMessage ?? 'Get new task failed! Try again';
    }

    _getNewTasksInProgress = false;
    update();

    return isSuccess;
  }

  Future<bool> addNewtask(String description, String title) async {
    bool isSuccess = false;
    _addnewTasksInProgress = true;
    update();

    Map<String, dynamic> requestData = {
      "title": title,
      "description": description,
      "status": "New",
    };

    final NetworkResponse response =
        await NetworkCaller.postRequest(Urls.createTask, body: requestData);
    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _adderrorMessage = response.errorMessage ?? 'create task fail';
    }

    _addnewTasksInProgress = false;
    update();

    return isSuccess;
  }

  Future<bool> updatestatus(String id,String status) async {
    bool isSuccess = false;

    update();

    final NetworkResponse response =
        await NetworkCaller.getRequest(Urls.updateTaskStatus(id!,status!));
    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'update status fail';
    }
    update();

    return isSuccess;
  }
  Future<bool> deletetask(String id) async {
    bool isSuccess = false;

    update();

    final NetworkResponse response =
        await NetworkCaller.getRequest(Urls.deleteTask(id));
    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'update status fail';
    }
    update();

    return isSuccess;
  }
}
