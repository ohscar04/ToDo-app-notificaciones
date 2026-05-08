import 'package:flutter/material.dart';
import 'task_list_screen.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menú")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFA0E7E5),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TaskListScreen()),
                );
              },
              child: Text("Ver tareas"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFAEBC),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddTaskScreen()),
                );
              },
              child: Text("Crear tarea"),
            ),
          ],
        ),
      ),
    );
  }
}