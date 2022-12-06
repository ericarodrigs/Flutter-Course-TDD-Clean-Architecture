import 'package:clean_architecture_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_course/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(repository: mockNumberTriviaRepository);
  });
  const tNumberTrivia = NumberTrivia(text: 'teste', number: 1);

  test(
    'should get trivia from  the repository',
    () async {
      mockNumberTriviaRepository = MockNumberTriviaRepository();
      usecase = GetRandomNumberTrivia(repository: mockNumberTriviaRepository);

      //arrange
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      final result = await usecase(NoParams());
      //assert
      expect(result, const Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
