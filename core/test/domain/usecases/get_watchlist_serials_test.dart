import 'package:core/domain/usecases/get_watchlist_serial.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_serial_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistSerial usecase;
  late MockSerialRepository mockSerialRepository;

  setUp(() {
    mockSerialRepository = MockSerialRepository();
    usecase = GetWatchlistSerial(mockSerialRepository);
  });

  test('should get list of serials from the repository', () async {
    // arrange
    when(mockSerialRepository.getWatchlistSerial())
        .thenAnswer((_) async => Right(testSerialList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testSerialList));
  });
}
