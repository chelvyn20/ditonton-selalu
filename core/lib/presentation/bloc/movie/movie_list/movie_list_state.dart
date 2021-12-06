part of 'movie_list_bloc.dart';

class MovieListState extends Equatable {
  final RequestState movieListNowPlayingState;
  final RequestState movieListPopularState;
  final RequestState movieListTopRatedState;
  final List<Movie> mlNowPlayingData;
  final List<Movie> mlPopularData;
  final List<Movie> mlTopRatedData;
  final String message;

  const MovieListState({
    required this.movieListNowPlayingState,
    required this.movieListPopularState,
    required this.movieListTopRatedState,
    required this.mlNowPlayingData,
    required this.mlPopularData,
    required this.mlTopRatedData,
    required this.message,
  });

  @override
  List<Object> get props {
    return [
      movieListNowPlayingState,
      movieListPopularState,
      movieListTopRatedState,
      mlNowPlayingData,
      mlPopularData,
      mlTopRatedData,
      message,
    ];
  }

  MovieListState copyWith({
    RequestState? movieListNowPlayingState,
    RequestState? movieListPopularState,
    RequestState? movieListTopRatedState,
    List<Movie>? mlNowPlayingData,
    List<Movie>? mlPopularData,
    List<Movie>? mlTopRatedData,
    String? message,
  }) {
    return MovieListState(
      movieListNowPlayingState:
          movieListNowPlayingState ?? this.movieListNowPlayingState,
      movieListPopularState:
          movieListPopularState ?? this.movieListPopularState,
      movieListTopRatedState:
          movieListTopRatedState ?? this.movieListTopRatedState,
      mlNowPlayingData: mlNowPlayingData ?? this.mlNowPlayingData,
      mlPopularData: mlPopularData ?? this.mlPopularData,
      mlTopRatedData: mlTopRatedData ?? this.mlTopRatedData,
      message: message ?? this.message,
    );
  }

  factory MovieListState.initial() => const MovieListState(
        movieListNowPlayingState: RequestState.empty,
        movieListPopularState: RequestState.empty,
        movieListTopRatedState: RequestState.empty,
        mlNowPlayingData: <Movie>[],
        mlPopularData: <Movie>[],
        mlTopRatedData: <Movie>[],
        message: '',
      );
}
