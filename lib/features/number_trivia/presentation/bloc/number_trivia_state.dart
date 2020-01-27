import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaState extends Equatable {
  NumberTriviaState([List params = const <dynamic>[]]) : super(params);
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  Loaded({
    @required this.trivia,
  }) : super([trivia]);

  final NumberTrivia trivia;
}

class Error extends NumberTriviaState {
  Error({
    @required this.message,
  }) : super([message]);

  final String message;
}
