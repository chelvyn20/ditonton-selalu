import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/serial.dart';
import 'package:core/domain/usecases/get_on_the_air_serials.dart';
import 'package:core/domain/usecases/get_popular_serials.dart';
import 'package:core/domain/usecases/get_top_rated_serials.dart';
import 'package:core/presentation/bloc/serial/serial_list/serial_list_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'serial_list_bloc_test.mocks.dart';

@GenerateMocks([
  GetOnTheAirSerials,
  GetPopularSerials,
  GetTopRatedSerials,
])
void main() {
  late SerialListBloc serialListBloc;
  late MockGetOnTheAirSerials mockGetOnTheAirSerials;
  late MockGetPopularSerials mockGetPopularSerials;
  late MockGetTopRatedSerials mockGetTopRatedSerials;

  setUp(() {
    mockGetOnTheAirSerials = MockGetOnTheAirSerials();
    mockGetPopularSerials = MockGetPopularSerials();
    mockGetTopRatedSerials = MockGetTopRatedSerials();
    serialListBloc = SerialListBloc(
      mockGetOnTheAirSerials,
      mockGetPopularSerials,
      mockGetTopRatedSerials,
    );
  });

  final tSerial = Serial(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    originalLanguage: 'originalLanguage',
    originCountry: ['originCountry'],
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1.0,
    voteCount: 1,
  );
  final tSerialList = <Serial>[tSerial];

  final serialListStateInit = SerialListState.initial();

  group('on the air serials', () {
    test('initialState should be Empty', () {
      expect(
        serialListBloc.state,
        serialListStateInit,
      );
    });

    blocTest<SerialListBloc, SerialListState>(
      'Should emit [Loading, HasData] when on-the-air-serials data is gotten successfully',
      build: () {
        when(mockGetOnTheAirSerials.execute())
            .thenAnswer((_) async => Right(tSerialList));
        return serialListBloc;
      },
      act: (bloc) => bloc.add(const FetchOnTheAirSerials()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        serialListStateInit.copyWith(
            serialListOnTheAirState: RequestState.loading),
        serialListStateInit.copyWith(
          serialListOnTheAirState: RequestState.loaded,
          slOnTheAirData: tSerialList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetOnTheAirSerials.execute());
      },
    );

    blocTest<SerialListBloc, SerialListState>(
      'Should emit [Loading, Error] when get on-the-air-serials data is unsuccessful',
      build: () {
        when(mockGetOnTheAirSerials.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return serialListBloc;
      },
      act: (bloc) => bloc.add(const FetchOnTheAirSerials()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        serialListStateInit.copyWith(
            serialListOnTheAirState: RequestState.loading),
        serialListStateInit.copyWith(
          serialListOnTheAirState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetOnTheAirSerials.execute());
      },
    );
  });

  group('popular serials', () {
    test('initialState should be Empty', () {
      expect(
        serialListBloc.state,
        serialListStateInit,
      );
    });

    blocTest<SerialListBloc, SerialListState>(
      'Should emit [Loading, HasData] when popular-serials data is gotten successfully',
      build: () {
        when(mockGetPopularSerials.execute())
            .thenAnswer((_) async => Right(tSerialList));
        return serialListBloc;
      },
      act: (bloc) => bloc.add(const FetchPopularSerials()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        serialListStateInit.copyWith(
            serialListPopularState: RequestState.loading),
        serialListStateInit.copyWith(
          serialListPopularState: RequestState.loaded,
          slPopularData: tSerialList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetPopularSerials.execute());
      },
    );

    blocTest<SerialListBloc, SerialListState>(
      'Should emit [Loading, Error] when get popular-serials data is unsuccessful',
      build: () {
        when(mockGetPopularSerials.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return serialListBloc;
      },
      act: (bloc) => bloc.add(const FetchPopularSerials()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        serialListStateInit.copyWith(
            serialListPopularState: RequestState.loading),
        serialListStateInit.copyWith(
          serialListPopularState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetPopularSerials.execute());
      },
    );
  });

  group('top rated serials', () {
    test('initialState should be Empty', () {
      expect(
        serialListBloc.state,
        serialListStateInit,
      );
    });

    blocTest<SerialListBloc, SerialListState>(
      'Should emit [Loading, HasData] when top-rated-serials data is gotten successfully',
      build: () {
        when(mockGetTopRatedSerials.execute())
            .thenAnswer((_) async => Right(tSerialList));
        return serialListBloc;
      },
      act: (bloc) => bloc.add(const FetchTopRatedSerials()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        serialListStateInit.copyWith(
            serialListTopRatedState: RequestState.loading),
        serialListStateInit.copyWith(
          serialListTopRatedState: RequestState.loaded,
          slTopRatedData: tSerialList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedSerials.execute());
      },
    );

    blocTest<SerialListBloc, SerialListState>(
      'Should emit [Loading, Error] when get top-rated-serials data is unsuccessful',
      build: () {
        when(mockGetTopRatedSerials.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return serialListBloc;
      },
      act: (bloc) => bloc.add(const FetchTopRatedSerials()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        serialListStateInit.copyWith(
            serialListTopRatedState: RequestState.loading),
        serialListStateInit.copyWith(
          serialListTopRatedState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedSerials.execute());
      },
    );
  });
}
