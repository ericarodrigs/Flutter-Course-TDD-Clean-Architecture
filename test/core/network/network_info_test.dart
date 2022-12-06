import 'package:clean_architecture_course/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/mockito.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {
  void main() {
    NetworkInfoImpl networkInfoImpl;
    MockInternetConnectionChecker mockInternetConnectionChecker;

    setUp(() {
      mockInternetConnectionChecker = MockInternetConnectionChecker();
      networkInfoImpl =
          NetworkInfoImpl(connectionChecker: mockInternetConnectionChecker);
    });

    group('isConnected', () {
      mockInternetConnectionChecker = MockInternetConnectionChecker();
      networkInfoImpl =
          NetworkInfoImpl(connectionChecker: mockInternetConnectionChecker);
      test(
        'should foward the call to DataConnectionChecker.hasConnection',
        () async {
          final tHasConnectionFuture = Future.value(true);
          when(mockInternetConnectionChecker.hasConnection)
              .thenAnswer((_) async => tHasConnectionFuture);
          final result = networkInfoImpl.isConnected;
          verify(mockInternetConnectionChecker.hasConnection);
          expect(result, tHasConnectionFuture);
        },
      );
    });
  }
}
