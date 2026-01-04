import 'package:dartz/dartz.dart';

class GetDoctorsUsecase {
  final dynamic repository;
  GetDoctorsUsecase(this.repository);
  
  Future<Either<Exception, List<dynamic>>> call() async {
    return Right([]);
  }
}

class BookAppointmentUsecase {
  final dynamic repository;
  BookAppointmentUsecase(this.repository);
  
  Future<Either<Exception, Map<String, dynamic>>> call(String doctorId) async {
    return Left(Exception('Not implemented'));
  }
}
