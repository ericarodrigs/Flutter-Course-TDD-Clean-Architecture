// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent([List props = const <dynamic>[]]);
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  GetTriviaForConcreteNumber({
    required this.numberString,
  }) : super([numberString]);

  @override
  List<Object?> get props => props;
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {
  @override
  List<Object?> get props => props;
}
