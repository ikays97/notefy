import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morphosis_flutter_demo/data/model/task.dart';
import 'package:morphosis_flutter_demo/data/repository/firebase_manager.dart';

class TaskPage extends StatelessWidget {
  TaskPage({this.task});

  final Task? task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? 'New Task' : 'Edit Task'),
      ),
      body: _TaskForm(task: task),
    );
  }
}

class _TaskForm extends StatefulWidget {
  _TaskForm({this.task});

  final Task? task;

  @override
  __TaskFormState createState() => __TaskFormState();
}

class __TaskFormState extends State<_TaskForm> {
  static const double _padding = 16;

  late Task task;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  void init() {
    if (widget.task == null) {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      task = Task(title: "");
    } else {
      task = widget.task!;
      _titleController = TextEditingController(text: task.title);
      _descriptionController = TextEditingController(text: task.description);
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  void _add(BuildContext context) async {
    if (await FirebaseManager.shared.addTask(task.copyWith(
      description: _descriptionController.text,
      title: _titleController.text,
    ))) {
      Navigator.of(context).pop();
    }
  }

  void _update(BuildContext context) async {
    if (await FirebaseManager.shared.updateTask(task.copyWith(
      description: _descriptionController.text,
      title: _titleController.text,
    ))) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(_padding),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
            SizedBox(height: _padding),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
              minLines: 5,
              maxLines: 10,
            ),
            SizedBox(height: _padding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Completed'),
                CupertinoSwitch(
                  value: task.isCompleted,
                  onChanged: (_) {
                    task.toggleComplete();
                    setState(() {});
                  },
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () => task.isNew ? _add(context) : _update(context),
              child: Container(
                width: double.infinity,
                child: Center(child: Text(task.isNew ? 'Create' : 'Update')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
