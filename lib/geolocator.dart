import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ggoogle_map_consule/goole_map.dart';

class GeolocatorScreen extends StatefulWidget {
  const GeolocatorScreen({Key? key}) : super(key: key);

  @override
  State<GeolocatorScreen> createState() => _GeolocatorScreenState();
}

class _GeolocatorScreenState extends State<GeolocatorScreen> {
   late Position cl;
  Future getPermission()async
  {
    bool? services;
    LocationPermission permission;

    services = await Geolocator.isLocationServiceEnabled();
    if(!services)
    {
      showDialog(
          context: context,
          builder: (BuildContext context)=>  AlertDialog(
            title: const Text(
                'Services',
            ),
            actions: [
              TextButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                },
                child: const Text(
                  'OK',
                ),
              ),
            ],
            content: const Text(
              'Services is disabled do you want enabled',
            ),
          ),
      );
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied)
    {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.always)
    {
      getLagAndLong();
    }

    print(permission);
  }

  Future<Position> getLagAndLong()async
  {
    return await Geolocator.getCurrentPosition().then((value) => value);
  }
  @override
  void initState() {
    getPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Geolocator',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                onPressed:()async
                {
                  cl = await getLagAndLong();
                  print('Lat: ${cl.latitude}');
                  print('Long: ${cl.longitude}');

                  List<Placemark> placemarks =
                  await placemarkFromCoordinates(cl.latitude, cl.longitude);
                  print(placemarks[0].street);
              },
                child: const Text(
                  'Show Long and Lat'
                ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Center(
            child: ElevatedButton(
                onPressed:()
                {
                  var distance = Geolocator.
                  distanceBetween(30.798992, 31.005196, 30.966331, 31.186631);
                  print('Distance: ${distance/1000}');
                },
                child: const Text(
                  'Distance'
                ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Center(
            child: ElevatedButton(
              onPressed:()
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GoogleMapScreen(),
                  ),
                );
              },
              child: const Text(
                  'Navigator To Map',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//30.798992
//31.005196

//30.966331
//31.186631


