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

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center( // Center all content vertically & horizontally
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Email/Username Field
              TextField(
                controller: identifierCtrl,
                decoration: InputDecoration(
                  labelText: "Email or Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              if (showPasswordField) ...[
                SizedBox(height: 20),
                // Password Field
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
              ],

              SizedBox(height: 25),

              // Login/Next Button with spinner
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading ? null : () async {
                    setState(() => isLoading = true);

                    if (!showPasswordField) {
                      final resp = await auth.identifier(identifierCtrl.text);

                      if (resp["exists"] == true) {
                        if (resp["verified"] == true) {
                          setState(() => showPasswordField = true);
                        } else {
                          Navigator.pushNamed(context, "/auth/password");
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("User not found")),
                        );
                      }
                    } else {
                      final resp = await auth.login(
                        identifierCtrl.text,
                        passwordCtrl.text,
                      );

                      if (resp["token"] != null) {
                        Navigator.pushReplacementNamed(context, "/");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(resp["message"] ?? "Login failed"),
                          ),
                        );
                      }
                    }

                    setState(() => isLoading = false);
                  },
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(showPasswordField ? "Logging in..." : "Loading..."),
                          ],
                        )
                      : Text(showPasswordField ? "Login" : "Next"),
                ),
              ),

              TextButton(
                child: Text("Create Account"),
                onPressed: () => Navigator.pushNamed(context, "/auth/register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
