import 'package:flutter/material.dart';

import '../../models/project.dart';
import '../../models/task.dart';

import 'create_task_screen.dart';
import '../subtasks/subtask_screen.dart';

class TaskScreen extends StatefulWidget {

  final Project project;

  const TaskScreen({
    super.key,
    required this.project,
  });

  @override
  State<TaskScreen> createState() =>
      _TaskScreenState();
}

class _TaskScreenState
    extends State<TaskScreen> {

  void calculateProgress(){

    if(widget.project.tasks.isEmpty){

      widget.project.progress = 0;

      return;
    }

    double total = 0;

    for(var task in widget.project.tasks){

      total += task.progress;
    }

    widget.project.progress =
        total /
            widget.project.tasks.length;
  }

  void showDeleteDialog(int index){

    showDialog(

      context: context,

      builder: (_) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(25),
          ),

          title: const Text(
            "Eliminar tarea",
          ),

          content: const Text(
            "¿Deseas eliminar esta tarea?",
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(context);
              },

              child: const Text(
                "Cancelar",
              ),
            ),

            ElevatedButton(

              style:
              ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),

              onPressed: () {

                setState(() {

                  widget.project.tasks
                      .removeAt(index);

                  calculateProgress();
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(

                  const SnackBar(
                    content: Text(
                      "Tarea eliminada",
                    ),
                  ),
                );
              },

              child: const Text(
                "Eliminar",
              ),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(Task task){

    final titleController =
    TextEditingController(
      text: task.title,
    );

    final descriptionController =
    TextEditingController(
      text: task.description,
    );

    showDialog(

      context: context,

      builder: (_) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(25),
          ),

          title: const Text(
            "Editar tarea",
          ),

          content: SingleChildScrollView(

            child: Column(

              children: [

                TextField(

                  controller:
                  titleController,

                  decoration:
                  const InputDecoration(
                    hintText: "Título",
                  ),
                ),

                const SizedBox(height: 20),

                TextField(

                  controller:
                  descriptionController,

                  maxLines: 3,

                  decoration:
                  const InputDecoration(
                    hintText: "Descripción",
                  ),
                ),
              ],
            ),
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(context);
              },

              child: const Text(
                "Cancelar",
              ),
            ),

            ElevatedButton(

              onPressed: () {

                setState(() {

                  task.title =
                      titleController.text;

                  task.description =
                      descriptionController.text;
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(

                  const SnackBar(
                    content: Text(
                      "Tarea actualizada",
                    ),
                  ),
                );
              },

              child: const Text(
                "Guardar",
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F7FA),

      appBar: AppBar(

        backgroundColor: Colors.transparent,
        elevation: 0,

        title: Text(

          widget.project.title,

          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: widget.project.tasks.isEmpty

            ? const Center(
          child: Text(
            "No hay tareas",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        )

            : ListView.builder(

          itemCount:
          widget.project.tasks.length,

          itemBuilder: (context, index){

            final task =
            widget.project.tasks[index];

            return buildTaskCard(
              task,
              index,
            );
          },
        ),
      ),

      floatingActionButton:
      FloatingActionButton(

        backgroundColor: Colors.orange,

        onPressed: () async {

          final result =
          await Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) =>
                  CreateTaskScreen(
                    project: widget.project,
                  ),
            ),
          );

          if(result != null){

            setState(() {

              widget.project.tasks
                  .add(result);

              calculateProgress();
            });
          }
        },

        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildTaskCard(
      Task task,
      int index,
      ){

    Color statusColor;

    if(task.progress == 1){

      statusColor = Colors.green;
    }
    else if(task.progress > 0){

      statusColor = Colors.orange;
    }
    else{

      statusColor = Colors.red;
    }

    return GestureDetector(

      onLongPress: () {

        showModalBottomSheet(

          context: context,

          shape:
          const RoundedRectangleBorder(

            borderRadius:
            BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),

          builder: (_) {

            return Padding(

              padding:
              const EdgeInsets.all(20),

              child: Column(

                mainAxisSize:
                MainAxisSize.min,

                children: [

                  ListTile(

                    leading: const Icon(
                      Icons.edit,
                      color: Colors.orange,
                    ),

                    title: const Text(
                      "Editar tarea",
                    ),

                    onTap: () {

                      Navigator.pop(context);

                      showEditDialog(task);
                    },
                  ),

                  ListTile(

                    leading: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),

                    title: const Text(
                      "Eliminar tarea",
                    ),

                    onTap: () {

                      Navigator.pop(context);

                      showDeleteDialog(index);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },

      onTap: () {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) =>
                SubtaskScreen(
                  task: task,
                ),
          ),
        ).then((_) {

          setState(() {

            calculateProgress();
          });
        });
      },

      child: AnimatedContainer(

        duration:
        const Duration(milliseconds: 300),

        margin:
        const EdgeInsets.only(bottom: 20),

        padding:
        const EdgeInsets.all(20),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
          BorderRadius.circular(20),

          boxShadow: [

            BoxShadow(
              color:
              Colors.black.withOpacity(0.04),

              blurRadius: 10,
            ),
          ],
        ),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Row(

              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [

                Expanded(

                  child: Text(

                    task.title,

                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),

                Container(

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(

                    color:
                    statusColor.withOpacity(0.15),

                    borderRadius:
                    BorderRadius.circular(15),
                  ),

                  child: Text(

                    "${(task.progress * 100).toInt()}%",

                    style: TextStyle(

                      color: statusColor,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(

              task.description,

              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 20),

            Text(

              "Entrega: "
                  "${task.dueDate.day}/"
                  "${task.dueDate.month}/"
                  "${task.dueDate.year}",

              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            ClipRRect(

              borderRadius:
              BorderRadius.circular(20),

              child: LinearProgressIndicator(

                value: task.progress,

                minHeight: 10,

                backgroundColor:
                Colors.grey.shade300,

                valueColor:
                AlwaysStoppedAnimation(
                  statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}