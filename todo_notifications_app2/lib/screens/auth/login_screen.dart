import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final TextEditingController
  emailController =
  TextEditingController();

  final TextEditingController
  passwordController =
  TextEditingController();

  bool obscurePassword = true;

  void login(){

    String email =
    emailController.text.trim();

    String password =
    passwordController.text.trim();

    if(email.isEmpty ||
        password.isEmpty){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Completa todos los campos",
          ),
        ),
      );

      return;
    }

    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(

        builder: (_) =>
        const HomeScreen(),
      ),

          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF7F8FC),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(25),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 40),

              Center(

                child: Container(

                  padding:
                  const EdgeInsets.all(25),

                  decoration: BoxDecoration(

                    color:
                    Colors.green.withOpacity(0.1),

                    shape: BoxShape.circle,
                  ),

                  child: const Icon(

                    Icons.task_alt,

                    size: 90,

                    color: Colors.green,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Text(

                "Bienvenido 👋",

                style: TextStyle(

                  fontSize: 34,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(

                "Inicia sesión para continuar",

                style: TextStyle(

                  fontSize: 18,

                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 40),

              buildTextField(

                controller:
                emailController,

                hint:
                "Correo electrónico",

                icon: Icons.email,
              ),

              const SizedBox(height: 20),

              buildTextField(

                controller:
                passwordController,

                hint: "Contraseña",

                icon: Icons.lock,

                isPassword: true,
              ),

              const SizedBox(height: 40),

              SizedBox(

                width: double.infinity,

                height: 60,

                child: ElevatedButton(

                  onPressed: login,

                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    Colors.green,

                    elevation: 5,

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                    ),
                  ),

                  child: const Text(

                    "Iniciar Sesión",

                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Row(

                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  const Text(
                    "¿No tienes cuenta?",
                  ),

                  TextButton(

                    onPressed: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>
                          const RegisterScreen(),
                        ),
                      );
                    },

                    child: const Text(

                      "Crear Usuario",

                      style: TextStyle(

                        color: Colors.green,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({

    required TextEditingController
    controller,

    required String hint,

    required IconData icon,

    bool isPassword = false,
  }) {

    return Container(

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(18),

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

        obscureText:
        isPassword
            ? obscurePassword
            : false,

        decoration: InputDecoration(

          prefixIcon: Icon(

            icon,

            color: Colors.green,
          ),

          suffixIcon: isPassword

              ? IconButton(

            icon: Icon(

              obscurePassword

                  ? Icons.visibility_off

                  : Icons.visibility,
            ),

            onPressed: () {

              setState(() {

                obscurePassword =
                !obscurePassword;
              });
            },
          )

              : null,

          hintText: hint,

          border: OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(18),

            borderSide:
            BorderSide.none,
          ),
        ),
      ),
    );
  }
}