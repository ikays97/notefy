import 'package:flutter_test/flutter_test.dart';
import 'package:morphosis_flutter_demo/data/model/task.dart';

void main() {
  test("Task completedAt value should be toggled/changed", () {
    final title = "Cleaning";
    final description = "House Cleaning";

    var task = Task(
      id: "1",
      title: title,
      description: description,
      completedAt: DateTime.now(),
    );

    task.toggleComplete();

    expect(task.completedAt, null);
  });
}
