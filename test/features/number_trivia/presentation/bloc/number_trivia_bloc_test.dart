import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/bloc.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia getConcreteNumberTrivia;
  MockGetRandomNumberTrivia getRandomNumberTrivia;
  MockInputConverter inputConverter;

  setUp(() {
    getConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    getRandomNumberTrivia = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: getConcreteNumberTrivia,
      random: getRandomNumberTrivia,
      inputConverter: inputConverter,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    // The event takes in a String
    final tNumberString = '1';
    // This is the successful output of the InputConverter
    final tNumberParsed = int.parse(tNumberString);
    // NumberTrivia instance is needed too, of course
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() {
      when(inputConverter.stringToUnsignedInteger(any)).thenReturn(Right(tNumberParsed));
    }

    test('should call the InputConverter to validate and convert the string to an integer', () async {
      // arrange
      setUpMockInputConverterSuccess();

      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(inputConverter.stringToUnsignedInteger(any));

      // assert
      verify(inputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      // arrange
      when(inputConverter.stringToUnsignedInteger(any)).thenReturn(Left(InvalidInputFailure()));

      // assert later
      final expected = [
        // The initial state is always emitted first
        Empty(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the concrete use case', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));

      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(getConcreteNumberTrivia(any));

      // assert
      verify(getConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));

      // assert later
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure()));

      // assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] with a proper message for the error when getting data fails', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any)).thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });
  });
}
