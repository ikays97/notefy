import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morphosis_flutter_demo/data/model/task.dart';
import 'package:morphosis_flutter_demo/presentation/screens/tasks/tasks.view.dart';

void main() {
  final title = "Cleaning";
  final description = "House Cleaning";

  var task = Task(
    id: "1",
    title: title,
    description: description,
    completedAt: DateTime.now(),
  );
  testWidgets("TaskTile widget has Task object", (WidgetTester tester) async {
    await tester.pumpWidget(ParentTestWidget(child: TaskTile(task)));

    final titleFinder = find.text(title);
    final descriptionFinder = find.text(description);

    // Using the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.

    expect(titleFinder, findsOneWidget);
    expect(descriptionFinder, findsOneWidget);
  });
}

// Independent widgets need Material parent ancestor to be tested.
class ParentTestWidget extends StatelessWidget {
  const ParentTestWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }
}
