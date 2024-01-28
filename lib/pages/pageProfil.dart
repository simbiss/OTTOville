import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class pageProfil extends StatefulWidget {
  @override
  _pageProfilState createState() => _pageProfilState();
}

class _pageProfilState extends State<pageProfil> {
  bool isDarkModeEnabled = false;
  bool isEcoFriendly = true;
  int userScore = 80;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Score: $userScore',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dark Mode'),
                Switch(
                  value: isDarkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      isDarkModeEnabled = value;
                      // Appliquer ici la logique pour activer/désactiver le mode sombre
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20.0),
            const Text(
              'Eco-Friendly',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              isEcoFriendly
                  ? 'You are Eco-Friendly! 🌿'
                  : 'You can do better! 🚫',
              style: TextStyle(
                fontSize: 16.0,
                color: isEcoFriendly ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            tabBackgroundColor: Theme.of(context).colorScheme.primary,
            activeColor: Theme.of(context).colorScheme.onPrimary,
            gap: 12,
            padding: const EdgeInsets.all(20),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.history,
                text: 'Favorites',
              ),
              GButton(
                icon: Icons.add,
                text: 'Add',
              ),
              GButton(icon: Icons.account_circle, text: 'Profile')
            ],
          ),
        ),
      ),
    );
  }
}
