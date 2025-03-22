import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class FieldMapMarker extends StatefulWidget {
  @override
  _FieldMapMarkerState createState() => _FieldMapMarkerState();
}

class _FieldMapMarkerState extends State<FieldMapMarker> {
  LatLng? currentLocation;
  List<LatLng> markers = [];
  double enclosedArea = 0.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location permissions are permanently denied.'),
          ),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void _addMarker(LatLng latLng) {
    if (markers.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only add up to 6 markers.')),
      );
      return;
    }
    setState(() {
      markers.add(latLng);
      if (markers.length >= 4) {
        enclosedArea = _calculateArea(markers);
      }
    });
  }

  void _undoMarker() {
    if (markers.isNotEmpty) {
      setState(() {
        markers.removeLast();
        enclosedArea = markers.length >= 4 ? _calculateArea(markers) : 0.0;
      });
    }
  }

  double _calculateArea(List<LatLng> points) {
    if (points.length < 4) return 0.0;

    double toRadians(double degree) => degree * pi / 180;
    double latToMeters = 111320;

    List<Point> coords =
        points.map((point) {
          double x =
              toRadians(point.longitude) *
              latToMeters *
              cos(toRadians(point.latitude));
          double y = toRadians(point.latitude) * latToMeters;
          return Point(x, y);
        }).toList();

    double area = 0.0;
    int n = coords.length;
    for (int i = 0; i < n; i++) {
      int j = (i + 1) % n;
      area += coords[i].x * coords[j].y - coords[j].x * coords[i].y;
    }
    return area.abs() / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Field Map Marker')),
      body:
          currentLocation == null
              ? Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: currentLocation!,
                      initialZoom: 15,
                      minZoom: 5,
                      maxZoom: 19,
                      onTap: (tapPosition, latLng) => _addMarker(latLng),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName:
                            'net.tlserver5y.flutter_map_location_marker.example',
                        maxZoom: 19,
                      ),
                      CurrentLocationLayer(
                        style: LocationMarkerStyle(
                          marker: DefaultLocationMarker(
                            child: Icon(
                              Icons.navigation,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          markerSize: Size(40, 40),
                          markerDirection: MarkerDirection.heading,
                        ),
                      ),
                      if (markers.length >= 4)
                        PolygonLayer(
                          polygons: [
                            Polygon(
                              points: markers,
                              borderColor: Colors.blue,
                              borderStrokeWidth: 3,
                              color: Colors.blue.withOpacity(0.3),
                            ),
                          ],
                        ),
                      MarkerLayer(
                        markers:
                            markers
                                .map(
                                  (latLng) => Marker(
                                    width: 40,
                                    height: 40,
                                    point: latLng,
                                    child: Icon(
                                      Icons.location_pin,
                                      color: Colors.blue,
                                      size: 40,
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Latitude: ${currentLocation!.latitude}, Longitude: ${currentLocation!.longitude}',
                            style: TextStyle(color: Colors.white),
                          ),
                          if (markers.length >= 4)
                            Text(
                              'Enclosed Area: ${enclosedArea.toStringAsFixed(2)} deca.m',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    left: 20,
                    child: ElevatedButton(
                      onPressed: _undoMarker,
                      child: Text('Undo Last Marker'),
                    ),
                  ),
                ],
              ),
    );
  }
}
