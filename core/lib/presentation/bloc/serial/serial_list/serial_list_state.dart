part of 'serial_list_bloc.dart';

class SerialListState extends Equatable {
  final RequestState serialListOnTheAirState;
  final RequestState serialListPopularState;
  final RequestState serialListTopRatedState;
  final List<Serial> slOnTheAirData;
  final List<Serial> slPopularData;
  final List<Serial> slTopRatedData;
  final String message;

  const SerialListState({
    required this.serialListOnTheAirState,
    required this.serialListPopularState,
    required this.serialListTopRatedState,
    required this.slOnTheAirData,
    required this.slPopularData,
    required this.slTopRatedData,
    required this.message,
  });

  @override
  List<Object> get props {
    return [
      serialListOnTheAirState,
      serialListPopularState,
      serialListTopRatedState,
      slOnTheAirData,
      slPopularData,
      slTopRatedData,
      message,
    ];
  }

  SerialListState copyWith({
    RequestState? serialListOnTheAirState,
    RequestState? serialListPopularState,
    RequestState? serialListTopRatedState,
    List<Serial>? slOnTheAirData,
    List<Serial>? slPopularData,
    List<Serial>? slTopRatedData,
    String? message,
  }) {
    return SerialListState(
      serialListOnTheAirState:
          serialListOnTheAirState ?? this.serialListOnTheAirState,
      serialListPopularState:
          serialListPopularState ?? this.serialListPopularState,
      serialListTopRatedState:
          serialListTopRatedState ?? this.serialListTopRatedState,
      slOnTheAirData: slOnTheAirData ?? this.slOnTheAirData,
      slPopularData: slPopularData ?? this.slPopularData,
      slTopRatedData: slTopRatedData ?? this.slTopRatedData,
      message: message ?? this.message,
    );
  }

  factory SerialListState.initial() => const SerialListState(
        serialListOnTheAirState: RequestState.empty,
        serialListPopularState: RequestState.empty,
        serialListTopRatedState: RequestState.empty,
        slOnTheAirData: <Serial>[],
        slPopularData: <Serial>[],
        slTopRatedData: <Serial>[],
        message: '',
      );
}
