import 'package:flutter/material.dart';

import '../../models/project.dart';

import '../../services/notification_service.dart';

import '../auth/login_screen.dart';
import '../projects/create_project_screen.dart';
import '../tasks/task_screen.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  List<Project> projects = [

    Project(
      title: "Aplicación ToDo",
      description: "Proyecto Flutter",
      progress: 0.0,
       tasks: [],
    ),
  ];

  void deleteProject(int index){

    showDialog(

      context: context,

      builder: (_) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(25),
          ),

          title: const Text(
            "Eliminar proyecto",
          ),

          content: const Text(
            "¿Deseas eliminar este proyecto?",
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

                  projects.removeAt(index);
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(

                  const SnackBar(
                    content: Text(
                      "Proyecto eliminado",
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

  void editProject(Project project){

    final titleController =
    TextEditingController(
      text: project.title,
    );

    final descriptionController =
    TextEditingController(
      text: project.description,
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
            "Editar proyecto",
          ),

          content: Column(

            mainAxisSize:
            MainAxisSize.min,

            children: [

              TextField(

                controller:
                titleController,

                decoration:
                const InputDecoration(
                  labelText: "Título",
                ),
              ),

              const SizedBox(height: 20),

              TextField(

                controller:
                descriptionController,

                decoration:
                const InputDecoration(
                  labelText: "Descripción",
                ),
              ),
            ],
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

                  project.title =
                      titleController.text;

                  project.description =
                      descriptionController.text;
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(

                  const SnackBar(
                    content: Text(
                      "Proyecto actualizado",
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

        elevation: 0,

        backgroundColor:
        Colors.transparent,

        title: const Text(

          "Mis Proyectos",

          style: TextStyle(

            color: Colors.black,

            fontWeight:
            FontWeight.bold,
          ),
        ),

        actions: [

          IconButton(

            onPressed: () async {

              await NotificationService
                  .showNotification(

                title:
                "Notificación de prueba",

                body:
                "Las notificaciones funcionan 🔔",
              );
            },

            icon: const Icon(

              Icons.notifications_none,

              color: Colors.black,
            ),
          ),

          PopupMenuButton(

            icon: const Icon(

              Icons.more_vert,

              color: Colors.black,
            ),

            itemBuilder: (_) => [

              const PopupMenuItem(

                value: 'logout',

                child: Text(
                  "Cerrar sesión",
                ),
              ),
            ],

            onSelected: (value){

              if(value == 'logout'){

                Navigator.pushAndRemoveUntil(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                    const LoginScreen(),
                  ),

                      (route) => false,
                );
              }
            },
          ),
        ],
      ),

      body: Padding(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(

              "Organiza tus tareas",

              style: TextStyle(

                fontSize: 28,

                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(

              "Gestiona proyectos y subtareas",

              style: TextStyle(

                color: Colors.grey,

                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            Expanded(

              child: projects.isEmpty

                  ? const Center(

                child: Text(

                  "No hay proyectos",

                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              )

                  : ListView.builder(

                itemCount:
                projects.length,

                itemBuilder:
                    (context, index){

                  final project =
                  projects[index];

                  return buildProjectCard(
                    project,
                    index,
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton:
      FloatingActionButton(

        backgroundColor:
        Colors.green,

        onPressed: () async {

          final result =
          await Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) =>
              const CreateProjectScreen(),
            ),
          );

          if(result != null){

            setState(() {

              projects.add(result);
            });
          }
        },

        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget buildProjectCard(
      Project project,
      int index,
      ){

    Color progressColor;

    if(project.progress == 1){

      progressColor = Colors.green;
    }
    else if(project.progress > 0){

      progressColor = Colors.orange;
    }
    else{

      progressColor = Colors.red;
    }

    return GestureDetector(

      onTap: () {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) =>
                TaskScreen(
                  project: project,
                ),
          ),
        ).then((_) {

          setState(() {});
        });
      },

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
                      "Editar proyecto",
                    ),

                    onTap: () {

                      Navigator.pop(context);

                      editProject(project);
                    },
                  ),

                  ListTile(

                    leading: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),

                    title: const Text(
                      "Eliminar proyecto",
                    ),

                    onTap: () {

                      Navigator.pop(context);

                      deleteProject(index);
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
        const Duration(
          milliseconds: 400,
        ),

        margin:
        const EdgeInsets.only(
          bottom: 20,
        ),

        padding:
        const EdgeInsets.all(20),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
          BorderRadius.circular(25),

          boxShadow: [

            BoxShadow(

              color:
              Colors.black.withOpacity(0.05),

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

                    project.title,

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

                    horizontal: 14,

                    vertical: 8,
                  ),

                  decoration: BoxDecoration(

                    color:
                    progressColor
                        .withOpacity(0.15),

                    borderRadius:
                    BorderRadius.circular(
                      15,
                    ),
                  ),

                  child: Text(

                    "${(project.progress * 100).toInt()}%",

                    style: TextStyle(

                      color: progressColor,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Text(

              project.description,

              style: const TextStyle(

                color: Colors.grey,

                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            ClipRRect(

              borderRadius:
              BorderRadius.circular(20),

              child:
              LinearProgressIndicator(

                value: project.progress,

                minHeight: 10,

                backgroundColor:
                Colors.grey.shade200,

                valueColor:
                AlwaysStoppedAnimation(
                  progressColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
