import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// 2단계 인증 설정 페이지
class TwoFactorSetupPage extends StatefulWidget {
  const TwoFactorSetupPage({super.key});

  @override
  State<TwoFactorSetupPage> createState() => _TwoFactorSetupPageState();
}

class _TwoFactorSetupPageState extends State<TwoFactorSetupPage> {
  int _currentStep = 0;
  bool _isEnabled = false;
  final List<TextEditingController> _codeControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  // 시뮬레이션용 시크릿 키
  final String _secretKey = 'JBSWY3DPEHPK3PXP';

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _copySecretKey() {
    Clipboard.setData(ClipboardData(text: _secretKey));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('시크릿 키가 복사되었습니다')),
    );
  }

  void _verifyCode() {
    final code = _codeControllers.map((c) => c.text).join();
    if (code.length == 6) {
      // 시뮬레이션: 코드 검증
      setState(() {
        _isEnabled = true;
        _currentStep = 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('2단계 인증 설정'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          } else {
            context.pop();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        steps: [
          // Step 1: 인증 앱 다운로드
          Step(
            title: const Text('인증 앱 준비'),
            content: _buildStep1(theme),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),

          // Step 2: QR 코드 스캔 및 코드 입력
          Step(
            title: const Text('인증 설정'),
            content: _buildStep2(theme),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),

          // Step 3: 완료
          Step(
            title: const Text('설정 완료'),
            content: _buildStep3(theme),
            isActive: _currentStep >= 2,
            state: _isEnabled ? StepState.complete : StepState.indexed,
          ),
        ],
      ),
    );
  }

  Widget _buildStep1(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Google Authenticator 또는 다른 인증 앱을 설치해주세요.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),

        // 앱 다운로드 링크
        _buildAppButton(
          icon: Icons.android,
          title: 'Google Authenticator',
          subtitle: 'Google Play에서 다운로드',
          color: Colors.green,
        ),
        const SizedBox(height: 8),
        _buildAppButton(
          icon: Icons.apple,
          title: 'Google Authenticator',
          subtitle: 'App Store에서 다운로드',
          color: Colors.black87,
        ),
        const SizedBox(height: 8),
        _buildAppButton(
          icon: Icons.security,
          title: 'Microsoft Authenticator',
          subtitle: '각 스토어에서 다운로드',
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildAppButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.open_in_new),
        onTap: () {
          // 앱 스토어 링크 열기
        },
      ),
    );
  }

  Widget _buildStep2(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // QR 코드 (시뮬레이션)
        Center(
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_2, size: 120, color: Colors.grey[800]),
                const SizedBox(height: 8),
                Text(
                  'QR 코드',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 수동 입력 키
        Text(
          'QR 코드를 스캔할 수 없는 경우, 아래 키를 수동으로 입력하세요:',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _secretKey,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: _copySecretKey,
                tooltip: '복사',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // 인증 코드 입력
        const Text(
          '인증 앱에서 표시되는 6자리 코드를 입력하세요:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 45,
              child: TextField(
                controller: _codeControllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  if (value.isNotEmpty && index < 5) {
                    _focusNodes[index + 1].requestFocus();
                  }
                  if (_codeControllers.every((c) => c.text.isNotEmpty)) {
                    _verifyCode();
                  }
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStep3(ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.verified_user,
            size: 64,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 24),

        Text(
          '2단계 인증이 활성화되었습니다!',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        Text(
          '이제 로그인할 때마다 인증 앱의 코드가 필요합니다.\n계정 보안이 강화되었습니다.',
          style: TextStyle(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 24),

        // 백업 코드 안내
        Card(
          color: Colors.amber.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.warning_amber, color: Colors.amber),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '백업 코드를 저장하세요',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '휴대폰 분실 시 계정 복구에 필요합니다.',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // 백업 코드 표시
                  },
                  child: const Text('보기'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
