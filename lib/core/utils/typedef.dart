import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid = ResultFuture<void>;
