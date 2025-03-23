import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<String> getCityName() async {
  try {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return "Location services disabled";
    }

    // Check permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return "Permission denied";
      }
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );

    // Reverse geocoding to get placemark
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    String city = placemarks.first.locality ?? "City not found";
    print(city);
    return city;
  } catch (e) {
    print(e.toString());
    return "Error: ${e.toString()}";
  }
}
