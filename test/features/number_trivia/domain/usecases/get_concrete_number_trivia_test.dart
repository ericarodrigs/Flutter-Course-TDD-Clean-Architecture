import 'package:clean_architecture_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_course/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);
  });
  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(text: 'teste', number: 1);

  test(
    'should get trivia for the number from  the repository',
    () async {
      mockNumberTriviaRepository = MockNumberTriviaRepository();
      usecase = GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);

      //arrange
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(1))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      final result = await usecase(const Params(number: tNumber));
      //assert
      expect(result, const Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
