part of 'serial_list_bloc.dart';

abstract class SerialListEvent extends Equatable {
  const SerialListEvent();

  @override
  List<Object> get props => [];
}

class FetchOnTheAirSerials extends SerialListEvent {
  const FetchOnTheAirSerials();

  @override
  List<Object> get props => [];
}

class FetchPopularSerials extends SerialListEvent {
  const FetchPopularSerials();

  @override
  List<Object> get props => [];
}

class FetchTopRatedSerials extends SerialListEvent {
  const FetchTopRatedSerials();

  @override
  List<Object> get props => [];
}
