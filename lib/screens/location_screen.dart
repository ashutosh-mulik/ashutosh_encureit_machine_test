import 'dart:io';

import 'package:ashutosh_encureit_machine_test/screens/bloc/location_update_bloc.dart';
import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Location? _location;
  final LocationUpdateBloc _locationUpdateBloc = LocationUpdateBloc();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    BackgroundLocation.getLocationUpdates((location) {
      setState(() => _location = location);
      setState(() => _loading = false);
      if (location.latitude != null && location.longitude != null) {
        _locationUpdateBloc.add(LocationUpdate(latitude: location.latitude!, longitude: location.longitude!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationUpdateBloc, LocationUpdateState>(
      bloc: _locationUpdateBloc,
      listener: (context, state) {
        if (state is LocationUpdateSuccess) {
          Fluttertoast.showToast(msg: state.message);
        }

        if (state is LocationUpdateError) {
          Fluttertoast.showToast(msg: state.error, toastLength: Toast.LENGTH_LONG);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("EncureIT Machine Test"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.1),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Location Status",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text("Latitude : ${_location?.latitude ?? "Unknown"}"),
                  Text("Longitude : ${_location?.longitude ?? "Unknown"}"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                child: Text(_getText()),
                onPressed: () async {
                  try {
                    if (_loading) return;

                    if (_location != null) {
                      await BackgroundLocation.stopLocationService();
                      setState(() => _location = null);
                      return;
                    }

                    setState(() => _loading = true);
                    await _requestPermission();
                    await _startService();
                  } catch (e) {
                    _showToast(message: e.toString());
                    setState(() => _loading = false);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestPermission() async {
    if (await Permission.location.isRestricted || await Permission.locationAlways.isRestricted) {
      // The OS restricts access, for example, because of parental controls.
      throw "The OS restricts access";
    }

    var locationStatus = await Permission.location.status;

    if (locationStatus.isPermanentlyDenied) {
      throw "Please enable location service from settings.";
    }

    if (locationStatus.isDenied) {
      // We haven't asked for permission yet or the permission has been denied before, but not permanently.
      locationStatus = await Permission.location.request();
      if (locationStatus.isDenied) throw "Please allow location permission.";
    }

    var backgroundLocationStatus = await Permission.locationAlways.status;
    if (backgroundLocationStatus.isPermanentlyDenied) {
      throw "Please enable all time location from settings.";
    }

    if (backgroundLocationStatus.isDenied) {
      backgroundLocationStatus = await Permission.locationAlways.request();
      if (backgroundLocationStatus.isDenied) throw "Please allow all time location permission.";
    }
  }

  Future _startService() async {
    if (Platform.isAndroid) {
      await BackgroundLocation.setAndroidNotification(
        title: "EncureIT Machine Test",
        message: "EncureIT Machine Test",
        icon: "@mipmap/ic_launcher",
      );
      await BackgroundLocation.setAndroidConfiguration(1000);
    }
    await BackgroundLocation.startLocationService();
  }

  void _showToast({required String message}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  String _getText() {
    if (_loading) return "Starting Service...";
    return "${_location == null ? "Start" : "Stop"} Location Tracking";
  }
}
