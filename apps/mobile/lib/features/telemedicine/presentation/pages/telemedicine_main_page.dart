import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 화상진료 메인 페이지
/// 기획안: /more/video-services/telemedicine
class TelemedicineMainPage extends StatefulWidget {
  const TelemedicineMainPage({Key? key}) : super(key: key);

  @override
  State<TelemedicineMainPage> createState() => _TelemedicineMainPageState();
}

class _TelemedicineMainPageState extends State<TelemedicineMainPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('화상진료'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.go('/telemedicine/history'),
          ),
        ],
      ),
      body: Column(
        children: [
          // 탭 바
          Container(
            color: Colors.white,
            child: Row(
              children: [
                _buildTab(0, '의사 찾기', Icons.person_search),
                _buildTab(1, '내 예약', Icons.calendar_today),
                _buildTab(2, '진료 기록', Icons.medical_information),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // 탭 컨텐츠
          Expanded(
            child: IndexedStack(
              index: _selectedTabIndex,
              children: [
                _buildDoctorSearchTab(),
                _buildAppointmentsTab(),
                _buildMedicalRecordsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String label, IconData icon) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.grey,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorSearchTab() {
    final doctors = [
      DoctorInfo(
        id: '1',
        name: '김건강 전문의',
        specialty: '내분비내과',
        hospital: '만파식 디지털병원',
        rating: 4.9,
        reviewCount: 128,
        experience: '15년 경력',
        languages: ['한국어', 'English'],
        nextAvailable: DateTime.now().add(const Duration(hours: 2)),
        consultationFee: 30000,
        isOnline: true,
      ),
      DoctorInfo(
        id: '2',
        name: '박영양 전문의',
        specialty: '영양의학과',
        hospital: '서울대학교병원',
        rating: 4.8,
        reviewCount: 95,
        experience: '12년 경력',
        languages: ['한국어'],
        nextAvailable: DateTime.now().add(const Duration(days: 1)),
        consultationFee: 40000,
        isOnline: false,
      ),
      DoctorInfo(
        id: '3',
        name: '이심장 전문의',
        specialty: '심장내과',
        hospital: '삼성서울병원',
        rating: 4.9,
        reviewCount: 210,
        experience: '20년 경력',
        languages: ['한국어', 'English', '日本語'],
        nextAvailable: DateTime.now().add(const Duration(hours: 4)),
        consultationFee: 50000,
        isOnline: true,
      ),
      DoctorInfo(
        id: '4',
        name: '최당뇨 전문의',
        specialty: '당뇨병 전문',
        hospital: '연세의료원',
        rating: 4.7,
        reviewCount: 156,
        experience: '18년 경력',
        languages: ['한국어', 'English'],
        nextAvailable: DateTime.now().add(const Duration(hours: 1)),
        consultationFee: 35000,
        isOnline: true,
      ),
    ];

    return Column(
      children: [
        // 검색 바
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: '전문분야, 의사 이름으로 검색',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ),

        // 필터 칩
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(label: '지금 상담 가능', icon: Icons.circle, iconColor: Colors.green),
                _FilterChip(label: '내분비내과'),
                _FilterChip(label: '당뇨 전문'),
                _FilterChip(label: '영양 상담'),
                _FilterChip(label: '심장내과'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        // 의사 목록
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              return _DoctorCard(
                doctor: doctors[index],
                onTap: () => context.go('/telemedicine/doctor/${doctors[index].id}'),
                onBookNow: () => _showBookingDialog(doctors[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentsTab() {
    final appointments = [
      AppointmentInfo(
        id: '1',
        doctorName: '김건강 전문의',
        specialty: '내분비내과',
        scheduledTime: DateTime.now().add(const Duration(hours: 2)),
        status: AppointmentStatus.confirmed,
        type: ConsultationType.video,
      ),
      AppointmentInfo(
        id: '2',
        doctorName: '최당뇨 전문의',
        specialty: '당뇨병 전문',
        scheduledTime: DateTime.now().add(const Duration(days: 2)),
        status: AppointmentStatus.pending,
        type: ConsultationType.video,
      ),
    ];

    return appointments.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text('예정된 진료가 없습니다', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() => _selectedTabIndex = 0),
                  child: const Text('의사 찾기'),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              return _AppointmentCard(
                appointment: appointments[index],
                onJoin: () => _startConsultation(appointments[index]),
                onCancel: () => _showCancelDialog(appointments[index]),
                onReschedule: () {},
              );
            },
          );
  }

  Widget _buildMedicalRecordsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _MedicalRecordCard(
          date: DateTime(2025, 12, 28),
          doctorName: '김건강 전문의',
          diagnosis: '경계성 높은 혈당',
          prescription: '생활습관 개선 권고',
          onViewDetails: () {},
        ),
        _MedicalRecordCard(
          date: DateTime(2025, 12, 15),
          doctorName: '최당뇨 전문의',
          diagnosis: '제2형 당뇨병 관리',
          prescription: '메트포르민 500mg',
          onViewDetails: () {},
        ),
      ],
    );
  }

  void _showBookingDialog(DoctorInfo doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _BookingSheet(doctor: doctor),
    );
  }

  void _startConsultation(AppointmentInfo appointment) {
    context.go('/telemedicine/video-call/${appointment.id}');
  }

  void _showCancelDialog(AppointmentInfo appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('예약 취소'),
        content: Text('${appointment.doctorName}님과의 예약을 취소하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('예약이 취소되었습니다')),
              );
            },
            child: const Text('예'),
          ),
        ],
      ),
    );
  }
}

// ============ 모델 ============
class DoctorInfo {
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final double rating;
  final int reviewCount;
  final String experience;
  final List<String> languages;
  final DateTime nextAvailable;
  final int consultationFee;
  final bool isOnline;

  DoctorInfo({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.rating,
    required this.reviewCount,
    required this.experience,
    required this.languages,
    required this.nextAvailable,
    required this.consultationFee,
    required this.isOnline,
  });
}

class AppointmentInfo {
  final String id;
  final String doctorName;
  final String specialty;
  final DateTime scheduledTime;
  final AppointmentStatus status;
  final ConsultationType type;

  AppointmentInfo({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.scheduledTime,
    required this.status,
    required this.type,
  });
}

enum AppointmentStatus { pending, confirmed, completed, cancelled }
enum ConsultationType { video, chat, phone }

// ============ 위젯 ============
class _FilterChip extends StatefulWidget {
  final String label;
  final IconData? icon;
  final Color? iconColor;

  const _FilterChip({required this.label, this.icon, this.iconColor});

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: _isSelected,
        onSelected: (selected) => setState(() => _isSelected = selected),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, size: 12, color: widget.iconColor ?? Colors.grey),
              const SizedBox(width: 4),
            ],
            Text(widget.label),
          ],
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final DoctorInfo doctor;
  final VoidCallback onTap;
  final VoidCallback onBookNow;

  const _DoctorCard({
    required this.doctor,
    required this.onTap,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 프로필 이미지
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue[100],
                        child: Icon(Icons.person, color: Colors.blue[600], size: 32),
                      ),
                      if (doctor.isOnline)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${doctor.specialty} · ${doctor.hospital}',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, size: 14, color: Colors.amber[600]),
                            Text(' ${doctor.rating}', style: const TextStyle(fontSize: 12)),
                            Text(' (${doctor.reviewCount})', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            const SizedBox(width: 12),
                            Text(doctor.experience, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '다음 상담 가능',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      Text(
                        _formatNextAvailable(doctor.nextAvailable),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '상담료',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      Text(
                        '₩${_formatPrice(doctor.consultationFee)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[600],
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: onBookNow,
                    child: const Text('예약'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNextAvailable(DateTime time) {
    final diff = time.difference(DateTime.now());
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 후';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}시간 후';
    } else {
      return '${diff.inDays}일 후';
    }
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentInfo appointment;
  final VoidCallback onJoin;
  final VoidCallback onCancel;
  final VoidCallback onReschedule;

  const _AppointmentCard({
    required this.appointment,
    required this.onJoin,
    required this.onCancel,
    required this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final isUpcoming = appointment.scheduledTime.difference(DateTime.now()).inMinutes <= 15;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isUpcoming ? BorderSide(color: Colors.green[400]!, width: 2) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isUpcoming)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.video_call, size: 16, color: Colors.green[700]),
                    const SizedBox(width: 4),
                    Text(
                      '곧 시작됩니다',
                      style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Icon(Icons.person, color: Colors.blue[600]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        appointment.specialty,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(_formatDateTime(appointment.scheduledTime)),
                const SizedBox(width: 16),
                Icon(Icons.videocam, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                const Text('화상 상담'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (isUpcoming)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onJoin,
                      icon: const Icon(Icons.video_call),
                      label: const Text('입장하기'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                  )
                else ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onReschedule,
                      child: const Text('일정 변경'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      onPressed: onCancel,
                      child: const Text('취소', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    switch (appointment.status) {
      case AppointmentStatus.confirmed:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text('확정', style: TextStyle(color: Colors.green[700], fontSize: 12)),
        );
      case AppointmentStatus.pending:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text('대기 중', style: TextStyle(color: Colors.orange[700], fontSize: 12)),
        );
      default:
        return const SizedBox();
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (date == today) {
      dateStr = '오늘';
    } else if (date == tomorrow) {
      dateStr = '내일';
    } else {
      dateStr = '${dateTime.month}/${dateTime.day}';
    }

    return '$dateStr ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _MedicalRecordCard extends StatelessWidget {
  final DateTime date;
  final String doctorName;
  final String diagnosis;
  final String prescription;
  final VoidCallback onViewDetails;

  const _MedicalRecordCard({
    required this.date,
    required this.doctorName,
    required this.diagnosis,
    required this.prescription,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onViewDetails,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(doctorName, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.medical_information, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text('진단: $diagnosis'),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.medication, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text('처방: $prescription'),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onViewDetails,
                  child: const Text('상세 보기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingSheet extends StatefulWidget {
  final DoctorInfo doctor;

  const _BookingSheet({required this.doctor});

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  String? _selectedReason;

  final List<String> _availableTimes = [
    '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
    '14:00', '14:30', '15:00', '15:30', '16:00', '16:30',
  ];

  final List<String> _consultationReasons = [
    '혈당 관리 상담',
    '측정 결과 해석',
    '처방전 갱신',
    '생활습관 조언',
    '기타 문의',
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              // 헤더
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue[100],
                    child: Icon(Icons.person, color: Colors.blue[600]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctor.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          widget.doctor.specialty,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 날짜 선택
              const Text('날짜 선택', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 14,
                  itemBuilder: (context, index) {
                    final date = DateTime.now().add(Duration(days: index));
                    final isSelected = _selectedDate.day == date.day &&
                        _selectedDate.month == date.month;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDate = date),
                      child: Container(
                        width: 60,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ['월', '화', '수', '목', '금', '토', '일'][date.weekday - 1],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${date.day}',
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // 시간 선택
              const Text('시간 선택', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableTimes.map((time) {
                  final isSelected = _selectedTime == time;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTime = time),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // 상담 사유
              const Text('상담 사유', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _consultationReasons.map((reason) {
                  final isSelected = _selectedReason == reason;
                  return ChoiceChip(
                    label: Text(reason),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedReason = selected ? reason : null);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // 요금 안내
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('상담료'),
                    Text(
                      '₩${widget.doctor.consultationFee.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 예약 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedTime != null && _selectedReason != null
                      ? () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('예약이 완료되었습니다')),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('예약 확정'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
