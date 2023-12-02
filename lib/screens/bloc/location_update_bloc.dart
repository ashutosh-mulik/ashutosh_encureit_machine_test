import 'dart:async';
import 'dart:math';

import 'package:ashutosh_encureit_machine_test/screens/data/location_update_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'location_update_event.dart';
part 'location_update_state.dart';

class LocationUpdateBloc extends Bloc<LocationUpdateEvent, LocationUpdateState> {
  final LocationUpdateService _locationUpdateService = LocationUpdateService();

  LocationUpdateBloc() : super(LocationUpdateInitial()) {
    on<LocationUpdateEvent>((event, emit) {});
    on<LocationUpdate>(_mapUpdateToState);
  }

  FutureOr<void> _mapUpdateToState(LocationUpdate event, Emitter<LocationUpdateState> emit) async {
    try {
      var response = await _locationUpdateService.updateLocation(latitude: event.latitude, longitude: event.longitude);
      emit(LocationUpdateSuccess(message: response));
    } catch (e) {
      emit(LocationUpdateError(error: e.toString()));
    }
  }
}
