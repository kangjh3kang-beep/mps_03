import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// 원격진료 메인 페이지
class TelemedicinePage extends StatefulWidget {
  const TelemedicinePage({Key? key}) : super(key: key);

  @override
  State<TelemedicinePage> createState() => _TelemedicinePageState();
}

class _TelemedicinePageState extends State<TelemedicinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('원격진료'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 긴급 진료 배너
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red[400]!, Colors.red[600]!],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '긴급 진료 필요',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '24시간 이용 가능한 긴급 의료 상담',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context.push('/telemedicine/doctors').then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('긴급 의사 연결 중...')),
                          );
                        });
                      },
                      child: const Text(
                        '의사와 연결하기',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 최근 진료 기록
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '최근 진료',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildConsultationCard(
                    doctorName: '이순신 의사',
                    specialty: '내과 전문의',
                    date: '2024-01-15',
                    time: '14:30',
                    diagnosis: '감기 의심',
                    status: '진료완료',
                  ),
                  const SizedBox(height: 8),
                  _buildConsultationCard(
                    doctorName: '김신영 의사',
                    specialty: '피부과 전문의',
                    date: '2024-01-08',
                    time: '10:00',
                    diagnosis: '피부 트러블',
                    status: '진료완료',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 처방전 관리
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.description, color: Colors.blue, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '처방전 관리',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '진료 후 발급된 처방전 확인',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: () => context.push('/telemedicine/prescriptions'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 의사 목록
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '추천 의사',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildDoctorCard(
                          name: '이순신',
                          specialty: '내과',
                          rating: 4.9,
                          reviews: 287,
                          available: true,
                        ),
                        _buildDoctorCard(
                          name: '김신영',
                          specialty: '피부과',
                          rating: 4.8,
                          reviews: 195,
                          available: true,
                        ),
                        _buildDoctorCard(
                          name: '박민준',
                          specialty: '정형외과',
                          rating: 4.7,
                          reviews: 142,
                          available: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 전체 의사 보기
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.people),
                  label: const Text('전체 의사 보기'),
                  onPressed: () => context.push('/telemedicine/doctors'),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationCard({
    required String doctorName,
    required String specialty,
    required String date,
    required String time,
    required String diagnosis,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue[100],
            child: const Icon(Icons.person, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctorName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  specialty,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  '$date $time',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(fontSize: 12, color: Colors.green[700]),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.push('/telemedicine/doctor/1'),
                child: const Text('상세보기', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard({
    required String name,
    required String specialty,
    required double rating,
    required int reviews,
    required bool available,
  }) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // 프로필
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Center(
              child: Icon(Icons.person, size: 40, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    specialty,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        '$rating ($reviews)',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: available ? Colors.blue : Colors.grey,
                        ),
                        onPressed: available
                            ? () => context.push('/telemedicine/doctor/1')
                            : null,
                        child: Text(
                          available ? '예약' : '예약불가',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 의사 목록 페이지
class DoctorListPage extends StatefulWidget {
  const DoctorListPage({Key? key}) : super(key: key);

  @override
  State<DoctorListPage> createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  String _selectedSpecialty = '전체';
  final List<String> _specialties = ['전체', '내과', '피부과', '정형외과', '이비인후과', '소아과'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('의사 선택'),
      ),
      body: Column(
        children: [
          // 전문과 필터
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: _specialties
                  .map((specialty) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(specialty),
                      selected: _selectedSpecialty == specialty,
                      onSelected: (selected) {
                        setState(() => _selectedSpecialty = specialty);
                      },
                    ),
                  ))
                  .toList(),
            ),
          ),
          // 의사 목록
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 8,
              itemBuilder: (context, index) => _buildDoctorListItem(
                index: index,
                context: context,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorListItem({required int index, required BuildContext context}) {
    final doctors = [
      ('이순신', '내과 전문의', 4.9, 287, true),
      ('김신영', '피부과 전문의', 4.8, 195, true),
      ('박민준', '정형외과 전문의', 4.7, 142, false),
      ('이영희', '이비인후과', 4.6, 98, true),
      ('최창준', '소아과 전문의', 4.9, 203, true),
      ('정미영', '신경과 전문의', 4.5, 76, true),
      ('임현욱', '외과 전문의', 4.8, 167, false),
      ('윤지영', '가정의학과', 4.7, 134, true),
    ];

    final (name, specialty, rating, reviews, available) = doctors[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 프로필 이미지
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.blue[100],
            child: const Icon(Icons.person, color: Colors.blue, size: 32),
          ),
          const SizedBox(width: 12),
          // 의사 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    if (!available)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '예약불가',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ),
                  ],
                ),
                Text(
                  specialty,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '$rating ($reviews리뷰)',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '24시간 가능',
                        style: TextStyle(fontSize: 10, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 예약 버튼
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: available ? Colors.blue : Colors.grey,
            ),
            onPressed: available
                ? () {
                    context.push('/telemedicine/doctor/1');
                  }
                : null,
            child: const Text('예약'),
          ),
        ],
      ),
    );
  }
}

/// 의사 상세 페이지
class DoctorDetailPage extends StatefulWidget {
  final String doctorId;

  const DoctorDetailPage({
    required this.doctorId,
    Key? key,
  }) : super(key: key);

  @override
  State<DoctorDetailPage> createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  DateTime? _selectedDate;
  String? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('의사 상세'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 의사 프로필
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.blue[100],
                    child: const Icon(Icons.person, size: 48, color: Colors.blue),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '이순신 의사',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '내과 전문의 · 서울 아산병원',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard('평점', '4.9'),
                      _buildStatCard('리뷰', '287개'),
                      _buildStatCard('경력', '15년'),
                    ],
                  ),
                ],
              ),
            ),

            // 소개
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '소개',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '서울 아산병원 내과 전문의로 15년간 환자 진료를 해오고 있습니다. '
                    '감기, 감염병, 만성질환 등 다양한 질환에 대해 경험이 풍부합니다.',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '진료과목',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildChip('감기'),
                  _buildChip('독감'),
                  _buildChip('소화불량'),
                  _buildChip('고혈압'),
                  _buildChip('당뇨'),
                ],
              ),
            ),

            const Divider(),

            // 예약 시간 선택
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '진료 예약',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (date != null) {
                        setState(() => _selectedDate = date);
                      }
                    },
                    child: Text(_selectedDate == null
                        ? '날짜 선택'
                        : DateFormat('yyyy-MM-dd').format(_selectedDate!)),
                  ),
                  const SizedBox(height: 12),
                  if (_selectedDate != null) ...[
                    const Text('가능한 시간:'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['09:00', '10:00', '14:00', '15:00', '16:00']
                          .map((time) => ChoiceChip(
                            label: Text(time),
                            selected: _selectedTime == time,
                            onSelected: (selected) {
                              setState(() => _selectedTime = selected ? time : null);
                            },
                          ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _selectedTime != null
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '예약 완료: ${DateFormat('MM-dd').format(_selectedDate!)} $_selectedTime',
                                    ),
                                  ),
                                );
                                context.pop();
                              }
                            : null,
                        child: const Text('예약 확정'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

/// 비디오 통화 페이지
class VideoCallPage extends StatefulWidget {
  final String sessionId;

  const VideoCallPage({
    required this.sessionId,
    Key? key,
  }) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  bool _isMicOn = true;
  bool _isCameraOn = true;
  bool _isSpeakerOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 배경 - 의사 비디오 (placeholder)
          Container(
            color: Colors.black87,
            child: const Center(
              child: Icon(Icons.videocam_off, size: 64, color: Colors.white54),
            ),
          ),

          // 상단 정보
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '이순신 의사',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '통화 중',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.info, color: Colors.white),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('진료 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              const Text('진료비: ₩50,000', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              const Text('남은 시간: 15분'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 내 카메라 영상 (우하단)
          Positioned(
            bottom: 120,
            right: 16,
            child: Container(
              width: 120,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white),
              ),
              child: Center(
                child: Icon(
                  _isCameraOn ? Icons.person : Icons.videocam_off,
                  size: 48,
                  color: Colors.white54,
                ),
              ),
            ),
          ),

          // 컨트롤 버튼들
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      icon: _isMicOn ? Icons.mic : Icons.mic_off,
                      color: _isMicOn ? Colors.white : Colors.red,
                      onPressed: () => setState(() => _isMicOn = !_isMicOn),
                    ),
                    _buildControlButton(
                      icon: _isCameraOn ? Icons.videocam : Icons.videocam_off,
                      color: _isCameraOn ? Colors.white : Colors.red,
                      onPressed: () => setState(() => _isCameraOn = !_isCameraOn),
                    ),
                    _buildControlButton(
                      icon: Icons.screen_share,
                      color: Colors.white,
                      onPressed: () {},
                    ),
                    _buildControlButton(
                      icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white,
                      onPressed: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
                    ),
                    _buildControlButton(
                      icon: Icons.call_end,
                      color: Colors.red,
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton(
      backgroundColor: Colors.grey[800],
      onPressed: onPressed,
      child: Icon(icon, color: color, size: 24),
    );
  }
}

