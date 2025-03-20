import 'package:backend/src/domain/entities/backer.dart';
import 'package:backend/src/domain/repositories/backer_repository.dart';
import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';
import 'package:vaden/vaden.dart';

@Repository()
class BackerRepositoryImpl implements BackerRepository {
  final Dio dio;
  final DSON dson;

  BackerRepositoryImpl(this.dio, this.dson);

  @override
  AsyncResult<Backer> check(String email) async {
    final response = await dio.get<Map<String, dynamic>>('/backers/charges/$email');
    final backer = dson.fromJson<Backer>(response.data!);
    return Success(backer);
  }
}
