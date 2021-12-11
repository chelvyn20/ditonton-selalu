import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/serial.dart';
import 'package:core/domain/entities/serial_detail.dart';
import 'package:core/domain/usecases/get_serial_detail.dart';
import 'package:core/domain/usecases/get_serial_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_serial_status.dart';
import 'package:core/domain/usecases/remove_serial_watchlist.dart';
import 'package:core/domain/usecases/save_serial_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'serial_detail_event.dart';
part 'serial_detail_state.dart';

class SerialDetailBloc extends Bloc<SerialDetailEvent, SerialDetailState> {
  final GetSerialDetail getSerialDetail;
  final GetSerialRecommendations getSerialRecommendations;
  final GetWatchListSerialStatus getWatchListStatus;
  final SaveSerialWatchlist saveWatchlist;
  final RemoveSerialWatchlist removeWatchlist;

  SerialDetailBloc({
    required this.getSerialDetail,
    required this.getSerialRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(SerialDetailState.initial()) {
    on<FetchSerialDetail>((event, emit) async {
      emit(SerialDetailState.initial().copyWith(serialDetailState: RequestState.loading));

      final detailResult = await getSerialDetail.execute(event.id);
      final recommendationResult =
          await getSerialRecommendations.execute(event.id);

      detailResult.fold(
        (failure) async {
          emit(state.copyWith(
              serialDetailState: RequestState.error, message: failure.message));
        },
        (serial) async {
          emit(state.copyWith(
            serialDetail: serial,
            serialDetailState: RequestState.loaded,
            serialRecommendationsState: RequestState.loading,
          ));
          recommendationResult.fold(
            (failure) {
              emit(state.copyWith(
                  serialRecommendationsState: RequestState.error,
                  message: failure.message));
            },
            (serials) {
              emit(state.copyWith(
                serialRecommendationsState: RequestState.loaded,
                serialRecommendations: serials,
              ));
            },
          );
        },
      );
    });

    on<AddToWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.serialDetail);

      result.fold((failure) {
        emit(state.copyWith(watchlistMessage: failure.message));
      }, (successMessage) {
        emit(state.copyWith(watchlistMessage: successMessage));
      });

      add(LoadWatchlistStatus(event.serialDetail.id));
    });

    on<RemoveFromWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.serialDetail);

      result.fold((failure) {
        emit(state.copyWith(watchlistMessage: failure.message));
      }, (successMessage) {
        emit(state.copyWith(watchlistMessage: successMessage));
      });

      add(LoadWatchlistStatus(event.serialDetail.id));
    });

    on<LoadWatchlistStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(
        isAddedToWatchlist: result,
      ));
    });
  }
}
