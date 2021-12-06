import 'package:core/domain/entities/serial.dart';
import 'package:core/domain/usecases/get_on_the_air_serials.dart';
import 'package:core/domain/usecases/get_popular_serials.dart';
import 'package:core/domain/usecases/get_top_rated_serials.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'serial_list_event.dart';
part 'serial_list_state.dart';

class SerialListBloc extends Bloc<SerialListEvent, SerialListState> {
  final GetOnTheAirSerials _getOnTheAirSerials;
  final GetPopularSerials _getPopularSerials;
  final GetTopRatedSerials _getTopRatedSerials;

  SerialListBloc(
    this._getOnTheAirSerials,
    this._getPopularSerials,
    this._getTopRatedSerials,
  ) : super(SerialListState.initial()) {
    on<FetchOnTheAirSerials>(
      (event, emit) async {
        emit(state.copyWith(serialListOnTheAirState: RequestState.loading));
        final result = await _getOnTheAirSerials.execute();

        result.fold(
          (failure) {
            emit(state.copyWith(
              serialListOnTheAirState: RequestState.error,
              message: failure.message,
            ));
          },
          (data) {
            emit(state.copyWith(
              serialListOnTheAirState: RequestState.loaded,
              data: data,
            ));
          },
        );
      },
    );

    on<FetchPopularSerials>(
      (event, emit) async {
        emit(state.copyWith(serialListPopularState: RequestState.loading));
        final result = await _getPopularSerials.execute();

        result.fold(
          (failure) {
            emit(state.copyWith(
              serialListPopularState: RequestState.error,
              message: failure.message,
            ));
          },
          (data) {
            emit(state.copyWith(
              serialListPopularState: RequestState.loaded,
              data: data,
            ));
          },
        );
      },
    );

    on<FetchTopRatedSerials>(
      (event, emit) async {
        emit(state.copyWith(serialListTopRatedState: RequestState.loading));
        final result = await _getTopRatedSerials.execute();

        result.fold(
          (failure) {
            emit(state.copyWith(
              serialListTopRatedState: RequestState.error,
              message: failure.message,
            ));
          },
          (data) {
            emit(state.copyWith(
              serialListTopRatedState: RequestState.loaded,
              data: data,
            ));
          },
        );
      },
    );
  }
}
