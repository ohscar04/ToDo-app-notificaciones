import 'project.dart';
import 'subtask.dart';

class Task {

  int? id;

  String title;

  String description;

  DateTime dueDate;

  double progress;

  List<Subtask> subtasks;

  Project? project;

  Task({

    this.id,

    required this.title,

    required this.description,

    required this.dueDate,

    required this.progress,

    required this.subtasks,

    this.project,
  });
}