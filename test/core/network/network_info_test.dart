import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfo;
  MockDataConnectionChecker connectionChecker;

  setUp(() {
    connectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(connectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection', () async {
      // arrange
      final tHasConnectionFuture = Future.value(true);

      when(connectionChecker.hasConnection).thenAnswer((_) => tHasConnectionFuture);

      // act
      final result = networkInfo.isConnected;

      // assert
      verify(connectionChecker.hasConnection);
      expect(result, tHasConnectionFuture);
    });
  });
}
