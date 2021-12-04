part of 'search_movies_bloc.dart';

abstract class SearchMoviesEvent extends Equatable {
  const SearchMoviesEvent();

  @override
  List<Object> get props => [];
}

class OnMovieQueryChanged extends SearchMoviesEvent {
  final String query;

  const OnMovieQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
