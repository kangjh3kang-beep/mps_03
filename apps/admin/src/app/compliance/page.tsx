/**
 * 규제 준수 대시보드 (FDA/MFDS Compliance)
 * @path /compliance
 */

'use client';

import { useState, useEffect } from 'react';

interface ComplianceItem {
  id: string;
  category: 'data_integrity' | 'audit_trail' | 'security' | 'quality' | 'documentation';
  name: string;
  status: 'compliant' | 'warning' | 'non_compliant' | 'pending';
  lastAudit: string;
  nextAudit: string;
  score: number;
  details: string;
}

interface AuditLog {
  id: string;
  timestamp: string;
  action: string;
  user: string;
  resource: string;
  status: 'success' | 'failed';
  ipAddress: string;
}

export default function CompliancePage() {
  const [complianceItems, setComplianceItems] = useState<ComplianceItem[]>([]);
  const [auditLogs, setAuditLogs] = useState<AuditLog[]>([]);
  const [activeTab, setActiveTab] = useState<'overview' | 'audit' | 'reports'>('overview');

  useEffect(() => {
    const sampleItems: ComplianceItem[] = [
      { id: 'c1', category: 'data_integrity', name: '데이터 무결성 검증 (21 CFR Part 11)', status: 'compliant', lastAudit: '2026-01-01', nextAudit: '2026-02-01', score: 98, details: 'SHA-256 해시 체인 검증 통과' },
      { id: 'c2', category: 'audit_trail', name: '감사 추적 시스템', status: 'compliant', lastAudit: '2026-01-02', nextAudit: '2026-02-02', score: 100, details: '모든 데이터 변경 기록됨' },
      { id: 'c3', category: 'security', name: 'RSA-4096 전자 서명', status: 'compliant', lastAudit: '2026-01-03', nextAudit: '2026-02-03', score: 100, details: '모든 서명 검증 완료' },
      { id: 'c4', category: 'security', name: 'AES-256 암호화', status: 'compliant', lastAudit: '2026-01-03', nextAudit: '2026-02-03', score: 100, details: '민감 데이터 암호화 적용' },
      { id: 'c5', category: 'quality', name: 'AI 진단 정확도', status: 'compliant', lastAudit: '2026-01-04', nextAudit: '2026-02-04', score: 94, details: '94.5% 정확도 달성 (목표: 90%)' },
      { id: 'c6', category: 'quality', name: '센서 캘리브레이션', status: 'warning', lastAudit: '2025-12-15', nextAudit: '2026-01-15', score: 85, details: '일부 기기 재캘리브레이션 필요' },
      { id: 'c7', category: 'documentation', name: '기술 문서화', status: 'warning', lastAudit: '2025-12-20', nextAudit: '2026-01-20', score: 78, details: 'API 문서 업데이트 필요' },
      { id: 'c8', category: 'documentation', name: '사용자 매뉴얼', status: 'compliant', lastAudit: '2026-01-02', nextAudit: '2026-04-02', score: 95, details: '최신 버전 배포 완료' },
    ];

    const sampleLogs: AuditLog[] = [
      { id: 'l1', timestamp: '2026-01-05 09:45:23', action: '측정 데이터 생성', user: 'system', resource: 'measurement/12345', status: 'success', ipAddress: '10.0.1.50' },
      { id: 'l2', timestamp: '2026-01-05 09:30:11', action: '사용자 로그인', user: 'admin@manpasik.com', resource: 'auth/login', status: 'success', ipAddress: '192.168.1.100' },
      { id: 'l3', timestamp: '2026-01-05 09:15:45', action: 'AI 모델 배포', user: 'admin@manpasik.com', resource: 'ai-model/m1', status: 'success', ipAddress: '192.168.1.100' },
      { id: 'l4', timestamp: '2026-01-05 08:55:00', action: '데이터 무결성 검증', user: 'system', resource: 'data-blocks/*', status: 'success', ipAddress: '10.0.0.1' },
      { id: 'l5', timestamp: '2026-01-05 08:30:12', action: '무단 접근 시도', user: 'unknown', resource: 'admin/users', status: 'failed', ipAddress: '203.45.67.89' },
      { id: 'l6', timestamp: '2026-01-04 23:00:00', action: '자동 백업 완료', user: 'system', resource: 'backup/daily', status: 'success', ipAddress: '10.0.0.1' },
    ];

    setComplianceItems(sampleItems);
    setAuditLogs(sampleLogs);
  }, []);

  const categoryLabels: Record<string, { label: string; icon: string }> = {
    data_integrity: { label: '데이터 무결성', icon: '🔐' },
    audit_trail: { label: '감사 추적', icon: '📝' },
    security: { label: '보안', icon: '🛡️' },
    quality: { label: '품질', icon: '✅' },
    documentation: { label: '문서화', icon: '📄' },
  };

  const overallScore = Math.round(complianceItems.reduce((sum, i) => sum + i.score, 0) / complianceItems.length);
  const compliantCount = complianceItems.filter(i => i.status === 'compliant').length;
  const warningCount = complianceItems.filter(i => i.status === 'warning').length;

  return (
    <div className="p-6 bg-gray-900 min-h-screen text-white">
      <h1 className="text-3xl font-bold mb-2">📋 규제 준수 대시보드</h1>
      <p className="text-gray-400 mb-6">FDA 21 CFR Part 11 / MFDS 의료기기 규정 준수 현황</p>

      {/* 전체 현황 */}
      <div className="grid grid-cols-4 gap-4 mb-6">
        <div className="bg-gradient-to-r from-cyan-800 to-cyan-600 p-6 rounded-lg text-center">
          <div className="text-5xl font-bold mb-2">{overallScore}%</div>
          <div className="text-cyan-200">전체 준수율</div>
        </div>
        <div className="bg-gray-800 p-6 rounded-lg">
          <div className="text-3xl font-bold text-green-400">{compliantCount}</div>
          <div className="text-gray-400">준수 항목</div>
          <div className="mt-2 h-2 bg-gray-700 rounded-full">
            <div className="h-full bg-green-500 rounded-full" style={{ width: `${(compliantCount / complianceItems.length) * 100}%` }} />
          </div>
        </div>
        <div className="bg-gray-800 p-6 rounded-lg">
          <div className="text-3xl font-bold text-yellow-400">{warningCount}</div>
          <div className="text-gray-400">주의 항목</div>
          <div className="mt-2 h-2 bg-gray-700 rounded-full">
            <div className="h-full bg-yellow-500 rounded-full" style={{ width: `${(warningCount / complianceItems.length) * 100}%` }} />
          </div>
        </div>
        <div className="bg-gray-800 p-6 rounded-lg">
          <div className="text-3xl font-bold text-blue-400">{auditLogs.length}</div>
          <div className="text-gray-400">오늘 감사 로그</div>
        </div>
      </div>

      {/* 탭 */}
      <div className="flex gap-2 mb-6">
        {['overview', 'audit', 'reports'].map((tab) => (
          <button
            key={tab}
            onClick={() => setActiveTab(tab as any)}
            className={`px-4 py-2 rounded-lg font-semibold ${
              activeTab === tab ? 'bg-cyan-600' : 'bg-gray-700 hover:bg-gray-600'
            }`}
          >
            {tab === 'overview' ? '📊 규제 현황' : tab === 'audit' ? '📝 감사 로그' : '📋 보고서'}
          </button>
        ))}
      </div>

      {/* 규제 현황 탭 */}
      {activeTab === 'overview' && (
        <div className="space-y-4">
          {Object.entries(categoryLabels).map(([cat, info]) => {
            const items = complianceItems.filter(i => i.category === cat);
            if (items.length === 0) return null;
            return (
              <div key={cat} className="bg-gray-800 rounded-lg overflow-hidden">
                <div className="p-4 bg-gray-700 flex items-center gap-2">
                  <span className="text-xl">{info.icon}</span>
                  <span className="font-bold">{info.label}</span>
                </div>
                <div className="divide-y divide-gray-700">
                  {items.map((item) => (
                    <div key={item.id} className="p-4 flex items-center justify-between">
                      <div className="flex-1">
                        <div className="font-medium">{item.name}</div>
                        <div className="text-sm text-gray-400">{item.details}</div>
                      </div>
                      <div className="flex items-center gap-4">
                        <div className="text-right">
                          <div className="text-sm text-gray-400">점수</div>
                          <div className={`text-lg font-bold ${item.score >= 90 ? 'text-green-400' : item.score >= 70 ? 'text-yellow-400' : 'text-red-400'}`}>
                            {item.score}%
                          </div>
                        </div>
                        <div className="text-right">
                          <div className="text-sm text-gray-400">다음 감사</div>
                          <div className="text-sm">{item.nextAudit}</div>
                        </div>
                        <span className={`px-3 py-1 rounded text-sm font-medium ${
                          item.status === 'compliant' ? 'bg-green-600' :
                          item.status === 'warning' ? 'bg-yellow-600' :
                          item.status === 'non_compliant' ? 'bg-red-600' : 'bg-gray-600'
                        }`}>
                          {item.status === 'compliant' ? '준수' : item.status === 'warning' ? '주의' : item.status === 'non_compliant' ? '미준수' : '대기'}
                        </span>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            );
          })}
        </div>
      )}

      {/* 감사 로그 탭 */}
      {activeTab === 'audit' && (
        <div className="bg-gray-800 rounded-lg overflow-hidden">
          <table className="w-full">
            <thead className="bg-gray-700">
              <tr>
                <th className="px-4 py-3 text-left">시간</th>
                <th className="px-4 py-3 text-left">작업</th>
                <th className="px-4 py-3 text-left">사용자</th>
                <th className="px-4 py-3 text-left">리소스</th>
                <th className="px-4 py-3 text-left">IP 주소</th>
                <th className="px-4 py-3 text-left">상태</th>
              </tr>
            </thead>
            <tbody>
              {auditLogs.map((log) => (
                <tr key={log.id} className="border-t border-gray-700 hover:bg-gray-750">
                  <td className="px-4 py-3 font-mono text-sm">{log.timestamp}</td>
                  <td className="px-4 py-3">{log.action}</td>
                  <td className="px-4 py-3">{log.user}</td>
                  <td className="px-4 py-3 font-mono text-sm text-gray-400">{log.resource}</td>
                  <td className="px-4 py-3 font-mono text-sm">{log.ipAddress}</td>
                  <td className="px-4 py-3">
                    <span className={`px-2 py-1 rounded text-xs ${log.status === 'success' ? 'bg-green-600' : 'bg-red-600'}`}>
                      {log.status === 'success' ? '성공' : '실패'}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* 보고서 탭 */}
      {activeTab === 'reports' && (
        <div className="grid grid-cols-2 gap-6">
          <div className="bg-gray-800 rounded-lg p-6">
            <h3 className="text-xl font-bold mb-4">📄 보고서 생성</h3>
            <div className="space-y-4">
              <button className="w-full p-4 bg-gray-700 hover:bg-gray-600 rounded-lg text-left">
                <div className="font-medium">FDA 21 CFR Part 11 준수 보고서</div>
                <div className="text-sm text-gray-400">전자 기록 및 전자 서명 규정 준수 현황</div>
              </button>
              <button className="w-full p-4 bg-gray-700 hover:bg-gray-600 rounded-lg text-left">
                <div className="font-medium">데이터 무결성 보고서</div>
                <div className="text-sm text-gray-400">해시 체인 검증 및 서명 검증 결과</div>
              </button>
              <button className="w-full p-4 bg-gray-700 hover:bg-gray-600 rounded-lg text-left">
                <div className="font-medium">월간 감사 보고서</div>
                <div className="text-sm text-gray-400">2026년 1월 감사 로그 요약</div>
              </button>
              <button className="w-full p-4 bg-gray-700 hover:bg-gray-600 rounded-lg text-left">
                <div className="font-medium">AI 모델 검증 보고서</div>
                <div className="text-sm text-gray-400">진단 정확도 및 성능 분석</div>
              </button>
            </div>
          </div>
          <div className="bg-gray-800 rounded-lg p-6">
            <h3 className="text-xl font-bold mb-4">📊 최근 보고서</h3>
            <div className="space-y-3">
              {[
                { name: 'FDA_Compliance_2026_01.pdf', date: '2026-01-04', size: '2.3 MB' },
                { name: 'Data_Integrity_Report.pdf', date: '2026-01-03', size: '1.8 MB' },
                { name: 'Monthly_Audit_Dec_2025.pdf', date: '2026-01-01', size: '3.1 MB' },
              ].map((report, i) => (
                <div key={i} className="flex items-center justify-between p-3 bg-gray-700 rounded-lg">
                  <div>
                    <div className="font-medium">{report.name}</div>
                    <div className="text-sm text-gray-400">{report.date} • {report.size}</div>
                  </div>
                  <button className="px-3 py-1 bg-cyan-600 hover:bg-cyan-500 rounded text-sm">
                    다운로드
                  </button>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
