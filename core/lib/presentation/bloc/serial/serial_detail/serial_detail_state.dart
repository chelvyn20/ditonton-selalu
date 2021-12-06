part of 'serial_detail_bloc.dart';

class SerialDetailState extends Equatable {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final SerialDetail serialDetail;
  final RequestState serialDetailState;
  final List<Serial> serialRecommendations;
  final RequestState serialRecommendationsState;
  final bool isAddedToWatchlist;
  final String message;
  final String watchlistMessage;

  const SerialDetailState({
    required this.serialDetail,
    required this.serialDetailState,
    required this.serialRecommendations,
    required this.serialRecommendationsState,
    required this.isAddedToWatchlist,
    required this.message,
    required this.watchlistMessage,
  });

  SerialDetailState copyWith({
    SerialDetail? serialDetail,
    RequestState? serialDetailState,
    List<Serial>? serialRecommendations,
    RequestState? serialRecommendationsState,
    bool? isAddedToWatchlist,
    String? message,
    String? watchlistMessage,
  }) {
    return SerialDetailState(
      serialDetail: serialDetail ?? this.serialDetail,
      serialDetailState: serialDetailState ?? this.serialDetailState,
      serialRecommendations:
          serialRecommendations ?? this.serialRecommendations,
      serialRecommendationsState:
          serialRecommendationsState ?? this.serialRecommendationsState,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  //tambahkan juga factory contructor untuk membuat initial state nya
  factory SerialDetailState.initial() => const SerialDetailState(
        serialDetail: serialDetailInitial,
        serialDetailState: RequestState.empty,
        serialRecommendations: <Serial>[],
        serialRecommendationsState: RequestState.empty,
        isAddedToWatchlist: false,
        message: '',
        watchlistMessage: '',
      );

  @override
  List<Object?> get props => [
        serialDetail,
        serialDetailState,
        serialRecommendations,
        serialRecommendationsState,
        isAddedToWatchlist,
        message,
        watchlistMessage,
      ];
}

const SerialDetail serialDetailInitial = SerialDetail(
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalName: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  firstAirDate: 'firstAirDate',
  numberOfSeasons: 1,
  name: 'name',
  voteAverage: 1.0,
  voteCount: 1,
);
