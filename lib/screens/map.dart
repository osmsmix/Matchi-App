import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  static const String screenRoute = 'map';

  const MapPage({super.key}); 
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  LatLng? _selectedPosition;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }

  void _onTapMap(LatLng position) {
    setState(() {
      _selectedPosition = position;
    });
    _controller?.animateCamera(CameraUpdate.newLatLng(position));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélectionnez une position'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(48.8534, 2.3488),
          zoom: 12,
        ),
        onTap: _onTapMap,
        markers: _selectedPosition != null ? {
          Marker(
            markerId: const MarkerId('selected_position'),
            position:_selectedPosition! ,
          ),
        } : {},
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          // Récupérez la position sélectionnée
          Navigator.of(context).pop(_selectedPosition);
        },
      ),
    );
  }
}
