import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 알림 센터 페이지
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _notifications =
      _generateSampleNotifications();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Theme removed as it was unused

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: _markAllAsRead,
            tooltip: '모두 읽음',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
                // 알림 설정으로 이동
              } else if (value == 'clear') {
                _clearAllNotifications();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'settings', child: Text('알림 설정')),
              const PopupMenuItem(value: 'clear', child: Text('모두 삭제')),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '전체'),
            Tab(text: '건강'),
            Tab(text: '시스템'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationList(_notifications),
          _buildNotificationList(
              _notifications.where((n) => n['category'] == 'health').toList()),
          _buildNotificationList(
              _notifications.where((n) => n['category'] == 'system').toList()),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              '알림이 없습니다',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final notification = items[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool;

    return Dismissible(
      key: Key(notification['id']),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        setState(() {
          _notifications.removeWhere((n) => n['id'] == notification['id']);
        });
      },
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getNotificationColor(notification['type']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getNotificationIcon(notification['type']),
            color: _getNotificationColor(notification['type']),
          ),
        ),
        title: Text(
          notification['title'],
          style: TextStyle(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification['message'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(notification['timestamp']),
              style: TextStyle(fontSize: 11, color: Colors.grey[400]),
            ),
          ],
        ),
        trailing: isRead
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
        onTap: () {
          setState(() {
            notification['isRead'] = true;
          });
          _handleNotificationTap(notification);
        },
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'measurement':
        return Icons.science;
      case 'alert':
        return Icons.warning;
      case 'reminder':
        return Icons.alarm;
      case 'achievement':
        return Icons.emoji_events;
      case 'tip':
        return Icons.lightbulb;
      case 'update':
        return Icons.system_update;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'measurement':
        return Colors.blue;
      case 'alert':
        return Colors.red;
      case 'reminder':
        return Colors.orange;
      case 'achievement':
        return Colors.amber;
      case 'tip':
        return Colors.teal;
      case 'update':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    return DateFormat('MM/dd').format(time);
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    // 알림 유형에 따라 해당 페이지로 이동
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('모든 알림을 읽음으로 표시했습니다')),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('모든 알림 삭제'),
        content: const Text('모든 알림을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _notifications.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> _generateSampleNotifications() {
  final now = DateTime.now();
  return [
    {
      'id': '1',
      'type': 'measurement',
      'category': 'health',
      'title': '측정 완료',
      'message': '혈당 측정이 완료되었습니다. 결과: 95 mg/dL (정상)',
      'timestamp': now.subtract(const Duration(minutes: 5)),
      'isRead': false,
    },
    {
      'id': '2',
      'type': 'reminder',
      'category': 'health',
      'title': '측정 알림',
      'message': '오후 혈당 측정 시간입니다.',
      'timestamp': now.subtract(const Duration(hours: 2)),
      'isRead': false,
    },
    {
      'id': '3',
      'type': 'tip',
      'category': 'health',
      'title': '건강 팁',
      'message': '식후 30분 가벼운 산책은 혈당 조절에 도움이 됩니다.',
      'timestamp': now.subtract(const Duration(hours: 5)),
      'isRead': true,
    },
    {
      'id': '4',
      'type': 'achievement',
      'category': 'health',
      'title': '목표 달성!',
      'message': '7일 연속 측정 목표를 달성했습니다. 축하합니다!',
      'timestamp': now.subtract(const Duration(days: 1)),
      'isRead': true,
    },
    {
      'id': '5',
      'type': 'alert',
      'category': 'health',
      'title': '주의 필요',
      'message': '최근 혈압이 상승 추세입니다. 의료진 상담을 권장합니다.',
      'timestamp': now.subtract(const Duration(days: 2)),
      'isRead': true,
    },
    {
      'id': '6',
      'type': 'update',
      'category': 'system',
      'title': '앱 업데이트',
      'message': '새로운 버전이 출시되었습니다. 업데이트하여 새로운 기능을 확인하세요.',
      'timestamp': now.subtract(const Duration(days: 3)),
      'isRead': true,
    },
  ];
}
