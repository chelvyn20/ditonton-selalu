import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc/serial/serial_detail/serial_detail_bloc.dart';
import 'package:core/presentation/pages/serial/serial_detail_page.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_serial_objects.dart';

class MockSerialDetailBloc extends Mock implements SerialDetailBloc {}

class SerialDetailEventFake extends Fake implements SerialDetailEvent {}

class SerialDetailStateFake extends Fake implements SerialDetailState {}

void main() {
  late SerialDetailBloc serialDetailBloc;
  final serialDetailStateInit = SerialDetailState.initial();

  setUpAll(() {
    registerFallbackValue(SerialDetailEventFake());
    registerFallbackValue(SerialDetailStateFake());
  });

  setUp(() {
    serialDetailBloc = MockSerialDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<SerialDetailBloc>.value(
      value: serialDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when serial not added to watchlist',
      (WidgetTester tester) async {
    when(() => serialDetailBloc.stream)
        .thenAnswer((_) => Stream.value(serialDetailStateInit.copyWith(
              serialDetailState: RequestState.loaded,
              serialRecommendationsState: RequestState.loaded,
              isAddedToWatchlist: false,
            )));
    when(() => serialDetailBloc.state)
        .thenReturn(serialDetailStateInit.copyWith(
      serialDetailState: RequestState.loaded,
      serialRecommendationsState: RequestState.loaded,
      isAddedToWatchlist: false,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const SerialDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when serial is added to watchlist',
      (WidgetTester tester) async {
    when(() => serialDetailBloc.stream)
        .thenAnswer((_) => Stream.value(serialDetailStateInit.copyWith(
              serialDetailState: RequestState.loaded,
              serialRecommendationsState: RequestState.loaded,
              isAddedToWatchlist: true,
            )));
    when(() => serialDetailBloc.state)
        .thenReturn(serialDetailStateInit.copyWith(
      serialDetailState: RequestState.loaded,
      serialRecommendationsState: RequestState.loaded,
      isAddedToWatchlist: true,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(const SerialDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    whenListen(
        serialDetailBloc,
        Stream.value(serialDetailStateInit.copyWith(
          serialDetail: testSerialDetail,
          serialDetailState: RequestState.loaded,
          serialRecommendationsState: RequestState.loaded,
          isAddedToWatchlist: true,
          watchlistMessage: 'Added serial to Watchlist',
        )));
    when(() => serialDetailBloc.state).thenReturn(
        serialDetailStateInit.copyWith(
            serialDetail: testSerialDetail,
            serialDetailState: RequestState.loaded,
            serialRecommendationsState: RequestState.loaded));

    await tester.pumpWidget(_makeTestableWidget(const SerialDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    final watchlistButton = find.byType(ElevatedButton);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added serial to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    whenListen(
        serialDetailBloc,
        Stream.value(serialDetailStateInit.copyWith(
          serialDetail: testSerialDetail,
          serialDetailState: RequestState.loaded,
          serialRecommendationsState: RequestState.loaded,
          watchlistMessage: 'Failed',
        )));
    when(() => serialDetailBloc.state).thenReturn(
        serialDetailStateInit.copyWith(
            serialDetail: testSerialDetail,
            serialDetailState: RequestState.loaded,
            serialRecommendationsState: RequestState.loaded));

    await tester.pumpWidget(_makeTestableWidget(const SerialDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    final watchlistButton = find.byType(ElevatedButton);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
