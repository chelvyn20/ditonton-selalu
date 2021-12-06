import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_movie_status.dart';
import 'package:core/domain/usecases/remove_movie_watchlist.dart';
import 'package:core/domain/usecases/save_movie_watchlist.dart';
import 'package:core/presentation/bloc/movie/movie_detail/movie_detail_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_movie_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListMovieStatus,
  SaveMovieWatchlist,
  RemoveMovieWatchlist,
])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListMovieStatus mockGetWatchlistStatus;
  late MockSaveMovieWatchlist mockSaveWatchlist;
  late MockRemoveMovieWatchlist mockRemoveWatchlist;
  late MovieDetailBloc movieDetailBloc;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListMovieStatus();
    mockSaveWatchlist = MockSaveMovieWatchlist();
    mockRemoveWatchlist = MockRemoveMovieWatchlist();
    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;

  final movieDetailStateInit = MovieDetailState.initial();

  test('initial state should be empty', () {
    expect(movieDetailBloc.state, movieDetailStateInit);
  });

  group('Get Movie Detail and Movie Recommendation', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Loaded, Loaded] when movie-detail data and movie-recommendations are gotten successfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => const Right(<Movie>[]));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        movieDetailStateInit.copyWith(
          movieDetailState: RequestState.loading,
        ),
        movieDetailStateInit.copyWith(
          movieDetail: testMovieDetail,
          movieDetailState: RequestState.loaded,
          movieRecommendations: <Movie>[],
          movieRecommendationsState: RequestState.loading,
          message: '',
        ),
        movieDetailStateInit.copyWith(
          movieDetailState: RequestState.loaded,
          movieRecommendationsState: RequestState.loaded,
          movieRecommendations: <Movie>[],
          message: '',
        )
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Loaded, Error] when movie-detail data is gotten successfully and movie-recommendations are gotten unsuccessfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Failed')));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        movieDetailStateInit.copyWith(
          movieDetailState: RequestState.loading,
        ),
        movieDetailStateInit.copyWith(
          movieDetail: testMovieDetail,
          movieDetailState: RequestState.loaded,
          movieRecommendations: <Movie>[],
          movieRecommendationsState: RequestState.loading,
          message: '',
        ),
        movieDetailStateInit.copyWith(
          movieDetailState: RequestState.loaded,
          movieRecommendationsState: RequestState.error,
          movieRecommendations: <Movie>[],
          message: 'Failed',
        )
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Error] when movie-detail data is gotten unsuccessfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Failed')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Failed')));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        movieDetailStateInit.copyWith(
          movieDetailState: RequestState.loading,
        ),
        movieDetailStateInit.copyWith(
            movieDetailState: RequestState.error, message: 'Failed'),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );
  });

  group('Watchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should get the watchlist status',
      build: () {
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Failed')));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        movieDetailStateInit.copyWith(
          isAddedToWatchlist: true,
        ),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should execute save watchlist when function called',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Saved'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const AddToWatchlist(testMovieDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        movieDetailStateInit.copyWith(watchlistMessage: 'Saved'),
        movieDetailStateInit.copyWith(
          isAddedToWatchlist: true,
          watchlistMessage: 'Saved',
        ),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should execute remove watchlist when function called',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Removed'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const RemoveFromWatchlist(testMovieDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        movieDetailStateInit.copyWith(watchlistMessage: 'Removed'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should update watchlist status when add watchlist success',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const AddToWatchlist(testMovieDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        movieDetailStateInit.copyWith(watchlistMessage: 'Added to Watchlist'),
        movieDetailStateInit.copyWith(
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should update watchlist message when add watchlist failed',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const AddToWatchlist(testMovieDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        movieDetailStateInit.copyWith(watchlistMessage: 'Failed'),
        movieDetailStateInit.copyWith(
          isAddedToWatchlist: true,
          watchlistMessage: 'Failed',
        ),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );
  });
}
