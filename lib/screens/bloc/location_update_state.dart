part of 'location_update_bloc.dart';

abstract class LocationUpdateState extends Equatable {
  const LocationUpdateState();
}

class LocationUpdateInitial extends LocationUpdateState {
  @override
  List<Object> get props => [];
}

class LocationUpdateLoading extends LocationUpdateState {
  @override
  List<Object> get props => [];
}

class LocationUpdateError extends LocationUpdateState {
  final String error;
  const LocationUpdateError({required this.error});

  @override
  List<Object> get props => [error, Random().nextInt(100)];
}

class LocationUpdateSuccess extends LocationUpdateState {
  final String message;
  const LocationUpdateSuccess({required this.message});

  @override
  List<Object> get props => [message, Random().nextInt(100)];
}
