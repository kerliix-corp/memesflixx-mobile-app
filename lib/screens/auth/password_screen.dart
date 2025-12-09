import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class PasswordScreen extends StatefulWidget {
  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final passwordCtrl = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    final String identifier =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text("Enter Password")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Muted identifier with change button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    identifier,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Change"),
                  ),
                ],
              ),

              SizedBox(height: 20),

              TextField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 25),

              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() => isLoading = true);

                          final resp = await auth.login(
                              identifier, passwordCtrl.text.trim());

                          if (resp["token"] != null) {
                            if (resp["profileComplete"] == false) {
                              Navigator.pushReplacementNamed(
                                  context, "/auth/profile_setup");
                            } else {
                              Navigator.pushReplacementNamed(context, "/");
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      resp["message"] ?? "Incorrect password")),
                            );
                          }

                          setState(() => isLoading = false);
                        },
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : Text("Login"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
