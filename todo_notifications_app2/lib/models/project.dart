import 'task.dart';

class Project {

  int? id;

  String title;

  String description;

  double progress;

  List<Task> tasks;

  Project({

    this.id,

    required this.title,

    required this.description,

    required this.progress,

    required this.tasks,
  });

  void calculateProgress(){

    if(tasks.isEmpty){

      progress = 0;

      return;
    }

    double total = 0;

    for(var task in tasks){

      total += task.progress;
    }

    progress = total / tasks.length;
  }
}