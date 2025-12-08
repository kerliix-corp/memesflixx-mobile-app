import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class VerifyEmailScreen extends StatefulWidget {
  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final codeCtrl = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Verify Email")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Enter the 8-digit code sent to your email."),
            SizedBox(height: 20),
            TextField(
              controller: codeCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Verification Code"),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text(loading ? "Verifying..." : "Verify"),
              onPressed: () async {
                setState(() => loading = true);

                final resp = await auth.verifyCode(codeCtrl.text);

                if (resp["token"] != null) {
                  Navigator.pushReplacementNamed(context, "/profile-setup");
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(resp["message"] ?? "Invalid code")),
                  );
                }

                setState(() => loading = false);
              },
            )
          ],
        ),
      ),
    );
  }
}
