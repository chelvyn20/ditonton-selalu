part of 'serial_list_bloc.dart';

class SerialListState extends Equatable {
  final RequestState serialListOnTheAirState;
  final RequestState serialListPopularState;
  final RequestState serialListTopRatedState;
  final String message;
  final List<Serial> data;

  const SerialListState({
    required this.serialListOnTheAirState,
    required this.serialListPopularState,
    required this.serialListTopRatedState,
    required this.message,
    required this.data,
  });

  SerialListState copyWith({
    RequestState? serialListOnTheAirState,
    RequestState? serialListPopularState,
    RequestState? serialListTopRatedState,
    String? message,
    List<Serial>? data,
  }) {
    return SerialListState(
      serialListOnTheAirState:
          serialListOnTheAirState ?? this.serialListOnTheAirState,
      serialListPopularState:
          serialListPopularState ?? this.serialListPopularState,
      serialListTopRatedState:
          serialListTopRatedState ?? this.serialListTopRatedState,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory SerialListState.initial() => const SerialListState(
        serialListOnTheAirState: RequestState.empty,
        serialListPopularState: RequestState.empty,
        serialListTopRatedState: RequestState.empty,
        message: '',
        data: <Serial>[],
      );

  @override
  List<Object> get props => [
        serialListOnTheAirState,
        serialListPopularState,
        serialListTopRatedState,
        message,
        data,
      ];
}
