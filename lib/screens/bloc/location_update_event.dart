part of 'location_update_bloc.dart';

abstract class LocationUpdateEvent extends Equatable {
  const LocationUpdateEvent();
}

class LocationUpdate extends LocationUpdateEvent {
  final double latitude;
  final double longitude;
  const LocationUpdate({required this.latitude, required this.longitude});

  @override
  List<Object> get props => [latitude, longitude, Random().nextInt(100)];
}
