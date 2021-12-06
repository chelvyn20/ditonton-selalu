part of 'movie_list_bloc.dart';

abstract class MovieListEvent extends Equatable {
  const MovieListEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingMovies extends MovieListEvent {
  const FetchNowPlayingMovies();

  @override
  List<Object> get props => [];
}

class FetchPopularMovies extends MovieListEvent {
  const FetchPopularMovies();

  @override
  List<Object> get props => [];
}

class FetchTopRatedMovies extends MovieListEvent {
  const FetchTopRatedMovies();

  @override
  List<Object> get props => [];
}
