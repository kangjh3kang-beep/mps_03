import 'package:flutter/material.dart';

enum DeviceType { mobile, pc, reader }

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget pcBody;
  final Widget readerBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.pcBody,
    required this.readerBody,
  });

  static DeviceType getDeviceType(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // 실제로는 하드웨어 식별 로직이 추가될 수 있음
    if (width < 600) return DeviceType.mobile;
    if (width < 1200) return DeviceType.pc;
    return DeviceType.pc; // 기본적으로 PC
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobileBody;
        } else if (constraints.maxWidth < 1200) {
          return pcBody;
        } else {
          // 리더기 전용 모드는 특정 조건이나 설정에서 활성화될 수 있음
          // 여기서는 예시로 1200 이상일 때 PC 레이아웃을 기본으로 함
          return pcBody;
        }
      },
    );
  }
}
