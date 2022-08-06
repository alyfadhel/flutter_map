import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {

  //Start polyLine
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBftlA-NbCIJc4epB62b3Tp5D7dMnBJTLc";

  //End polyLine
  var lat;
  var long;
  CameraPosition? _kGooglePlex;
  StreamSubscription<Position>? positionStream;
  Position? cl;
  Set<Marker>? markers;

  Future<void> getLagAndLong() async {
    cl = await Geolocator.getCurrentPosition().then((value) => value);
    lat = cl?.latitude;
    long = cl?.longitude;
    _kGooglePlex = CameraPosition(
      target: LatLng(lat, long),
      zoom: 14.0,
      bearing: 9.0,
    );
    markers = {
      Marker(
        onTap: () {
          CameraPosition(
            target: LatLng(lat, long),
            zoom: 14.0,
            bearing: 20.0,
          );
        },
        markerId: const MarkerId(
          '1',
        ),
        position: LatLng(cl!.latitude, cl!.longitude),
        infoWindow: const InfoWindow(title: 'Tanta'),
      ),
    };
    setState(() {});
  }

  GoogleMapController? gmc;

  @override
  void initState() {
   positionStream = Geolocator.getPositionStream().listen(
           (Position? position) {
         print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
       });
    getLagAndLong();
    getPolyline();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Google Map',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _kGooglePlex == null
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: GoogleMap(
                      polylines: Set<Polyline>.of(polylines.values),
                      onTap: (latLang) {
                        markers!.remove(
                          const Marker(
                            markerId: MarkerId(
                              '1',
                            ),
                          ),
                        );
                        markers!.add(
                          Marker(
                            markerId: const MarkerId('1'),
                            position: latLang,
                          ),
                        );
                        setState((){});
                      },
                      mapType: MapType.normal,
                      markers: markers!,
                      initialCameraPosition: _kGooglePlex!,
                      onMapCreated: (GoogleMapController controller) {
                        gmc = controller;
                        print('Goooooooogle Map : ${GoogleMap}');
                      },
                    ),
                  ),
                ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                LatLng latLng = LatLng(cl!.latitude, cl!.longitude);
                gmc!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: latLng,
                      zoom: 18,
                      bearing: 45,
                      tilt: 45,
                    ),
                  ),
                );
              },
              child: const Text(
                'Google Map',
              ),
            ),
          ),
        ],
      ),
    );
  }

  addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        const PointLatLng(30.7990281, 31.0050984),
        const PointLatLng(30.818910, 30.815807),
        travelMode: TravelMode.driving,
    );
    // if (result.points.isNotEmpty) {
    //   result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(const LatLng(30.7990281, 31.0050984));
        polylineCoordinates.add(const LatLng(30.818910, 30.815807));
    //   });
    // }
    addPolyLine();
  }
}

//AIzaSyBftlA-NbCIJc4epB62b3Tp5D7dMnBJTLc
//30.811947
//30.819274
