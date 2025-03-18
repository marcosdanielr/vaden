import 'package:backend/src/domain/entities/backer.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class BackerRepository {
  AsyncResult<Backer> check(String email);
}
