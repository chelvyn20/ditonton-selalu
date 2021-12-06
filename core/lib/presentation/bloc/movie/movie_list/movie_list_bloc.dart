import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies _getNowPlayingMovies;
  final GetPopularMovies _getPopularMovies;
  final GetTopRatedMovies _getTopRatedMovies;

  MovieListBloc(
    this._getNowPlayingMovies,
    this._getPopularMovies,
    this._getTopRatedMovies,
  ) : super(MovieListState.initial()) {
    on<FetchNowPlayingMovies>(
      (event, emit) async {
        emit(state.copyWith(movieListNowPlayingState: RequestState.loading));
        final result = await _getNowPlayingMovies.execute();

        result.fold(
          (failure) {
            emit(state.copyWith(
              movieListNowPlayingState: RequestState.error,
              message: failure.message,
            ));
          },
          (data) {
            emit(state.copyWith(
              movieListNowPlayingState: RequestState.loaded,
              data: data,
            ));
          },
        );
      },
    );

    on<FetchPopularMovies>(
      (event, emit) async {
        emit(state.copyWith(movieListPopularState: RequestState.loading));
        final result = await _getPopularMovies.execute();

        result.fold(
          (failure) {
            emit(state.copyWith(
              movieListPopularState: RequestState.error,
              message: failure.message,
            ));
          },
          (data) {
            emit(state.copyWith(
              movieListPopularState: RequestState.loaded,
              data: data,
            ));
          },
        );
      },
    );

    on<FetchTopRatedMovies>(
      (event, emit) async {
        emit(state.copyWith(movieListTopRatedState: RequestState.loading));
        final result = await _getTopRatedMovies.execute();

        result.fold(
          (failure) {
            emit(state.copyWith(
              movieListTopRatedState: RequestState.error,
              message: failure.message,
            ));
          },
          (data) {
            emit(state.copyWith(
              movieListTopRatedState: RequestState.loaded,
              data: data,
            ));
          },
        );
      },
    );
  }
}
