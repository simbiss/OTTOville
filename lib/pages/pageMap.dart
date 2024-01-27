import 'package:app_ets_projet_durable/pages/Trajet.dart';
import 'package:flutter/material.dart';

class CollapsingAppbarPage extends StatelessWidget {
  const CollapsingAppbarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 300.0,
              floating: false,
              pinned: true,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                collapseMode: CollapseMode.parallax,
                title: const Text(
                  "Collapsing Appbar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                background: Image.network(
                  "https://images.pexels.com/photos/417173/pexels-photo-417173.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: ListView.builder(
          itemCount: trajets.length,
          itemBuilder: (BuildContext context, int index) {
            final item = trajets[index];
            return Container(
              height: 136,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.Id,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${item.PositionDepart} · ${item.PositionArrivee}",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.bookmark_border_rounded),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  /*Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(item.QteCo2NonEmis),
                      ),
                    ),
                  ),*/
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

List<Trajet> trajets = [
  Trajet(
    Id: "1",
    PositionDepart: "123 Avenue Mont-Royal, Montreal, QC",
    PositionArrivee: "456 Avenue du Parc, Montreal, QC",
    QteCo2NonEmis: 10,
  ),
  Trajet(
    Id: "2",
    PositionDepart: "789 Avenue Laurier, Montreal, QC",
    PositionArrivee: "101 Avenue des Pins, Montreal, QC",
    QteCo2NonEmis: 15,
  ),
  Trajet(
    Id: "3",
    PositionDepart: "234 Avenue Papineau, Montreal, QC",
    PositionArrivee: "567 Avenue Greene, Montreal, QC",
    QteCo2NonEmis: 8,
  ),
  Trajet(
    Id: "4",
    PositionDepart: "789 Avenue des Pins, Montreal, QC",
    PositionArrivee: "2345 Avenue du Mont-Royal, Montreal, QC",
    QteCo2NonEmis: 12,
  ),
  Trajet(
    Id: "5",
    PositionDepart: "678 Avenue McGill, Montreal, QC",
    PositionArrivee: "901 Avenue Saint-Denis, Montreal, QC",
    QteCo2NonEmis: 18,
  ),
  Trajet(
    Id: "6",
    PositionDepart: "3456 Avenue Laurier, Montreal, QC",
    PositionArrivee: "789 Avenue Atwater, Montreal, QC",
    QteCo2NonEmis: 14,
  ),
];
