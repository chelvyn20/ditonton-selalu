import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/serial.dart';
import 'package:core/domain/usecases/get_serial_detail.dart';
import 'package:core/domain/usecases/get_serial_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_serial_status.dart';
import 'package:core/domain/usecases/remove_serial_watchlist.dart';
import 'package:core/domain/usecases/save_serial_watchlist.dart';
import 'package:core/presentation/bloc/serial/serial_detail/serial_detail_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_serial_objects.dart';
import 'serial_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetSerialDetail,
  GetSerialRecommendations,
  GetWatchListSerialStatus,
  SaveSerialWatchlist,
  RemoveSerialWatchlist,
])
void main() {
  late MockGetSerialDetail mockGetSerialDetail;
  late MockGetSerialRecommendations mockGetSerialRecommendations;
  late MockGetWatchListSerialStatus mockGetWatchlistStatus;
  late MockSaveSerialWatchlist mockSaveWatchlist;
  late MockRemoveSerialWatchlist mockRemoveWatchlist;
  late SerialDetailBloc serialDetailBloc;

  setUp(() {
    mockGetSerialDetail = MockGetSerialDetail();
    mockGetSerialRecommendations = MockGetSerialRecommendations();
    mockGetWatchlistStatus = MockGetWatchListSerialStatus();
    mockSaveWatchlist = MockSaveSerialWatchlist();
    mockRemoveWatchlist = MockRemoveSerialWatchlist();
    serialDetailBloc = SerialDetailBloc(
      getSerialDetail: mockGetSerialDetail,
      getSerialRecommendations: mockGetSerialRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;

  final serialDetailStateInit = SerialDetailState.initial();

  test('initial state should be empty', () {
    expect(serialDetailBloc.state, serialDetailStateInit);
  });

  group('Get Serial Detail and Serial Recommendation', () {
    blocTest<SerialDetailBloc, SerialDetailState>(
      'Should emit [Loading, Loaded, Loaded] when serial-detail data and serial-recommendations are gotten successfully',
      build: () {
        when(mockGetSerialDetail.execute(tId))
            .thenAnswer((_) async => const Right(testSerialDetail));
        when(mockGetSerialRecommendations.execute(tId))
            .thenAnswer((_) async => const Right(<Serial>[]));
        return serialDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchSerialDetail(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        serialDetailStateInit.copyWith(
          serialDetailState: RequestState.loading,
        ),
        serialDetailStateInit.copyWith(
          serialDetail: testSerialDetail,
          serialDetailState: RequestState.loaded,
          serialRecommendations: <Serial>[],
          serialRecommendationsState: RequestState.loading,
          message: '',
        ),
        serialDetailStateInit.copyWith(
          serialDetailState: RequestState.loaded,
          serialRecommendationsState: RequestState.loaded,
          serialRecommendations: <Serial>[],
          message: '',
        )
      ],
      verify: (bloc) {
        verify(mockGetSerialDetail.execute(tId));
        verify(mockGetSerialRecommendations.execute(tId));
      },
    );

    blocTest<SerialDetailBloc, SerialDetailState>(
      'Should emit [Loading, Loaded, Error] when serial-detail data is gotten successfully and serial-recommendations are gotten unsuccessfully',
      build: () {
        when(mockGetSerialDetail.execute(tId))
            .thenAnswer((_) async => const Right(testSerialDetail));
        when(mockGetSerialRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Failed')));
        return serialDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchSerialDetail(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        serialDetailStateInit.copyWith(
          serialDetailState: RequestState.loading,
        ),
        serialDetailStateInit.copyWith(
          serialDetail: testSerialDetail,
          serialDetailState: RequestState.loaded,
          serialRecommendations: <Serial>[],
          serialRecommendationsState: RequestState.loading,
          message: '',
        ),
        serialDetailStateInit.copyWith(
          serialDetailState: RequestState.loaded,
          serialRecommendationsState: RequestState.error,
          serialRecommendations: <Serial>[],
          message: 'Failed',
        )
      ],
      verify: (bloc) {
        verify(mockGetSerialDetail.execute(tId));
        verify(mockGetSerialRecommendations.execute(tId));
      },
    );

    blocTest<SerialDetailBloc, SerialDetailState>(
      'Should emit [Loading, Error] when serial-detail data is gotten unsuccessfully',
      build: () {
        when(mockGetSerialDetail.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Failed')));
        when(mockGetSerialRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Failed')));
        return serialDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchSerialDetail(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        serialDetailStateInit.copyWith(
          serialDetailState: RequestState.loading,
        ),
        serialDetailStateInit.copyWith(
            serialDetailState: RequestState.error, message: 'Failed'),
      ],
      verify: (bloc) {
        verify(mockGetSerialDetail.execute(tId));
      },
    );
  });

  group('Watchlist', () {
    blocTest<SerialDetailBloc, SerialDetailState>(
      'should get the watchlist status',
      build: () {
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        when(mockGetSerialRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Failed')));
        return serialDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        serialDetailStateInit.copyWith(
          isAddedToWatchlist: true,
        ),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<SerialDetailBloc, SerialDetailState>(
      'should execute save watchlist when function called',
      build: () {
        when(mockSaveWatchlist.execute(testSerialDetail))
            .thenAnswer((_) async => const Right('Saved'));
        when(mockGetWatchlistStatus.execute(testSerialDetail.id))
            .thenAnswer((_) async => true);
        return serialDetailBloc;
      },
      act: (bloc) => bloc.add(const AddToWatchlist(testSerialDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        serialDetailStateInit.copyWith(watchlistMessage: 'Saved'),
        serialDetailStateInit.copyWith(
          isAddedToWatchlist: true,
          watchlistMessage: 'Saved',
        ),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testSerialDetail));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<SerialDetailBloc, SerialDetailState>(
      'should execute remove watchlist when function called',
      build: () {
        when(mockRemoveWatchlist.execute(testSerialDetail))
            .thenAnswer((_) async => const Right('Removed'));
        when(mockGetWatchlistStatus.execute(testSerialDetail.id))
            .thenAnswer((_) async => false);
        return serialDetailBloc;
      },
      act: (bloc) => bloc.add(const RemoveFromWatchlist(testSerialDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        serialDetailStateInit.copyWith(watchlistMessage: 'Removed'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testSerialDetail));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<SerialDetailBloc, SerialDetailState>(
      'should update watchlist status when add watchlist success',
      build: () {
        when(mockSaveWatchlist.execute(testSerialDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(testSerialDetail.id))
            .thenAnswer((_) async => true);
        return serialDetailBloc;
      },
      act: (bloc) => bloc.add(const AddToWatchlist(testSerialDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        serialDetailStateInit.copyWith(watchlistMessage: 'Added to Watchlist'),
        serialDetailStateInit.copyWith(
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testSerialDetail));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<SerialDetailBloc, SerialDetailState>(
      'should update watchlist message when add watchlist failed',
      build: () {
        when(mockSaveWatchlist.execute(testSerialDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testSerialDetail.id))
            .thenAnswer((_) async => true);
        return serialDetailBloc;
      },
      act: (bloc) => bloc.add(const AddToWatchlist(testSerialDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        serialDetailStateInit.copyWith(watchlistMessage: 'Failed'),
        serialDetailStateInit.copyWith(
          isAddedToWatchlist: true,
          watchlistMessage: 'Failed',
        ),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testSerialDetail));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );
  });
}
