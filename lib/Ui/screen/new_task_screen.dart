import 'package:flutter/material.dart';
import 'package:taskmanager/Router/RouterPath.dart';

import '../../Style/Colors.dart';
import '../../widgets/task_item.dart';
import '../../widgets/task_summary_card.dart';


class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
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
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const TaskItem();
                },
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
    Navigator.pushNamed(context, Routerpath.addtasklist);
  }

  Widget _buildSummarySection() {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          TaskSummaryCard(
            title: 'New Task',
            count: '34',
          ),
          TaskSummaryCard(
            title: 'Completed',
            count: '34',
          ),
          TaskSummaryCard(
            title: 'In Progress',
            count: '34',
          ),
          TaskSummaryCard(
            title: 'Cancelled',
            count: '34',
          ),
        ],
      ),
    );
  }
}
