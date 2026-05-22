class Subtask {

  String title;

  DateTime dueDate;

  bool completed;

  String evidence;

  String evidenceType;

  Subtask({

    required this.title,

    required this.dueDate,

    required this.completed,

    this.evidence = '',

    this.evidenceType = '',
  });
}