import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isLogin = true;
  bool passwordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    setState(() => isLoading = true);
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email and password are required")),
        );
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Auth state listener in main.dart will handle navigation.
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";
      if (e.code == 'user-not-found') {
        message = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        message = "Wrong password provided.";
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login error: $e")));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> signUp() async {
    setState(() => isLoading = true);
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email and password are required")),
        );
        return;
      }

      if (password.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password must be at least 6 characters.")),
        );
        return;
      }
    } on FirebaseAuthException catch (e) {
      String message = "Sign up failed: ${e.code} - ${e.message}";
      if (e.code == 'email-already-in-use')
        message = "Email already in use.";
      else if (e.code == 'weak-password')
        message = "Password is too weak.";
      else if (e.code == 'invalid-email')
        message = "Invalid email address.";
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Sign up error: $e")));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff669bbc),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xfffdf0d5),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isLogin ? "Login" : "Create Account",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff003049),
                  ),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: !passwordVisible,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => passwordVisible = !passwordVisible),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                isLoading
                    ? CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (isLogin) {
                                    signIn();
                                  } else {
                                    signUp();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xff003049),
                                  const Color(0xff669bbc),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                isLogin ? "Login" : "Sign Up",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: 16),
                // Stacked vertically
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => setState(() => isLogin = !isLogin),
                      child: Text(
                        isLogin
                            ? "Don't have an account? Sign up"
                            : "Already have an account? Login",
                        style: TextStyle(color: const Color(0xff780000)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
