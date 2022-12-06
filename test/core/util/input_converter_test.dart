import 'package:clean_architecture_course/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    inputConverter = InputConverter();

    test(
        'should return an integer when the string represents an unsigned integer.',
        () async {
      const str = '123';
      final result = inputConverter.stringToUnsignedInteger(str);
      expect(result, const Right(123));
    });

    test('should return a Failure when the string is not an integer.',
        () async {
      const str = 'abc';
      final result = inputConverter.stringToUnsignedInteger(str);
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a Failure when the string is a negative integer.',
        () async {
      const str = '-123';
      final result = inputConverter.stringToUnsignedInteger(str);
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
