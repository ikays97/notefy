import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:morphosis_flutter_demo/data/model/task.dart';
import 'package:morphosis_flutter_demo/data/repository/firebase_manager.dart';
import 'package:morphosis_flutter_demo/presentation/screens/task_detail/task.view.dart';
import 'package:morphosis_flutter_demo/presentation/shared/widgets/error_widget.dart';
import 'package:morphosis_flutter_demo/presentation/shared/widgets/loader.dart';

class TasksPage extends StatelessWidget {
  TasksPage({required this.title, this.isCompletedPage = false});

  final String title;
  final bool isCompletedPage;

  void addTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => addTask(context),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 16),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseManager.shared.getTasks(isCompletedPage),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorMessage(
                message: snapshot.error.toString(),
                buttonTitle: "Retry",
                onTap: () {},
              );
            } else if (snapshot.hasData || snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var docId = snapshot.data!.docs[index].id;
                  var taskInfo = snapshot.data!.docs[index].data();
                  taskInfo['id'] = docId;
                  var taskModel = Task.fromJson(taskInfo);
                  return _TaskTile(taskModel);
                },
              );
            } else {
              return const Loader();
            }
          },
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  _TaskTile(this.task);

  final Task task;

  void _delete() async {
    await FirebaseManager.shared.deleteTask(task.id!);
  }

  void _toggleComplete() async {
    task.toggleComplete();
    await FirebaseManager.shared.updateTask(task);
  }

  void _view(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskPage(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(
          task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
        ),
        onPressed: _toggleComplete,
      ),
      title: Text(task.title),
      subtitle: Text(task.description ?? ""),
      trailing: IconButton(
        icon: Icon(
          Icons.delete,
        ),
        onPressed: _delete,
      ),
      onTap: () => _view(context),
    );
  }
}
