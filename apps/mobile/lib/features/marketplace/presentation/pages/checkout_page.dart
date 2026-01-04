import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 결제 페이지
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPayment = 'card';
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결제'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 배송 정보
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '배송 정보',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('이름', '김만팍'),
                  _buildInfoRow('주소', '서울시 강남구 테헤란로 123'),
                  _buildInfoRow('연락처', '010-1234-5678'),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {},
                    child: const Text('주소 변경'),
                  ),
                ],
              ),
            ),

            // 주문 상품
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '주문 상품',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildOrderItem('프리미엄 혈당 측정 카트리지 × 2', 179800),
                  _buildOrderItem('비타민 D3 60정 × 1', 29900),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('소계', style: Theme.of(context).textTheme.labelLarge),
                        Text('₩209,700', style: Theme.of(context).textTheme.labelLarge),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 배송비 및 요금
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCostRow('배송비', '무료', Colors.green),
                  const SizedBox(height: 8),
                  _buildCostRow('쿠폰 할인', '-₩10,000', Colors.blue),
                  const Divider(),
                  _buildCostRow('총 결제 금액', '₩199,700', Colors.black,
                    isTotal: true),
                ],
              ),
            ),

            // 결제 수단
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '결제 수단',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentMethod('card', '신용카드'),
                  _buildPaymentMethod('bank', '계좌이체'),
                  _buildPaymentMethod('mobile', '휴대폰'),
                  _buildPaymentMethod('wallet', '간편결제'),
                ],
              ),
            ),

            // 약관 동의
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    value: _agreeToTerms,
                    onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
                    title: const Text('주문 및 결제 약관에 동의합니다'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: _agreeToTerms ? Colors.blue : Colors.grey,
                      ),
                      onPressed: _agreeToTerms
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('결제 완료! 주문번호: #2024001234')),
                              );
                              Future.delayed(const Duration(seconds: 2), () {
                                context.go('/marketplace/orders');
                              });
                            }
                          : null,
                      child: const Text('결제하기', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          )),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String name, int price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(name)),
          Text('₩$price', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, String value, Color color, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(String value, String label) {
    return RadioListTile(
      value: value,
      groupValue: _selectedPayment,
      onChanged: (val) => setState(() => _selectedPayment = val ?? 'card'),
      title: Text(label),
      contentPadding: EdgeInsets.zero,
    );
  }
}
