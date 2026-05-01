import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = DBHelper();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  loadTasks() async {
    tasks = await db.getTasks();
    setState(() {});
  }

 Future<void> addTask() async {
    Task newTask = Task(
      title: "Nueva tarea",
      description: "Descripción",
    );

    await db.insertTask(newTask);
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> showNotification(String title, String body) async {
  // Aquí puedes agregar la lógica de flutter_local_notifications después
  print("Notificación: $title - $body");
}
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis tareas"),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (_, i) {
          final task = tasks[i];

          return Card(
            color: Colors.grey[200],
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(task.title),
              subtitle: Text(task.description),
              trailing: Checkbox(
                value: task.isDone == 1,
                onChanged: (value) async {
                  task.isDone = value! ? 1 : 0;
                  await db.updateTask(task);
                  loadTasks();
                },
              ),
              onLongPress: () async {
                await db.deleteTask(task.id!);
                loadTasks();
              },
            ),
          );
        },
      ),
  floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1565C0),
        onPressed: () async {
          // Primero ejecutamos tu función de agregar tarea
          await addTask(); 
          
          // Luego lanzamos la notificación
          await showNotification(
            "Nueva tarea",
            "Has agregado una tarea",
          );
        },
        child: const Icon(Icons.add),
      ),
    ); // Este es el cierre del Scaffold
  }
}