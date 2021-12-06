part of 'movie_list_bloc.dart';

class MovieListState extends Equatable {
  final RequestState movieListNowPlayingState;
  final RequestState movieListPopularState;
  final RequestState movieListTopRatedState;
  final String message;
  final List<Movie> data;

  const MovieListState({
    required this.movieListNowPlayingState,
    required this.movieListPopularState,
    required this.movieListTopRatedState,
    required this.message,
    required this.data,
  });

  MovieListState copyWith({
    RequestState? movieListNowPlayingState,
    RequestState? movieListPopularState,
    RequestState? movieListTopRatedState,
    String? message,
    List<Movie>? data,
  }) {
    return MovieListState(
      movieListNowPlayingState:
          movieListNowPlayingState ?? this.movieListNowPlayingState,
      movieListPopularState:
          movieListPopularState ?? this.movieListPopularState,
      movieListTopRatedState:
          movieListTopRatedState ?? this.movieListTopRatedState,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory MovieListState.initial() => const MovieListState(
        movieListNowPlayingState: RequestState.empty,
        movieListPopularState: RequestState.empty,
        movieListTopRatedState: RequestState.empty,
        message: '',
        data: <Movie>[],
      );

  @override
  List<Object> get props => [
        movieListNowPlayingState,
        movieListPopularState,
        movieListTopRatedState,
        message,
        data,
      ];
}
