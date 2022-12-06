import 'package:clean_architecture_course/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class Usecases<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
