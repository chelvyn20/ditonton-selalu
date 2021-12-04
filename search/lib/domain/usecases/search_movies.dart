import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetSearchMovies {
  final MovieRepository repository;

  GetSearchMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute(String query) {
    return repository.searchMovies(query);
  }
}
