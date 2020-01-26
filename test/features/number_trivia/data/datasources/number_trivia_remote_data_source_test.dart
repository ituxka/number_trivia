import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl remoteDataSource;
  MockHttpClient httpClient;

  setUp(() {
    httpClient = MockHttpClient();
    remoteDataSource = NumberTriviaRemoteDataSourceImpl(client: httpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(httpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientError404() {
    when(httpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia.json')),
    );

    test('should perform a GET request on a URL with number and with application/json header', () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      remoteDataSource.getConcreteNumberTrivia(tNumber);

      // assert
      verify(httpClient.get(
        'http://numbersapi.com/$tNumber',
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return NumberTrivia when the response code is 200 (success)', () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      final result = await remoteDataSource.getConcreteNumberTrivia(tNumber);

      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      // arrange
      setUpMockHttpClientError404();

      // act
      final call = remoteDataSource.getConcreteNumberTrivia;

      // assert
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia.json')),
    );

    test('should perform a GET request on a URL with number and with application/json header', () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      remoteDataSource.getRandomNumberTrivia();

      // assert
      verify(httpClient.get(
        'http://numbersapi.com/random',
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return NumberTrivia when the response code is 200 (success)', () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      final result = await remoteDataSource.getRandomNumberTrivia();

      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      // arrange
      setUpMockHttpClientError404();

      // act
      final call = remoteDataSource.getRandomNumberTrivia;

      // assert
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
