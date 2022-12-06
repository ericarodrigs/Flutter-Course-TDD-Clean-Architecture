// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean_architecture_course/core/error/failures.dart';
import 'package:clean_architecture_course/core/usecases/usecases.dart';
import 'package:clean_architecture_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_course/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetConcreteNumberTrivia implements Usecases<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia({
    required this.repository,
  });

  @override
  Future<Either<Failure, NumberTrivia>> call(
    Params params,
  ) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({
    required this.number,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}