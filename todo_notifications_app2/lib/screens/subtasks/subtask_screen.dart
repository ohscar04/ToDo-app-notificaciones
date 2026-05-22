import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/task.dart';
import '../../models/subtask.dart';

import '../../services/notification_service.dart';

import 'create_subtask_screen.dart';

class SubtaskScreen extends StatefulWidget {

  final Task task;

  const SubtaskScreen({
    super.key,
    required this.task,
  });

  @override
  State<SubtaskScreen> createState() =>
      _SubtaskScreenState();
}

class _SubtaskScreenState
    extends State<SubtaskScreen> {

  void calculateProgress(){

    if(widget.task.subtasks.isEmpty){

      widget.task.progress = 0;

      widget.task.project
          ?.calculateProgress();

      return;
    }

    int completed =
    widget.task.subtasks
        .where((s) => s.completed)
        .length;

    widget.task.progress =
        completed /
            widget.task.subtasks.length;

    widget.task.project
        ?.calculateProgress();
  }

  Future pickDocument(Subtask subtask) async {

    FilePickerResult? result =
    await FilePicker.platform.pickFiles();

    if(result != null){

      setState(() {

        subtask.evidence =
        result.files.single.path!;

        subtask.evidenceType =
        'document';
      });
    }
  }

  Future pickImage(Subtask subtask) async {

    final picker = ImagePicker();

    final image =
    await picker.pickImage(
      source: ImageSource.gallery,
    );

    if(image != null){

      setState(() {

        subtask.evidence =
        image.path;

        subtask.evidenceType =
        'image';
      });
    }
  }

  void addLink(Subtask subtask){

    final controller =
    TextEditingController();

    showDialog(

      context: context,

      builder: (_) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(25),
          ),

          title: const Text(
            "Agregar link",
          ),

          content: TextField(

            controller: controller,

            decoration:
            const InputDecoration(
              hintText: "https://...",
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

                  subtask.evidence =
                  controller.text;

                  subtask.evidenceType =
                  'link';
                });

                Navigator.pop(context);
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
            "Eliminar subtarea",
          ),

          content: const Text(
            "¿Deseas eliminar esta subtarea?",
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

                  widget.task.subtasks
                      .removeAt(index);

                  calculateProgress();
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(

                  const SnackBar(
                    content: Text(
                      "Subtarea eliminada",
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

  void showEditDialog(Subtask subtask){

    final titleController =
    TextEditingController(
      text: subtask.title,
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
            "Editar subtarea",
          ),

          content: TextField(

            controller:
            titleController,

            decoration:
            const InputDecoration(
              hintText: "Título",
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

                  subtask.title =
                      titleController.text;
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(

                  const SnackBar(
                    content: Text(
                      "Subtarea actualizada",
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

          widget.task.title,

          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: widget.task.subtasks.isEmpty

          ? const Center(
        child: Text(
          "No hay subtareas",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      )

          : ListView.builder(

        padding:
        const EdgeInsets.all(20),

        itemCount:
        widget.task.subtasks.length,

        itemBuilder: (context, index){

          final subtask =
          widget.task.subtasks[index];

          Color statusColor;

          if(subtask.completed){

            statusColor = Colors.green;
          }
          else{

            statusColor = Colors.orange;
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
                            "Editar subtarea",
                          ),

                          onTap: () {

                            Navigator.pop(context);

                            showEditDialog(subtask);
                          },
                        ),

                        ListTile(

                          leading: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),

                          title: const Text(
                            "Eliminar subtarea",
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

            child: AnimatedContainer(

              duration:
              const Duration(milliseconds: 300),

              margin:
              const EdgeInsets.only(
                bottom: 20,
              ),

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

                    children: [

                      Checkbox(

                        value:
                        subtask.completed,

                        activeColor:
                        Colors.green,

                        onChanged: (value) async {

                          setState(() {

                            subtask.completed =
                            value!;

                            calculateProgress();
                          });

                          if(!subtask.completed){

                            await NotificationService
                                .showNotification(

                              title:
                              "Subtarea pendiente",

                              body:
                              "${subtask.title} aún no fue completada",
                            );
                          }
                          else{

                            await NotificationService
                                .showNotification(

                              title:
                              "Subtarea completada",

                              body:
                              "${subtask.title} fue completada correctamente",
                            );
                          }
                        },
                      ),

                      Expanded(

                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Text(

                              subtask.title,

                              style: TextStyle(

                                fontSize: 18,

                                fontWeight:
                                FontWeight.bold,

                                decoration:

                                subtask.completed

                                    ? TextDecoration
                                    .lineThrough

                                    : null,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(

                              "Entrega: "
                                  "${subtask.dueDate.day}/"
                                  "${subtask.dueDate.month}/"
                                  "${subtask.dueDate.year}",

                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Wrap(

                    spacing: 10,
                    runSpacing: 10,

                    children: [

                      ElevatedButton.icon(

                        onPressed: () {

                          pickDocument(subtask);
                        },

                        icon: const Icon(
                          Icons.description,
                        ),

                        label: const Text(
                          "Documento",
                        ),
                      ),

                      ElevatedButton.icon(

                        onPressed: () {

                          pickImage(subtask);
                        },

                        icon: const Icon(
                          Icons.image,
                        ),

                        label: const Text(
                          "Imagen",
                        ),
                      ),

                      ElevatedButton.icon(

                        onPressed: () {

                          addLink(subtask);
                        },

                        icon: const Icon(
                          Icons.link,
                        ),

                        label: const Text(
                          "Link",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  if(subtask.evidence.isNotEmpty)

                    Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        const Text(

                          "Evidencia:",

                          style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        if(subtask.evidenceType ==
                            'image')

                          ClipRRect(

                            borderRadius:
                            BorderRadius.circular(15),

                            child: Image.file(

                              File(
                                subtask.evidence,
                              ),

                              height: 150,

                              width: double.infinity,

                              fit: BoxFit.cover,
                            ),
                          ),

                        if(subtask.evidenceType ==
                            'document')

                          ListTile(

                            contentPadding:
                            EdgeInsets.zero,

                            leading:
                            const Icon(
                              Icons.description,
                            ),

                            title: const Text(
                              "Documento seleccionado",
                            ),

                            subtitle:
                            Text(subtask.evidence),
                          ),

                        if(subtask.evidenceType ==
                            'link')

                          InkWell(

                            onTap: () async {

                              final uri =
                              Uri.parse(
                                subtask.evidence,
                              );

                              await launchUrl(uri);
                            },

                            child: Text(

                              subtask.evidence,

                              style:
                              const TextStyle(

                                color: Colors.blue,

                                decoration:
                                TextDecoration
                                    .underline,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),

      floatingActionButton:
      FloatingActionButton(

        backgroundColor: Colors.green,

        child: const Icon(Icons.add),

        onPressed: () async {

          final result =
          await Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) =>
                  CreateSubtaskScreen(
                    task: widget.task,
                  ),
            ),
          );

          if(result != null){

            setState(() {

              widget.task.subtasks
                  .add(result);

              calculateProgress();
            });
          }
        },
      ),
    );
  }
}