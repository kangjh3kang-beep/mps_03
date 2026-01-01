import 'package:injectable/injectable.dart';

class FamilyMember {
  final String id;
  final String name;
  final String relation;

  FamilyMember({required this.id, required this.name, required this.relation});
}

@singleton
class MyDataService {
  // 가족 그룹 및 구성원 관리
  Future<List<FamilyMember>> getFamilyMembers() async {
    // TODO: Supabase API 연동
    return [
      FamilyMember(id: '1', name: '나', relation: '본인'),
      FamilyMember(id: '2', name: '김만파', relation: '부'),
      FamilyMember(id: '3', name: '이식', relation: '모'),
    ];
  }
  
  // 개인별 건강 데이터 요약
  Future<Map<String, dynamic>> getHealthSummary(String memberId) async {
    return {
      'last_measurement': '2026-01-01',
      'status': 'Good',
      'alerts': 0,
    };
  }
}
