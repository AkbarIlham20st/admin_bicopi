import 'package:flutter/material.dart';
import 'user_account.dart';
import 'admin_account.dart';
import 'affiliate_account.dart';

class OptionPage extends StatelessWidget {
  const OptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Option')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UserAccount(),
            const SizedBox(height: 16),
            const AdminAccount(),
            const SizedBox(height: 16),
            const AffiliateAccount(),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: handle logout
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}