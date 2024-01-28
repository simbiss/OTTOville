class RouteCounter {
  int countEcologique = 0;
  int countRapide = 0;

  void saveRoute(String type) {
    if (type == 'Fastest Route') {
      countRapide++;
    } else if (type == 'Ecological Route') {
      countEcologique++;
    }
  }
}
