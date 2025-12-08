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
  final dayCtrl = TextEditingController();
  final monthCtrl = TextEditingController();
  final yearCtrl = TextEditingController();
  String sex = "prefer not to say";
  bool isLoading = false;

  String get dobString {
    // Combine day, month, year into one string in YYYY-MM-DD format
    final day = dayCtrl.text.padLeft(2, '0');
    final month = monthCtrl.text.padLeft(2, '0');
    final year = yearCtrl.text;
    if (day.isEmpty || month.isEmpty || year.isEmpty) return "";
    return "$year-$month-$day";
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Profile Setup")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // First Name
              TextField(
                controller: firstCtrl,
                decoration: InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // Last Name
              TextField(
                controller: lastCtrl,
                decoration: InputDecoration(
                  labelText: "Last Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // Date of Birth - 3 boxes in a row
              Row(
                children: [
                  // Day
                  Expanded(
                    child: TextField(
                      controller: dayCtrl,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        counterText: "",
                        labelText: "DD",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),

                  // Month
                  Expanded(
                    child: TextField(
                      controller: monthCtrl,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        counterText: "",
                        labelText: "MM",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),

                  // Year
                  Expanded(
                    child: TextField(
                      controller: yearCtrl,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        counterText: "",
                        labelText: "YYYY",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15),

              // Sex Dropdown
              DropdownButtonFormField<String>(
                value: sex,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: ["male", "female", "prefer not to say"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => sex = v!),
              ),

              SizedBox(height: 25),

              // Continue Button with spinner
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() => isLoading = true);

                          final ok = await auth.setupProfile(
                            firstCtrl.text,
                            lastCtrl.text,
                            dobString, // send combined DOB string
                            sex,
                          );

                          if (ok) {
                            Navigator.pushReplacementNamed(context, "/");
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
                            Text("Saving..."),
                          ],
                        )
                      : Text("Continue"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
