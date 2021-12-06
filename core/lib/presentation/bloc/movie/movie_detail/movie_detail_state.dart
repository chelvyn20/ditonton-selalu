part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final MovieDetail movieDetail;
  final RequestState movieDetailState;
  final List<Movie> movieRecommendations;
  final RequestState movieRecommendationsState;
  final bool isAddedToWatchlist;
  final String message;
  final String watchlistMessage;

  const MovieDetailState({
    required this.movieDetail,
    required this.movieDetailState,
    required this.movieRecommendations,
    required this.movieRecommendationsState,
    required this.isAddedToWatchlist,
    required this.message,
    required this.watchlistMessage,
  });

  MovieDetailState copyWith({
    MovieDetail? movieDetail,
    RequestState? movieDetailState,
    List<Movie>? movieRecommendations,
    RequestState? movieRecommendationsState,
    bool? isAddedToWatchlist,
    String? message,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      movieDetail: movieDetail ?? this.movieDetail,
      movieDetailState: movieDetailState ?? this.movieDetailState,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      movieRecommendationsState:
          movieRecommendationsState ?? this.movieRecommendationsState,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  //tambahkan juga factory contructor untuk membuat initial state nya
  factory MovieDetailState.initial() => const MovieDetailState(
        movieDetail: movieDetailInitial,
        movieDetailState: RequestState.empty,
        movieRecommendations: <Movie>[],
        movieRecommendationsState: RequestState.empty,
        isAddedToWatchlist: false,
        message: '',
        watchlistMessage: '',
      );

  @override
  List<Object?> get props => [
        movieDetail,
        movieDetailState,
        movieRecommendations,
        movieRecommendationsState,
        isAddedToWatchlist,
        message,
        watchlistMessage,
      ];
}

const MovieDetail movieDetailInitial = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1.0,
  voteCount: 1,
);
