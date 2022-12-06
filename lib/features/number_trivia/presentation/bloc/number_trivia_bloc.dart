// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:bloc/bloc.dart';
// import 'package:clean_architecture_course/core/error/failures.dart';
// import 'package:clean_architecture_course/core/util/input_converter.dart';
// import 'package:clean_architecture_course/features/number_trivia/domain/entities/number_trivia.dart';
// import 'package:clean_architecture_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
// import 'package:clean_architecture_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
// import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';

// part 'number_trivia_event.dart';
// part 'number_trivia_state.dart';

// const String SERVER_FAILURE_MESSAGE = 'Server Failure';
// const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
// const String INVALID_INPUT_FAILURE_MESSAGE =
//     'Invalid Input - The number must be a positive intefer or zero.';

// class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
//   final GetConcreteNumberTrivia getConcreteNumberTrivia;
//   final GetRandomNumberTrivia getRandomNumberTrivia;
//   final InputConverter inputConverter;

//   NumberTriviaBloc({
//     required this.getConcreteNumberTrivia,
//     required this.getRandomNumberTrivia,
//     required this.inputConverter,
//   }) : super(Empty()) {
//     on<NumberTriviaEvent>(_mapEventToState);
//   }

//   _mapEventToState(
//       NumberTriviaEvent event, Emitter<NumberTriviaState> emitter) async {
//     if (event is GetTriviaForConcreteNumber) {
//       final inputEither =
//           inputConverter.stringToUnsignedInteger(event.numberString);

//       inputEither.fold((failure) async* {
//         emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
//       }, (integer) async* {
//         print('teste');
//         print(integer);
//         emit(Loading());
//         final failureOrTrivia =
//             await getConcreteNumberTrivia(Params(number: integer));
//         emit(failureOrTrivia.fold(
//             (failure) => Error(message: _mapFailureToMessage(failure)),
//             (trivia) => Loaded(trivia: trivia)));
//       });
//     } else if (event is GetTriviaForRandomNumber) {
//       emit(Loading());
//       final failureOrTrivia = await getRandomNumberTrivia(NoParams());
//       emit(failureOrTrivia.fold(
//           (failure) => Error(message: _mapFailureToMessage(failure)),
//           (trivia) => Loaded(trivia: trivia)));
//     }
//   }

//   String _mapFailureToMessage(Failure failure) {
//     switch (failure.runtimeType) {
//       case ServerFailure:
//         return SERVER_FAILURE_MESSAGE;
//       case CacheFailure:
//         return CACHE_FAILURE_MESSAGE;
//       default:
//         return 'Unexpected error';
//     }
//   }
// }

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:clean_architecture_course/core/error/failures.dart';
import 'package:clean_architecture_course/core/util/input_converter.dart';
import 'package:clean_architecture_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:equatable/equatable.dart';
part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive intefer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>(_getConcrete);
    on<GetTriviaForRandomNumber>(_getRandom);
  }

  _getConcrete(event, emitter) async {
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);

    inputEither.fold((failure) async {
      emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
    }, (integer) async {
      print('teste');
      print(integer);
      emit(Loading());
      final failureOrTrivia =
          await getConcreteNumberTrivia(Params(number: integer));
      emit(failureOrTrivia.fold(
          (failure) => Error(message: _mapFailureToMessage(failure)),
          (trivia) => Loaded(trivia: trivia)));
    });
  }

  _getRandom(event, emitter) async {
    emit(Loading());
    print('111111111111');
    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    emit(failureOrTrivia.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (trivia) => Loaded(trivia: trivia)));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
