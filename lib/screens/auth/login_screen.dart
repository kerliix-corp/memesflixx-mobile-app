import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final identifierCtrl = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Email or username
              TextField(
                controller: identifierCtrl,
                decoration: InputDecoration(
                  labelText: "Email or Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 25),

              // NEXT button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() => isLoading = true);

                          final resp =
                              await auth.identifier(identifierCtrl.text.trim());

                          if (resp["exists"] == true) {
                            if (resp["verified"] == false) {
                              // Redirect to verification page
                              Navigator.pushNamed(
                                context,
                                "/auth/verify",
                                arguments: {"email": resp["email"]},
                              );
                            } else {
                              // Identifier correct → move to password screen
                              Navigator.pushNamed(
                                context,
                                "/auth/password",
                                arguments: identifierCtrl.text.trim(),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("User not found")),
                            );
                          }

                          setState(() => isLoading = false);
                        },
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : Text("Next"),
                ),
              ),

              SizedBox(height: 10),

              TextButton(
                child: Text("Create Account"),
                onPressed: () =>
                    Navigator.pushNamed(context, "/auth/register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
