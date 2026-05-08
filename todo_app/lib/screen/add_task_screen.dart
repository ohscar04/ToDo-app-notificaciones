import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final db = DBHelper();

  // 📅 seleccionar fecha
  Future pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  // ⏰ seleccionar hora
  Future pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  // 💾 guardar tarea
  void saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    await db.insertTask(
      Task(
        title: titleController.text,
        description: descController.text,
      ),
    );

    Navigator.pop(context, true);
  }

  // 🎨 input decorado
  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nueva tarea"),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 📝 TÍTULO
              TextFormField(
                controller: titleController,
                decoration: inputStyle("Título"),
                validator: (value) =>
                    value!.isEmpty ? "Campo obligatorio" : null,
              ),

              SizedBox(height: 16),

              // 📄 DESCRIPCIÓN
              TextFormField(
                controller: descController,
                maxLines: 3,
                decoration: inputStyle("Descripción"),
              ),

              SizedBox(height: 16),

              // 📅 FECHA
              ListTile(
                tileColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                title: Text(
                  selectedDate == null
                      ? "Seleccionar fecha"
                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: pickDate,
              ),

              SizedBox(height: 12),

             
              ListTile(
                tileColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                title: Text(
                  selectedTime == null
                      ? "Seleccionar hora"
                      : selectedTime!.format(context),
                ),
                trailing: Icon(Icons.access_time),
                onTap: pickTime,
              ),

              SizedBox(height: 30),

          
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    "Guardar tarea",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}