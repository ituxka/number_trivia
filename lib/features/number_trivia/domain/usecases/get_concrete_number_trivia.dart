import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia {
  GetConcreteNumberTrivia(this.repository);

  final NumberTriviaRepository repository;

  Future<Either<Failure, NumberTrivia>> call({
    @required int number,
  }) {
    return repository.getConcreteNumberTrivia(number);
  }
}
