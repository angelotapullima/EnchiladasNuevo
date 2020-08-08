import 'Dart:math';

class GeoUtils {

  static double _degreesToRadians(degrees) {
    return degrees * pi / 180;
  }

  static double distanceInKmBetweenEarthCoordinates(lat1, lon1, lat2, lon2) {
    var earthRadiusKm = 6371;

    var dLat = _degreesToRadians(lat2-lat1);
    var dLon = _degreesToRadians(lon2-lon1);

    lat1 = _degreesToRadians(lat1);
    lat2 = _degreesToRadians(lat2);

    var a = sin(dLat/2) * sin(dLat/2) +
        sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2);
    var c = 2 * atan2(sqrt(a), sqrt(1-a));
    return earthRadiusKm * c;
  }
}