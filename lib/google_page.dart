import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:example/google_map_view_model.dart';
import 'package:hooks_riverpod/all.dart';

class GooglePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('google map'),
      ),
      body: Center(
        child: Body(),
      ),
    );
  }
}

class Body extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _latLng =
        useProvider(googleMapViewModel.select((value) => value.latLng));
    if (_latLng != null) {
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            polylines: context.read(googleMapViewModel).polylines,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: context.read(googleMapViewModel).latLng,
              zoom: 14.4746,
            ),
            //markers: _markers,
            onCameraMove: context.read(googleMapViewModel).onCameraMove,
            onMapCreated: (GoogleMapController controller) {
              context.read(googleMapViewModel).onMapCreated(controller);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
        ),
      );
    } else {
      return Center(
        child: Text('Loading'),
      );
    }
  }
}
