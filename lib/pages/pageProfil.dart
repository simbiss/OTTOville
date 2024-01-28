import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'RouteConter.dart';

class pageProfil extends StatefulWidget {
  @override
  _pageProfilState createState() => _pageProfilState();
}

class _pageProfilState extends State<pageProfil> {
  bool isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    MyAppState appState = context.read<MyAppState>();

    int ecoScore = appState.routeCounter.countEcologique;
    int rapideScore = appState.routeCounter.countRapide;

    int maxValue = 10;

    int totalScore = ecoScore + rapideScore;
    int totalScorePercentage = ecoScore - rapideScore;

    double percentage =
        (totalScorePercentage / maxValue * 100).clamp(0.0, 100.0);

    print("eco score ${ecoScore}");

    return Scaffold(
      appBar: AppBar(
        title: Text('User Activities'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Trips: $totalScore',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Text(
              'EcoFriendly Trips: $ecoScore',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Percentage: ${percentage.toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 20.0),
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
              percentage >= 50
                  ? 'You are Eco-Friendly! 🌿'
                  : 'You can do better! 🚫',
              style: TextStyle(
                fontSize: 16.0,
                color: percentage >= 50 ? Colors.green : Colors.red,
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
