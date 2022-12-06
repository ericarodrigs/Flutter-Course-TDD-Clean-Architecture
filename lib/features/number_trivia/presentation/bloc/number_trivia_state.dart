// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState {}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  Loaded({
    required this.trivia,
  });
}

class Error extends NumberTriviaState {
  final String message;

  Error({
    required this.message,
  });
}
