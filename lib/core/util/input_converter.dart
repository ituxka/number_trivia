import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final parsedNumber = int.parse(str);

      if (parsedNumber < 0) throw FormatException();

      return Right(parsedNumber);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
