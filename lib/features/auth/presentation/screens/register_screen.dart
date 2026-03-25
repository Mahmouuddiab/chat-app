import 'package:chat_app/core/di/di.dart';
import 'package:chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chat_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:chat_app/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final cubit = getIt<AuthCubit>();
  bool secure1 = true;
  bool secure2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<AuthCubit, AuthState>(
          bloc: cubit,
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Success Register"),backgroundColor: Colors.green,)
              );
            }
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 28),
                  ),

                  const SizedBox(height: 30),

                  /// Email
                  TextFormField(
                    controller: emailController,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    validator: (value) {
                      if (value!.isEmpty) return "Enter email";
                      if (!value.contains("@")) return "Invalid email";
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// Password
                  TextFormField(
                    controller: passwordController,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    obscureText: secure1,
                    validator: (value) {
                      if (value!.isEmpty) return "Enter password";
                      if (value.length < 6) return "Min 6 chars";
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed:(){
                            setState(() {
                              secure1 = !secure1;
                            });
                          },
                          icon: Icon(secure1? Icons.visibility_off:Icons.visibility)
                      ),
                      labelText: "Password",
                      border: const OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// Confirm Password
                  TextFormField(
                    controller: confirmPasswordController,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    obscureText: secure2,
                    validator: (value) {
                      if (value != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                    decoration:  InputDecoration(
                      suffixIcon: IconButton(
                          onPressed:(){
                            setState(() {
                              secure2 = !secure2;
                            });
                          },
                          icon: Icon(secure2? Icons.visibility_off:Icons.visibility)
                      ),
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// Register Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is AuthLoading
                          ? CircularProgressIndicator.adaptive
                          : () {
                        if (formKey.currentState!.validate()) {
                          cubit.register(emailController.text.trim(), passwordController.text.trim());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          shape: BeveledRectangleBorder()
                      ),
                      child: state is AuthLoading
                          ? const CircularProgressIndicator()
                          : const Text("Register",style: TextStyle(fontSize: 17),),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// Navigate to Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("already have an account? "),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}