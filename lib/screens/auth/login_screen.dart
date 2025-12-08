import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final identifierCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool showPasswordField = false;
  bool isLoading = false;
  String? serverUserId;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: identifierCtrl,
              decoration: InputDecoration(
                labelText: "Email or Username",
              ),
            ),

            if (showPasswordField) ...[
              SizedBox(height: 20),
              TextField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                ),
              ),
            ],

            SizedBox(height: 25),
            ElevatedButton(
              child: Text(isLoading
                  ? "Loading..."
                  : showPasswordField
                      ? "Login"
                      : "Next"),
              onPressed: () async {
                if (isLoading) return;

                setState(() => isLoading = true);

                if (!showPasswordField) {
                  final resp = await auth.identifier(identifierCtrl.text);

                  if (resp["exists"] == true) {
                    if (resp["verified"] == true) {
                      setState(() => showPasswordField = true);
                    } else {
                      Navigator.pushNamed(context, "/verify");
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("User not found"),
                    ));
                  }
                } else {
                  final resp = await auth.login(identifierCtrl.text, passwordCtrl.text);

                  if (resp["token"] != null) {
                    Navigator.pushReplacementNamed(context, "/home");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(resp["message"] ?? "Login failed"),
                    ));
                  }
                }

                setState(() => isLoading = false);
              },
            ),

            TextButton(
              child: Text("Create Account"),
              onPressed: () => Navigator.pushNamed(context, "/register"),
            )
          ],
        ),
      ),
    );
  }
}
