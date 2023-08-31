import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:tracker/mapbadgeicon.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({Key? key}) : super(key: key);

  @override
  State<TrackingPage> createState() => TrackingPageState();
}

class TrackingPageState extends State<TrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  String maptheme = '';
  LocationData? currentLocation;
  late Location location;

  BitmapDescriptor currentLocIcon = BitmapDescriptor.defaultMarker;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  bool isRecording = false;
  double manualZoom = 14;

  void setCustomMarker() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/electronics.png')
        .then((icon) {
      setState(() {
        currentLocIcon = icon;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    location = Location();
    getCurrentLocation();
    loadMapTheme();
    setCustomMarker();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }

  void getCurrentLocation() async {
    try {
      currentLocation = await location.getLocation();
      polylineCoordinates.add(LatLng(
        currentLocation!.latitude!,
        currentLocation!.longitude!,
      ));
      setState(() {});
    } catch (e) {
      // Handle error
    }
  }

  void loadMapTheme() async {
    try {
      maptheme = await DefaultAssetBundle.of(context)
          .loadString('assets/google_map_style.json');
      setState(() {});
    } catch (e) {
      // Handle error
    }
  }

  void toggleRecording() {
    setState(() {
      isRecording = !isRecording;
      if (!isRecording) {
        polylineCoordinates.clear();
        polylines.clear();
      }
    });
  }

  void addLocationToPath() {
    if (currentLocation != null) {
      polylineCoordinates.add(
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      );
      polylines.add(
        Polyline(
          polylineId: const PolylineId('walkPath'),
          color: Colors.redAccent,
          points: polylineCoordinates,
        ),
      );
    }
  }

  void _goToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    if (currentLocation != null) {
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
          ),
          manualZoom,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: currentLocation == null || maptheme.isEmpty
          ? Center(
              child: lottie.Lottie.asset(
                'assets/animation_ll7hyekz.json',
                height: 150,
                reverse: true,
                repeat: true,
                fit: BoxFit.cover,
              ),
            )
          : Stack(
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      currentLocation!.latitude!,
                      currentLocation!.longitude!,
                    ),
                    zoom: manualZoom,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    controller.setMapStyle(maptheme);
                    _controller.complete(controller);

                    location.onLocationChanged.listen((newLoc) {
                      setState(() {
                        currentLocation = newLoc;
                        if (isRecording) {
                          addLocationToPath();
                        }
                      });
                    });
                  },
                  onCameraMove: (CameraPosition position) {
                    manualZoom = position.zoom;
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId('Arduino Location'),
                      icon: currentLocIcon,
                      position: LatLng(
                        currentLocation!.latitude!,
                        currentLocation!.longitude!,
                      ),
                    ),
                  },
                  polylines: polylines,
                ),
                Positioned(
                  bottom: 80,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      if (isRecording) {
                        addLocationToPath();
                      }
                      toggleRecording();
                    },
                    backgroundColor: Colors.white,
                    child: Icon(
                      isRecording ? Icons.stop : Icons.play_arrow,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 80,
                  left: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      _goToCurrentLocation();
                    },
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: MapBadgeIcon(),
                )
              ],
            ),
    );
  }
}
