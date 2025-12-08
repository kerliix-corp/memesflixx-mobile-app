import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Create Account")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: "Email")),
            SizedBox(height: 15),
            TextField(controller: usernameCtrl, decoration: InputDecoration(labelText: "Username")),
            SizedBox(height: 15),
            TextField(controller: passwordCtrl, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text(isLoading ? "Loading..." : "Register"),
              onPressed: () async {
                setState(() => isLoading = true);

                final resp = await auth.register(
                  emailCtrl.text,
                  usernameCtrl.text,
                  passwordCtrl.text,
                );

                if (resp["userId"] != null) {
                  Navigator.pushNamed(context, "/verify");
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(resp["message"] ?? "Failed")),
                  );
                }

                setState(() => isLoading = false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
