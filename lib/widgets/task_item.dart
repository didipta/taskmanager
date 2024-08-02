import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:taskmanager/widgets/snack_bar_message.dart';

import '../Ui/controllers/task_controller.dart';
import '../data/models/network_response.dart';
import '../data/models/task_model.dart';
import '../data/network_caller/NetworkCaller.dart';
import '../data/utilities/urls.dart';
import 'centered_progress_indicator.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.taskModel,
    required this.onUpdateTask,
  });

  final TaskModel taskModel;
  final VoidCallback onUpdateTask;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool _deleteInProgress = false;
  bool _editInProgress = false;
  String dropdownValue = '';
  List<String> statusList = ['New', 'Progress', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.taskModel.status!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        title: Text(widget.taskModel.title ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskModel.description ?? ''),
            Text(
              'Date: ${widget.taskModel.createdDate}',
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(widget.taskModel.status ?? 'New'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                ),
                ButtonBar(
                  children: [
                    Visibility(
                      visible: _deleteInProgress == false,
                      replacement: const CenteredProgressIndicator(),
                      child: IconButton(
                        onPressed: ()  async {
                          _deleteInProgress = true;
                          final TaskController updatestatus =
                          Get.find<TaskController>();
                          final bool result =
                          await updatestatus.deletetask(
                              widget.taskModel.sId!);
                          if (result) {
                            widget.onUpdateTask();
                            _deleteInProgress = false;
                            showSnackBarMessage(
                              context,
                              'Status delete',
                            );
                          } else {
                            if (mounted) {
                              showSnackBarMessage(
                                context,
                                updatestatus.errorMessage ?? 'failes',
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                    Visibility(
                      visible: _editInProgress == false,
                      replacement: const CenteredProgressIndicator(),
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.edit),
                        onSelected: (String selectedValue) {
                          dropdownValue = selectedValue;
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return statusList.map((String value) {
                            return PopupMenuItem<String>(
                              value: value,
                              child: ListTile(
                                onTap: () async {
                                  final TaskController updatestatus =
                                      Get.find<TaskController>();
                                  final bool result =
                                      await updatestatus.updatestatus(
                                          widget.taskModel.sId!, value);
                                  if (result) {
                                    widget.onUpdateTask();
                                    Navigator.pop(context);
                                    showSnackBarMessage(
                                      context,
                                      'Status update',
                                    );
                                  } else {
                                    if (mounted) {
                                      showSnackBarMessage(
                                        context,
                                        updatestatus.errorMessage ?? 'failes',
                                      );
                                    }
                                  }
                                },
                                title: Text(value),
                                trailing: dropdownValue == value
                                    ? const Icon(Icons.done)
                                    : null,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTask() async {
    _deleteInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.deleteTask(widget.taskModel.sId!));

    if (response.isSuccess) {
      widget.onUpdateTask();
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          response.errorMessage ?? 'Get task count by status failed! Try again',
        );
      }
    }
    _deleteInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _updatestatus(String status) async {
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(
        Urls.updateTaskStatus(widget.taskModel.sId!, status!));

    if (response.isSuccess) {
      widget.onUpdateTask();
      showSnackBarMessage(
        context,
        response.errorMessage ?? 'Status update',
      );
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          response.errorMessage ?? 'failes',
        );
      }
    }
    _deleteInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
