import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final firstCtrl = TextEditingController();
  final lastCtrl = TextEditingController();
  DateTime? dob;
  String sex = "prefer not to say";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Profile Setup")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: firstCtrl, decoration: InputDecoration(labelText: "First Name")),
            SizedBox(height: 15),
            TextField(controller: lastCtrl, decoration: InputDecoration(labelText: "Last Name")),
            SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dob == null ? "No DOB Selected" : dob.toString().split(" ")[0]),
                TextButton(
                  child: Text("Pick DOB"),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) setState(() => dob = date);
                  },
                ),
              ],
            ),

            DropdownButton<String>(
              value: sex,
              items: ["male", "female", "prefer not to say"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => sex = v!),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              child: Text(loading ? "Saving..." : "Continue"),
              onPressed: () async {
                setState(() => loading = true);

                final ok = await auth.setupProfile(
                  firstCtrl.text,
                  lastCtrl.text,
                  dob?.toIso8601String() ?? "",
                  sex,
                );

                if (ok) {
                  Navigator.pushReplacementNamed(context, "/home");
                }

                setState(() => loading = false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
