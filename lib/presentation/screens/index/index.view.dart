import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morphosis_flutter_demo/data/repository/firebase_manager.dart';
import 'package:morphosis_flutter_demo/presentation/screens/index/index.bloc.dart';

import '../home.dart';
import '../tasks.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _currentIndex = 0;
  IndexBloc indexBloc;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      HomePage(),
      TasksPage(
        title: 'All Tasks',
        tasks: FirebaseManager.shared.tasks,
      ),
      TasksPage(
        title: 'Completed Tasks',
        tasks:
            FirebaseManager.shared.tasks.where((t) => t.isCompleted).toList(),
      )
    ];

    return BlocBuilder(
      cubit: indexBloc,
      builder: (context, state) {
        return Scaffold(
          body: children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped,
            currentIndex: _currentIndex,
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
