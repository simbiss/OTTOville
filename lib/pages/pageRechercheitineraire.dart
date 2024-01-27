import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  List<String> _searchResults = [];

  void _search() {
    // Ici, vous implémenteriez la logique de recherche et mettez à jour
    // la liste _searchResults avec les résultats obtenus.
    // Pour cet exemple, nous allons juste ajouter des résultats factices.
    setState(() {
      _searchResults = [
        'Résultat 1',
        'Résultat 2',
        'Résultat 3',
        // Ajoutez vos résultats de recherche ici
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche Itinéraire'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _startController,
              decoration: InputDecoration(
                labelText: 'Votre position',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.my_location),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _destinationController,
              decoration: InputDecoration(
                labelText: 'Destination',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.location_pin),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _search,
              child: Text('Recherche'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_searchResults[index]),
                    leading: Icon(Icons.place),
                    onTap: () {
                      // Implémentez ce qui se passe quand on appuie sur un résultat
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
