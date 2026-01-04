import 'package:dartz/dartz.dart';

abstract class TelemedicineRepository {
  Future<Either<Exception, List<dynamic>>> getDoctors();
  Future<Either<Exception, Map<String, dynamic>>> bookAppointment(String doctorId);
}

class TelemedicineRepositoryImpl implements TelemedicineRepository {
  @override
  Future<Either<Exception, List<dynamic>>> getDoctors() async {
    return Right([]);
  }

  @override
  Future<Either<Exception, Map<String, dynamic>>> bookAppointment(String doctorId) async {
    return Left(Exception('Not implemented'));
  }
}
