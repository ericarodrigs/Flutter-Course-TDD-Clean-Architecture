import 'package:clean_architecture_course/core/error/failures.dart';
import 'package:clean_architecture_course/core/util/input_converter.dart';
import 'package:clean_architecture_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_course/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialState should be Empty', () {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);

    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      when(mockInputConverter.stringToUnsignedInteger('any'))
          .thenReturn(const Right(tNumberParsed));
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger('any'));
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      when(mockInputConverter.stringToUnsignedInteger('any'))
          .thenReturn(Left(InvalidInputFailure()));
      final expected = [
        Empty(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test('should get data from the concrete use case', () async {
      when(mockInputConverter.stringToUnsignedInteger('any'))
          .thenReturn(const Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(const Params(number: 1)))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(const Params(number: 12)));
      verify(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      when(mockInputConverter.stringToUnsignedInteger('any'))
          .thenReturn(const Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(const Params(number: 1)))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      when(mockInputConverter.stringToUnsignedInteger('any'))
          .thenReturn(const Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(const Params(number: 1)))
          .thenAnswer((_) async => Left(ServerFailure()));
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);

    test('should get data from the random use case', () async {
      when(mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(NoParams()));
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      when(mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      when(mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
