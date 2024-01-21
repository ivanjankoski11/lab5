import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mis_lab3/directions.dart';
import 'package:mis_lab3/directions_model.dart';
import 'package:mis_lab3/locationservice.dart';
import 'package:mis_lab3/main.dart';

class Maps extends StatefulWidget {
  final List<Exam> exams;

  Maps({required this.exams});
  @override
  State<StatefulWidget> createState() => __MapsState();
}

class __MapsState extends State<Maps> {
  static final CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(42.00413912838317, 21.40955173928061), zoom: 19);
  late GoogleMapController _googleMapController;
  late Marker _initial = Marker(markerId: MarkerId('initial'));
  late Marker _destination = Marker(markerId: MarkerId('destination'));
  late LatLng currentPosition;
  late Directions _info;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: _getMarkers(),
            onLongPress: _addMarker,
            // polylines: {
            //   if (_info?.polylinePoints != null &&
            //       _info.polylinePoints.isNotEmpty)
            //     Polyline(
            //       polylineId: const PolylineId('overview_polyline'),
            //       color: Colors.red,
            //       width: 5,
            //       points: _info.polylinePoints
            //           .map((e) => LatLng(e.latitude, e.longitude))
            //           .toList(),
            //     )
            // },
          ),
          // if (_info != null)
          // Positioned(
          //   top: 20,
          //   child: Container(
          //     padding:
          //         const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          //     decoration: BoxDecoration(
          //       color: Colors.yellowAccent,
          //       borderRadius: BorderRadius.circular(20),
          //       boxShadow: const [
          //         BoxShadow(
          //           color: Colors.black26,
          //           offset: Offset(0, 2),
          //           blurRadius: 6,
          //         )
          //       ],
          //     ),
          //     child: Text(
          //       '${_info.totalDistance}, ${_info.totalDuration}',
          //       style: const TextStyle(
          //           fontSize: 18, fontWeight: FontWeight.w600),
          //     ),
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void _addMarker(LatLng pos) {
    if (_initial == null || (_initial != null && _destination != null)) {
      setState(() {
        _initial = Marker(
            markerId: const MarkerId('initial'),
            infoWindow: const InfoWindow(title: 'Initial'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: pos);
      });
    } else {
      setState(() {
        _destination = Marker(
            markerId: const MarkerId('destination'),
            infoWindow: const InfoWindow(title: 'Destination'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            position: pos);
      });
    }
  }

  Set<Marker> _getMarkers() {
    List<Exam> exams = widget.exams;
    return exams
        .map((e) => Marker(
            markerId: MarkerId(e.subject),
            position: e.pos,
            infoWindow: InfoWindow(title: e.subject, snippet: e.lab),
            ))
        .toSet();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }
}
