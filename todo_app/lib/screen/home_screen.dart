import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../database/db_helper.dart';
import '../models/task.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = DBHelper();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  // 🔄 Cargar tareas
  void loadTasks() async {
    final data = await db.getTasks();
    debugPrint("DATOS BD: ${data.length}");
    setState(() {
      tasks = data;
    });
  }

  // 🔔 Notificación simulada
  Future<void> showNotification(String title, String body) async {
    debugPrint("Notificación: $title - $body");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis tareas"),
      ),

      body: tasks.isEmpty
          ? const Center(child: Text("No hay tareas"))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, i) {
                final task = tasks[i];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),

                    trailing: Checkbox(
                      value: task.isDone == 1,
                      onChanged: (value) async {
                        task.isDone = value! ? 1 : 0;
                        await db.updateTask(task);
                        loadTasks();

                        await showNotification(
                          "Tarea actualizada",
                          task.title,
                        );
                      },
                    ),

                    onLongPress: () async {
                      await db.deleteTask(task.id!);
                      loadTasks();

                      await showNotification(
                        "Tarea eliminada",
                        task.title,
                      );
                    },
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskScreen()),
          );

          debugPrint("RESULTADO: $result");

          if (result == true) {
            loadTasks();
          }
        },
      ),
    );
  }
}