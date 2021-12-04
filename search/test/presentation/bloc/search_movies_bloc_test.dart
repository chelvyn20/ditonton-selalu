import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/presentation/bloc/search_movies_bloc.dart';

import 'search_movies_bloc_test.mocks.dart';

@GenerateMocks([GetSearchMovies])
void main() {
  late SearchMoviesBloc searchMoviesBloc;
  late MockGetSearchMovies mockGetSearchMovies;

  setUp(() {
    mockGetSearchMovies = MockGetSearchMovies();
    searchMoviesBloc = SearchMoviesBloc(mockGetSearchMovies);
  });

  test('initial state should be empty', () {
    expect(searchMoviesBloc.state, SearchMoviesEmpty());
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];
  const tQuery = 'spiderman';

  blocTest<SearchMoviesBloc, SearchMoviesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      return searchMoviesBloc;
    },
    act: (bloc) => bloc.add(const OnMovieQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchMoviesLoading(),
      SearchMoviesHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetSearchMovies.execute(tQuery));
    },
  );

  blocTest<SearchMoviesBloc, SearchMoviesState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetSearchMovies.execute(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return searchMoviesBloc;
    },
    act: (bloc) => bloc.add(const OnMovieQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchMoviesLoading(),
      const SearchMoviesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetSearchMovies.execute(tQuery));
    },
  );
}
