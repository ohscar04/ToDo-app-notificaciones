import 'package:flutter/material.dart';

import '../../models/project.dart';
import '../../models/task.dart';

class CreateTaskScreen extends StatefulWidget {

  final Project project;

  const CreateTaskScreen({
    super.key,
    required this.project,
  });

  @override
  State<CreateTaskScreen> createState() =>
      _CreateTaskScreenState();
}

class _CreateTaskScreenState
    extends State<CreateTaskScreen> {

  final titleController =
  TextEditingController();

  final descriptionController =
  TextEditingController();

  DateTime? selectedDate;

  Future<void> selectDate() async {

    final picked =
    await showDatePicker(

      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime.now(),

      lastDate:
      DateTime(2100),
    );

    if(picked != null){

      setState(() {

        selectedDate = picked;
      });
    }
  }

  void saveTask(){

    if(titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedDate == null){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Faltan datos",
          ),
        ),
      );

      return;
    }

    final task = Task(

      title:
      titleController.text,

      description:
      descriptionController.text,

      dueDate:
      selectedDate!,

      progress: 0,

      subtasks: [],

      project: widget.project,
    );

    Navigator.pop(
      context,
      task,
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

        title: const Text(

          "Nueva Tarea",

          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const SizedBox(height: 10),

            const Text(

              "Título",

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            buildInput(
              controller:
              titleController,
              hint:
              "Ejemplo: Diseñar login",
              icon: Icons.task_alt,
            ),

            const SizedBox(height: 25),

            const Text(

              "Descripción",

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            buildInput(

              controller:
              descriptionController,

              hint:
              "Describe la tarea",

              icon: Icons.description,

              maxLines: 4,
            ),

            const SizedBox(height: 25),

            const Text(

              "Fecha de entrega",

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            GestureDetector(

              onTap: selectDate,

              child: Container(

                width: double.infinity,

                padding:
                const EdgeInsets.all(18),

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

                child: Row(

                  children: [

                    const Icon(
                      Icons.calendar_month,
                      color: Colors.orange,
                    ),

                    const SizedBox(width: 15),

                    Text(

                      selectedDate == null

                          ? "Seleccionar fecha"

                          : "${selectedDate!.day}/"
                          "${selectedDate!.month}/"
                          "${selectedDate!.year}",

                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(

              width: double.infinity,
              height: 60,

              child: ElevatedButton(

                onPressed: saveTask,

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  Colors.orange,

                  elevation: 4,

                  shape:
                  RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                ),

                child: const Text(

                  "Guardar tarea",

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInput({

    required TextEditingController
    controller,

    required String hint,

    required IconData icon,

    int maxLines = 1,
  }) {

    return Container(

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

      child: TextField(

        controller: controller,

        maxLines: maxLines,

        decoration: InputDecoration(

          hintText: hint,

          prefixIcon: Icon(
            icon,
            color: Colors.orange,
          ),

          border: OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(20),

            borderSide:
            BorderSide.none,
          ),
        ),
      ),
    );
  }
}