import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    void setMarkerIcon() async {
      //  myMarker = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(50.50)), 'assets/')
    }
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Where did you see this pokemon?',
        ),
        backgroundColor: Colors.red,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GoogleMap(
          gestureRecognizers: Set()
            ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
          mapType: MapType.hybrid,
          initialCameraPosition: const CameraPosition(
            target: LatLng(32.441137114269836, -90.14617535799968),
            zoom: 15,
          ),
          onMapCreated: (GoogleMapController controller) {},
          onLongPress: (latlang) {
            // _addMarkerLongPressed(latlang);
          },
          markers: Set<Marker>.of(markers.values),
        ),
      ),
    );
  }
}
