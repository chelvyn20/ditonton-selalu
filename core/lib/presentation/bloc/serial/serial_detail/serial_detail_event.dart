part of 'serial_detail_bloc.dart';

abstract class SerialDetailEvent extends Equatable {
  const SerialDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchSerialDetail extends SerialDetailEvent {
  final int id;
  const FetchSerialDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddToWatchlist extends SerialDetailEvent {
  final SerialDetail serialDetail;
  const AddToWatchlist(this.serialDetail);

  @override
  List<Object> get props => [serialDetail];
}

class RemoveFromWatchlist extends SerialDetailEvent {
  final SerialDetail serialDetail;
  const RemoveFromWatchlist(this.serialDetail);

  @override
  List<Object> get props => [serialDetail];
}

class LoadWatchlistStatus extends SerialDetailEvent {
  final int id;
  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}
