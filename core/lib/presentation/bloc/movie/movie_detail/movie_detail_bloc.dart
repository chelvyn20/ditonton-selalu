import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_movie_status.dart';
import 'package:core/domain/usecases/remove_movie_watchlist.dart';
import 'package:core/domain/usecases/save_movie_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListMovieStatus getWatchListStatus;
  final SaveMovieWatchlist saveWatchlist;
  final RemoveMovieWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailState.initial()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(MovieDetailState.initial().copyWith(movieDetailState: RequestState.loading));

      final detailResult = await getMovieDetail.execute(event.id);
      final recommendationResult =
          await getMovieRecommendations.execute(event.id);

      detailResult.fold(
        (failure) async {
          emit(state.copyWith(
              movieDetailState: RequestState.error, message: failure.message));
        },
        (movie) async {
          emit(state.copyWith(
            movieDetail: movie,
            movieDetailState: RequestState.loaded,
            movieRecommendationsState: RequestState.loading,
          ));
          recommendationResult.fold(
            (failure) {
              emit(state.copyWith(
                movieRecommendationsState: RequestState.error,
                message: failure.message,
              ));
            },
            (movies) {
              emit(state.copyWith(
                movieRecommendationsState: RequestState.loaded,
                movieRecommendations: movies,
              ));
            },
          );
        },
      );
    });

    on<AddToWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.movieDetail);

      result.fold((failure) {
        emit(state.copyWith(watchlistMessage: failure.message));
      }, (successMessage) {
        emit(state.copyWith(watchlistMessage: successMessage));
      });

      add(LoadWatchlistStatus(event.movieDetail.id));
    });

    on<RemoveFromWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.movieDetail);

      result.fold((failure) {
        emit(state.copyWith(watchlistMessage: failure.message));
      }, (successMessage) {
        emit(state.copyWith(watchlistMessage: successMessage));
      });

      add(LoadWatchlistStatus(event.movieDetail.id));
    });

    on<LoadWatchlistStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(
        isAddedToWatchlist: result,
      ));
    });
  }
}
