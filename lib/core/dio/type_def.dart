
import 'package:fpdart/fpdart.dart';
import 'package:kiosk/models/failure.dart';

typedef EitherModel<T> = Future<Either<Failure, T>>; 