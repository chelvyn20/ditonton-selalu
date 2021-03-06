import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc/movie/movie_detail/movie_detail_bloc.dart';
import 'package:core/presentation/pages/movie/movie_detail_page.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_movie_objects.dart';

class MockMovieDetailBloc extends Mock implements MovieDetailBloc {}

class MovieDetailEventFake extends Fake implements MovieDetailEvent {}

class MovieDetailStateFake extends Fake implements MovieDetailState {}

void main() {
  late MovieDetailBloc movieDetailBloc;
  final movieDetailStateInit = MovieDetailState.initial();

  setUpAll(() {
    registerFallbackValue(MovieDetailEventFake());
    registerFallbackValue(MovieDetailStateFake());
  });

  setUp(() {
    movieDetailBloc = MockMovieDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: movieDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.stream)
        .thenAnswer((_) => Stream.value(movieDetailStateInit.copyWith(
              movieDetailState: RequestState.loaded,
              movieRecommendationsState: RequestState.loaded,
              isAddedToWatchlist: false,
            )));
    when(() => movieDetailBloc.state).thenReturn(movieDetailStateInit.copyWith(
      movieDetailState: RequestState.loaded,
      movieRecommendationsState: RequestState.loaded,
      isAddedToWatchlist: false,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.stream)
        .thenAnswer((_) => Stream.value(movieDetailStateInit.copyWith(
              movieDetailState: RequestState.loaded,
              movieRecommendationsState: RequestState.loaded,
              isAddedToWatchlist: true,
            )));
    when(() => movieDetailBloc.state).thenReturn(movieDetailStateInit.copyWith(
      movieDetailState: RequestState.loaded,
      movieRecommendationsState: RequestState.loaded,
      isAddedToWatchlist: true,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    whenListen(
        movieDetailBloc,
        Stream.value(movieDetailStateInit.copyWith(
          movieDetail: testMovieDetail,
          movieDetailState: RequestState.loaded,
          movieRecommendationsState: RequestState.loaded,
          isAddedToWatchlist: true,
          watchlistMessage: 'Added movie to Watchlist',
        )));
    when(() => movieDetailBloc.state).thenReturn(movieDetailStateInit.copyWith(
        movieDetail: testMovieDetail,
        movieDetailState: RequestState.loaded,
        movieRecommendationsState: RequestState.loaded));

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    final watchlistButton = find.byType(ElevatedButton);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added movie to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    whenListen(
        movieDetailBloc,
        Stream.value(movieDetailStateInit.copyWith(
          movieDetail: testMovieDetail,
          movieDetailState: RequestState.loaded,
          movieRecommendationsState: RequestState.loaded,
          watchlistMessage: 'Failed',
        )));
    when(() => movieDetailBloc.state).thenReturn(movieDetailStateInit.copyWith(
        movieDetail: testMovieDetail,
        movieDetailState: RequestState.loaded,
        movieRecommendationsState: RequestState.loaded));

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    final watchlistButton = find.byType(ElevatedButton);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
