import 'package:equatable/equatable.dart';

abstract class NumberTriviaEvent extends Equatable {
  NumberTriviaEvent([List params = const <dynamic>[]]) : super(params);
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  GetTriviaForConcreteNumber(this.numberString) : super([numberString]);

  final String numberString;
}
