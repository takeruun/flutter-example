import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:example/provider/app_shared_preferences_provider.dart';
import 'package:example/provider/location_list_provider.dart';
import 'package:example/google_map_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleMapPage extends StatelessWidget {
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
    final _userUid =
        useProvider(googleMapViewModel.select((value) => value.targetUserUid));
    final provider = useProvider(locationListProvider('apple'));
    final snapshot = useFuture(provider);
    if (snapshot.connectionState == ConnectionState.done) {
      context.read(googleMapViewModel).rewritePolyline(snapshot.data);
    }
    final _initialLatLng =
        useProvider(googleMapViewModel.select((value) => value.initialLatLng));
    final expectedTIme =
        useProvider(googleMapViewModel.select((value) => value.expectedTime));
    if (_initialLatLng != null) {
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            polylines: context.read(googleMapViewModel).polylines,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: context.read(googleMapViewModel).initialLatLng,
              zoom: 14.4746,
            ),
            markers: context.read(googleMapViewModel).markers,
            onCameraMove: context.read(googleMapViewModel).onCameraMove,
            onMapCreated: context.read(googleMapViewModel).onMapCreated,
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
