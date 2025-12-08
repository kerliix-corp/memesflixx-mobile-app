import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    // If user not loaded yet
    if (auth.user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = auth.user!;
    final profile = user.profile ?? {};

    final String firstName = profile["firstName"] ?? "";
    final String lastName = profile["lastName"] ?? "";
    final String bio = profile["bio"] ?? "No bio yet";
    final int posts = profile["posts"] ?? 0;
    final int followers = profile["followers"] ?? 0;
    final int following = profile["following"] ?? 0;

    // Make initials
    String initials = (firstName + " " + lastName)
        .trim()
        .split(" ")
        .where((e) => e.isNotEmpty)
        .map((e) => e[0])
        .take(2)
        .join()
        .toUpperCase();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blueAccent,
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Full name
          Text(
            "$firstName $lastName".trim().isEmpty
                ? user.username
                : "$firstName $lastName",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),

          // Email
          Text(
            user.email,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Bio
          Text(
            bio,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),

          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat("Posts", posts),
              _buildStat("Followers", followers),
              _buildStat("Following", following),
            ],
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile/edit');
                },
                child: const Text("Edit Profile"),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
                child: const Text("Settings"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
