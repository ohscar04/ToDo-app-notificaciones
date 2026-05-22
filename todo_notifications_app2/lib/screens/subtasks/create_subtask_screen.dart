import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../../models/subtask.dart';

class CreateSubtaskScreen extends StatefulWidget {

  final Task task;

  const CreateSubtaskScreen({
    super.key,
    required this.task,
  });

  @override
  State<CreateSubtaskScreen> createState() =>
      _CreateSubtaskScreenState();
}

class _CreateSubtaskScreenState
    extends State<CreateSubtaskScreen> {

  final titleController =
  TextEditingController();

  final evidenceController =
  TextEditingController();

  DateTime? selectedDate;

  TimeOfDay? selectedTime;

  Future<void> selectDate() async {

    final picked =
    await showDatePicker(

      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime.now(),

      lastDate:
      widget.task.dueDate,
    );

    if(picked != null){

      if(picked.isAfter(
          widget.task.dueDate)){

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content: Text(
              "La fecha excede la fecha límite de la tarea",
            ),
          ),
        );

        return;
      }

      setState(() {

        selectedDate = picked;
      });
    }
  }

  Future<void> selectTime() async {

    final picked =
    await showTimePicker(

      context: context,

      initialTime: TimeOfDay.now(),
    );

    if(picked != null){

      setState(() {

        selectedTime = picked;
      });
    }
  }

  void saveSubtask(){

    if(titleController.text.isEmpty ||
        evidenceController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null){

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

    final finalDateTime = DateTime(

      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,

      selectedTime!.hour,
      selectedTime!.minute,
    );

    final taskLimit = widget.task.dueDate;

    if(finalDateTime.isAfter(taskLimit)){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "La subtarea supera la fecha límite de la tarea",
          ),
        ),
      );

      return;
    }

    final subtask = Subtask(

      title:
      titleController.text,

      dueDate:
      finalDateTime,

      completed: false,
      
evidence:
evidenceController.text,
    );

    Navigator.pop(
      context,
      subtask,
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

          "Nueva Subtarea",

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
              "Ejemplo: Diseñar botón",

              icon:
              Icons.task_alt,
            ),

            const SizedBox(height: 25),

            const Text(

              "Evidencia",

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            buildInput(

              controller:
              evidenceController,

              hint:
              "Link o descripción",

              icon:
              Icons.link,

              maxLines: 3,
            ),

            const SizedBox(height: 25),

            const Text(

              "Fecha límite",

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
                      color: Colors.green,
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

            const SizedBox(height: 25),

            const Text(

              "Hora límite",

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            GestureDetector(

              onTap: selectTime,

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
                      Icons.access_time,
                      color: Colors.orange,
                    ),

                    const SizedBox(width: 15),

                    Text(

                      selectedTime == null

                          ? "Seleccionar hora"

                          : selectedTime!
                          .format(context),

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

                onPressed: saveSubtask,

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  Colors.green,

                  elevation: 4,

                  shape:
                  RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                ),

                child: const Text(

                  "Guardar subtarea",

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
            color: Colors.green,
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