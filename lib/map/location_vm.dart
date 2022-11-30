import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';

class LocationViewModel extends BaseViewModel {
  Position? position;
  String address = 'Location will show here';

  LocationViewModel() {
    getGeoLocationPosition();
    // onGetAutoLocation();
  }

  onGetAutoLocation() async {
    await getGeoLocationPosition();
    if (position != null) {
      Timer.periodic(Duration(seconds: 10), ((timer) {
        getAddressFromLatLong();
      }));
    }
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
    final Email email = Email(
      body: address,
      subject: 'Email subject',
      recipients: ['ahcheema12@gmail.com'],
      cc: ['ahcheema12@gmail.com'],
      bcc: ['bcc@example.com'],
      isHTML: false,
    );
    setBusy(false);
    await FlutterEmailSender.send(email);
  }
}
