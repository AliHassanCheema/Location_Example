import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';

class LocationViewModel extends BaseViewModel{
  Position? position;
  String address = 'Location will show here';

  LocationViewModel(){
    getGeoLocationPosition();
  }

  Future<Position> getGeoLocationPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    debugPrint(serviceEnabled.toString());
    if (!serviceEnabled) {
      // await Geolocator.openLocationSettings();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
        if (permission == LocationPermission.deniedForever) {
          return Future.error(
              'Location permissions are permanently denied, we cannot request permissions.');
        }
      }
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } else {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }
    return position!;
  }

  Future<void> getAddressFromLatLong() async {
    setBusy(true);
    await getGeoLocationPosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);
    Placemark place = placemarks[0];
    address =
        '${place.street}, ${place.thoroughfare}, ${place.subLocality}, ${place.administrativeArea} , ${place.country}';
    setBusy(false);
  }

}