import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/Ui/controllers/new_task_controller.dart';
import '../../Style/Colors.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_by_status_count_wrapper_model.dart';
import '../../data/models/task_count_by_status_model.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/NetworkCaller.dart';
import '../../data/utilities/urls.dart';
import '../../widgets/centered_progress_indicator.dart';
import '../../widgets/snack_bar_message.dart';
import '../../widgets/task_item.dart';
import '../../widgets/task_summary_card.dart';

import 'add_new_task_screen.dart';

class NewTaskScreen extends StatefulWidget {
  final String urls;

  const NewTaskScreen({super.key, required this.urls});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTasksInProgress = false;
  bool _getTaskCountByStatusInProgress = false;
  List<TaskModel> newTaskList = [];
  List<TaskCountByStatusModel> taskCountByStatusList = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  @override
  void didUpdateWidget(covariant NewTaskScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.urls != oldWidget.urls) {
      _fetchTasks();
    }
  }

  void _fetchTasks() {
    _getTaskCountByStatus();
    Get.find<NewTaskController>().getNewTasks(widget.urls);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: Column(
          children: [
            _buildSummarySection(),
            const SizedBox(height: 8),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _fetchTasks();
                },
                // child: Visibility(
                //   visible: !_getNewTasksInProgress,
                //   replacement: const CenteredProgressIndicator(),
                //   child: ListView.builder(
                //     itemCount: newTaskList.length,
                //     itemBuilder: (context, index) {
                //       return TaskItem(
                //         taskModel: newTaskList[index],
                //         onUpdateTask: _fetchTasks,
                //       );
                //     },
                //   ),
                // ),
                child: GetBuilder<NewTaskController>(
                  builder: (newTaskController) {
                    return Visibility(
                      visible: newTaskController.getNewTasksInProgress == false,
                      replacement: const CenteredProgressIndicator(),
                      child: ListView.builder(
                        itemCount: newTaskController.newTaskList.length,
                        itemBuilder: (context, index) {
                          return TaskItem(
                              taskModel: newTaskController.newTaskList[index],
                              onUpdateTask: _fetchTasks);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddButton,
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onTapAddButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Visibility(
      visible: !_getTaskCountByStatusInProgress,
      replacement: const SizedBox(
        height: 100,
        child: CenteredProgressIndicator(),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: taskCountByStatusList.map((e) {
            return TaskSummaryCard(
              title: (e.sId ?? 'Unknown').toUpperCase(),
              count: e.sum.toString(),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _getNewTasks() async {
    setState(() {
      _getNewTasksInProgress = true;
    });
    NetworkResponse response = await NetworkCaller.getRequest(widget.urls);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      setState(() {
        newTaskList = taskListWrapperModel.taskList ?? [];
        _getNewTasksInProgress = false;
      });
    } else {
      setState(() {
        _getNewTasksInProgress = false;
      });
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMessage ?? 'Get new task failed! Try again');
      }
    }
  }

  Future<void> _getTaskCountByStatus() async {
    setState(() {
      _getTaskCountByStatusInProgress = true;
    });
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.taskStatusCount);
    if (response.isSuccess) {
      TaskCountByStatusWrapperModel taskCountByStatusWrapperModel =
          TaskCountByStatusWrapperModel.fromJson(response.responseData);
      setState(() {
        taskCountByStatusList =
            taskCountByStatusWrapperModel.taskCountByStatusList ?? [];
        _getTaskCountByStatusInProgress = false;
      });
    } else {
      setState(() {
        _getTaskCountByStatusInProgress = false;
      });
      if (mounted) {
        showSnackBarMessage(
          context,
          response.errorMessage ?? 'Get task count by status failed! Try again',
        );
      }
    }
  }
}
