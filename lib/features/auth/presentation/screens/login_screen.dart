import 'package:chat_app/core/di/di.dart';
import 'package:chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chat_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:chat_app/features/auth/presentation/screens/register_screen.dart';
import 'package:chat_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final cubit = getIt<AuthCubit>();
  bool secure = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocConsumer<AuthCubit, AuthState>(
            bloc: cubit,
            listener: (context, state) {
              if (state is AuthSuccess) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatScreen(),));
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
                      "Login",
                      style: TextStyle(fontSize: 28),
                    ),

                    const SizedBox(height: 30),

                    /// Email
                    TextFormField(
                      controller: emailController,
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
                      obscureText: secure,
                      validator: (value) {
                        if (value!.isEmpty) return "Enter password";
                        if (value.length < 6) return "Min 6 chars";
                        return null;
                      },
                      decoration:  InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                secure = !secure;
                              });
                            },
                            icon: Icon(secure? Icons.visibility_off:Icons.visibility)
                        )
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                          if (formKey.currentState!.validate()) {
                            cubit.login(emailController.text.trim(), passwordController.text.trim());
                          }
                        },
                        child: state is AuthLoading
                            ? const CircularProgressIndicator()
                            : const Text("Login"),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// Navigate to Register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterScreen(),));
                          },
                          child: const Text("Register"),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}