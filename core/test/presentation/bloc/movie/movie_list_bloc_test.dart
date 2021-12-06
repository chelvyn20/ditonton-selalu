import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:core/presentation/bloc/movie/movie_list/movie_list_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
])
void main() {
  late MovieListBloc movieListBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    movieListBloc = MovieListBloc(
      mockGetNowPlayingMovies,
      mockGetPopularMovies,
      mockGetTopRatedMovies,
    );
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  final movieListStateInit = MovieListState.initial();

  group('now playing movies', () {
    test('initialState should be Empty', () {
      expect(
        movieListBloc.state,
        movieListStateInit,
      );
    });

    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, HasData] when now-playing-movies data is gotten successfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(const FetchNowPlayingMovies()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        movieListStateInit.copyWith(
            movieListNowPlayingState: RequestState.loading),
        movieListStateInit.copyWith(
          movieListNowPlayingState: RequestState.loaded,
          mlNowPlayingData: tMovieList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, Error] when get now-playing-movies data is unsuccessful',
      build: () {
        when(mockGetNowPlayingMovies.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(const FetchNowPlayingMovies()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        movieListStateInit.copyWith(
            movieListNowPlayingState: RequestState.loading),
        movieListStateInit.copyWith(
          movieListNowPlayingState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );
  });

  group('popular movies', () {
    test('initialState should be Empty', () {
      expect(
        movieListBloc.state,
        movieListStateInit,
      );
    });

    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, HasData] when popular-movies data is gotten successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(const FetchPopularMovies()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        movieListStateInit.copyWith(
            movieListPopularState: RequestState.loading),
        movieListStateInit.copyWith(
          movieListPopularState: RequestState.loaded,
          mlPopularData: tMovieList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, Error] when get popular-movies data is unsuccessful',
      build: () {
        when(mockGetPopularMovies.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(const FetchPopularMovies()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        movieListStateInit.copyWith(
            movieListPopularState: RequestState.loading),
        movieListStateInit.copyWith(
          movieListPopularState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      },
    );
  });

  group('top rated movies', () {
    test('initialState should be Empty', () {
      expect(
        movieListBloc.state,
        movieListStateInit,
      );
    });

    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, HasData] when top-rated-movies data is gotten successfully',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(const FetchTopRatedMovies()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        movieListStateInit.copyWith(
            movieListTopRatedState: RequestState.loading),
        movieListStateInit.copyWith(
          movieListTopRatedState: RequestState.loaded,
          mlTopRatedData: tMovieList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, Error] when get top-rated-movies data is unsuccessful',
      build: () {
        when(mockGetTopRatedMovies.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(const FetchTopRatedMovies()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        movieListStateInit.copyWith(
            movieListTopRatedState: RequestState.loading),
        movieListStateInit.copyWith(
          movieListTopRatedState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );
  });
}
