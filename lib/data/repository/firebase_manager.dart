import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:morphosis_flutter_demo/data/model/task.dart';
import 'package:morphosis_flutter_demo/data/service/app_service.dart';
import 'package:morphosis_flutter_demo/presentation/blocs/snackbar.bloc.dart';

class FirebaseManager {
  static FirebaseManager? _one;

  static FirebaseManager get shared =>
      (_one == null ? (_one = FirebaseManager._()) : _one!);

  FirebaseManager._();

  Future<void> initialise() => Firebase.initializeApp();

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get tasksRef =>
      FirebaseFirestore.instance.collection('atabek');

  addTask(Task task) async {
    bool success = false;
    await tasksRef.doc().set(task.toJson()).whenComplete(() {
      success = true;
      AppService.showSnackbar("Task added", SnackbarType.success);
    }).catchError((e) {
      AppService.showSnackbar("Error while task adding", SnackbarType.success);
    });

    return success;
  }

  Future<bool> updateTask(Task task) async {
    bool success = false;
    await tasksRef.doc(task.id).update(task.toJson()).whenComplete(() {
      success = true;
      AppService.showSnackbar("Task updated", SnackbarType.success);
    }).catchError((e) {
      AppService.showSnackbar(
          "Error while task updating", SnackbarType.success);
    });
    return success;
  }

  Future<bool> deleteTask(String docId) async {
    bool success = false;
    await tasksRef.doc(docId).delete().whenComplete(() {
      success = true;
      AppService.showSnackbar("Task deleted", SnackbarType.success);
    }).catchError((e) {
      AppService.showSnackbar(
          "Error while task deleting", SnackbarType.success);
    });
    return success;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTasks([completed = false]) {
    return completed
        ? this.tasksRef.where('completed_at', isNull: true).snapshots()
        : this.tasksRef.snapshots();
  }
}
