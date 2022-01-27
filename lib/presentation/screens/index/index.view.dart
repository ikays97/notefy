import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morphosis_flutter_demo/data/model/task.dart';
import 'package:morphosis_flutter_demo/data/repository/firebase_manager.dart';
import 'package:morphosis_flutter_demo/presentation/screens/index/index.bloc.dart';

import '../home/home.view.dart';
import '../tasks/tasks.view.dart';

class IndexPage extends StatefulWidget {
  static const routeName = "index-page";

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _currentIndex = 0;
  late IndexBloc indexBloc;

  @override
  void initState() {
    indexBloc = BlocProvider.of<IndexBloc>(context);

    FirebaseManager.shared.getTasks();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      HomePage(),
      TasksPage(title: 'All Tasks'),
      TasksPage(
        title: 'Completed Tasks',
        isCompletedPage: true,
      )
    ];

    return BlocBuilder<IndexBloc, IndexState>(
      bloc: indexBloc,
      builder: (context, state) {
        return Scaffold(
          body: children[state.index],
          bottomNavigationBar: BottomNavigationBar(
            onTap: indexBloc.changeIndex,
            currentIndex: state.index,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'All Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check),
                label: 'Completed Tasks',
              ),
            ],
          ),
        );
      },
    );
  }
}