/// 처방전 관리 페이지
class PrescriptionManagementPage extends StatefulWidget {
  const PrescriptionManagementPage({Key? key}) : super(key: key);

  @override
  State<PrescriptionManagementPage> createState() => _PrescriptionManagementPageState();
}

class _PrescriptionManagementPageState extends State<PrescriptionManagementPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('처방전 관리'),
      ),
      body: Column(
        children: [
          // 탭
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TabButton(
                    label: '진행 중',
                    isSelected: _selectedTab == 0,
                    onTap: () => setState(() => _selectedTab = 0),
                  ),
                ),
                Expanded(
                  child: TabButton(
                    label: '완료됨',
                    isSelected: _selectedTab == 1,
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
                ),
              ],
            ),
          ),
          // 목록
          Expanded(
            child: _selectedTab == 0
                ? ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildPrescriptionCard(
                        date: '2024-01-15',
                        doctor: '이순신 의사',
                        status: '약국 확인 대기 중',
                        medicines: ['감기약', '기침약'],
                      ),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildPrescriptionCard(
                        date: '2024-01-08',
                        doctor: '김신영 의사',
                        status: '약국 수령 완료',
                        medicines: ['피부연고', '항생제'],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCard({
    required String date,
    required String doctor,
    required String status,
    required List<String> medicines,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(doctor, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: medicines
                .map((medicine) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(medicine, style: const TextStyle(fontSize: 12)),
                ))
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.pharmacy),
                label: const Text('약국에서 수령'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('가까운 약국: 한약처방 약국 (500m)')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 3,
              color: isSelected ? Colors.blue : Colors.transparent,
            ),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
