import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl localDataSource;
  MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    localDataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(
      fixture('trivia_cached.json'),
    ));

    test('should return NumberTrivia from SharedPreferences where is one in the cache', () async {
      // arrange
      when(sharedPreferences.getString(any)).thenReturn(fixture('trivia_cached.json'));

      // act
      final result = await localDataSource.getLastNumberTrivia();

      // assert
      verify(sharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a CacheException when there is not a cached value', () async {
      // arrange
      when(sharedPreferences.getString(any)).thenReturn(null);

      // act
      final call = localDataSource.getLastNumberTrivia;

      // assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

    test('should call SharedPreferences to cache the data', () async {
      // arrange
      final String expectedJsonString = json.encode(tNumberTriviaModel.toJson());

      // act
      localDataSource.cacheNumberTrivia(tNumberTriviaModel);

      // assert
      verify(sharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
