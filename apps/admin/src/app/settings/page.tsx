/**
 * 시스템 설정 페이지
 * @path /settings
 */

'use client';

import { useState } from 'react';

interface SystemConfig {
  category: string;
  items: {
    key: string;
    name: string;
    value: string | number | boolean;
    type: 'text' | 'number' | 'boolean' | 'select';
    options?: string[];
    description: string;
  }[];
}

export default function SettingsPage() {
  const [activeCategory, setActiveCategory] = useState('general');
  const [saving, setSaving] = useState(false);

  const configs: SystemConfig[] = [
    {
      category: 'general',
      items: [
        { key: 'site_name', name: '사이트 이름', value: '만파식 관리자', type: 'text', description: '관리자 대시보드 이름' },
        { key: 'language', name: '기본 언어', value: 'ko', type: 'select', options: ['ko', 'en', 'ja', 'zh'], description: '시스템 기본 언어' },
        { key: 'timezone', name: '시간대', value: 'Asia/Seoul', type: 'select', options: ['Asia/Seoul', 'UTC', 'America/New_York', 'Europe/London'], description: '시스템 시간대' },
        { key: 'maintenance_mode', name: '유지보수 모드', value: false, type: 'boolean', description: '활성화 시 일반 사용자 접근 차단' },
      ]
    },
    {
      category: 'security',
      items: [
        { key: 'jwt_expiry', name: 'JWT 토큰 만료 시간', value: 3600, type: 'number', description: '초 단위 (기본: 3600초 = 1시간)' },
        { key: 'refresh_token_expiry', name: '리프레시 토큰 만료', value: 604800, type: 'number', description: '초 단위 (기본: 7일)' },
        { key: 'require_2fa', name: '2FA 필수', value: true, type: 'boolean', description: '관리자 계정 2단계 인증 필수' },
        { key: 'max_login_attempts', name: '최대 로그인 시도', value: 5, type: 'number', description: '잠금 전 최대 시도 횟수' },
        { key: 'lockout_duration', name: '잠금 시간', value: 900, type: 'number', description: '초 단위 (기본: 15분)' },
        { key: 'password_min_length', name: '비밀번호 최소 길이', value: 8, type: 'number', description: '최소 8자 이상 권장' },
        { key: 'session_timeout', name: '세션 타임아웃', value: 1800, type: 'number', description: '초 단위 (기본: 30분)' },
      ]
    },
    {
      category: 'ai',
      items: [
        { key: 'ai_confidence_threshold', name: 'AI 신뢰도 임계값', value: 0.85, type: 'number', description: '진단 결과 표시 최소 신뢰도' },
        { key: 'emergency_detection', name: '응급 상황 감지', value: true, type: 'boolean', description: '응급 상황 자동 감지 및 알림' },
        { key: 'auto_retrain', name: '자동 재학습', value: true, type: 'boolean', description: '주간 자동 모델 재학습' },
        { key: 'model_version', name: '활성 모델 버전', value: 'v2.3.1', type: 'text', description: '현재 프로덕션 모델' },
        { key: 'prediction_horizon', name: '예측 기간', value: 72, type: 'number', description: '시간 단위 예측 범위' },
      ]
    },
    {
      category: 'notifications',
      items: [
        { key: 'email_enabled', name: '이메일 알림', value: true, type: 'boolean', description: '이메일 알림 활성화' },
        { key: 'push_enabled', name: '푸시 알림', value: true, type: 'boolean', description: '모바일 푸시 알림' },
        { key: 'sms_enabled', name: 'SMS 알림', value: false, type: 'boolean', description: '긴급 상황 SMS 알림' },
        { key: 'admin_email', name: '관리자 이메일', value: 'admin@manpasik.com', type: 'text', description: '시스템 알림 수신 이메일' },
        { key: 'alert_cooldown', name: '알림 쿨다운', value: 300, type: 'number', description: '동일 알림 재발송 대기 시간 (초)' },
      ]
    },
    {
      category: 'data',
      items: [
        { key: 'data_retention_days', name: '데이터 보존 기간', value: 365, type: 'number', description: '일 단위 (기본: 1년)' },
        { key: 'backup_enabled', name: '자동 백업', value: true, type: 'boolean', description: '일일 자동 백업' },
        { key: 'backup_time', name: '백업 시간', value: '03:00', type: 'text', description: '일일 백업 실행 시간 (KST)' },
        { key: 'encryption_at_rest', name: '저장 시 암호화', value: true, type: 'boolean', description: 'AES-256 암호화 적용' },
        { key: 'audit_retention', name: '감사 로그 보존', value: 2190, type: 'number', description: '일 단위 (기본: 6년, FDA 규정)' },
      ]
    },
    {
      category: 'api',
      items: [
        { key: 'rate_limit', name: 'API 요청 제한', value: 1000, type: 'number', description: '분당 최대 요청 수' },
        { key: 'api_timeout', name: 'API 타임아웃', value: 30, type: 'number', description: '초 단위' },
        { key: 'cors_origins', name: 'CORS 허용 도메인', value: '*', type: 'text', description: '콤마로 구분 (* = 모두 허용)' },
        { key: 'api_versioning', name: 'API 버전', value: 'v1', type: 'select', options: ['v1', 'v2'], description: '현재 활성 API 버전' },
      ]
    }
  ];

  const categories = [
    { id: 'general', name: '일반', icon: '⚙️' },
    { id: 'security', name: '보안', icon: '🔐' },
    { id: 'ai', name: 'AI 설정', icon: '🤖' },
    { id: 'notifications', name: '알림', icon: '🔔' },
    { id: 'data', name: '데이터', icon: '💾' },
    { id: 'api', name: 'API', icon: '🔌' },
  ];

  const handleSave = () => {
    setSaving(true);
    setTimeout(() => {
      setSaving(false);
      alert('설정이 저장되었습니다.');
    }, 1000);
  };

  const currentConfig = configs.find(c => c.category === activeCategory);

  return (
    <div className="p-6 bg-gray-900 min-h-screen text-white">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold">⚙️ 시스템 설정</h1>
        <button 
          onClick={handleSave}
          disabled={saving}
          className={`px-6 py-2 rounded-lg font-semibold ${saving ? 'bg-gray-600' : 'bg-cyan-600 hover:bg-cyan-700'}`}
        >
          {saving ? '저장 중...' : '설정 저장'}
        </button>
      </div>

      <div className="flex gap-6">
        {/* 카테고리 사이드바 */}
        <div className="w-48 space-y-2">
          {categories.map((cat) => (
            <button
              key={cat.id}
              onClick={() => setActiveCategory(cat.id)}
              className={`w-full px-4 py-3 rounded-lg text-left flex items-center gap-2 ${
                activeCategory === cat.id ? 'bg-cyan-600' : 'bg-gray-800 hover:bg-gray-700'
              }`}
            >
              <span>{cat.icon}</span>
              <span>{cat.name}</span>
            </button>
          ))}
        </div>

        {/* 설정 폼 */}
        <div className="flex-1 bg-gray-800 rounded-lg p-6">
          <h2 className="text-xl font-bold mb-6">
            {categories.find(c => c.id === activeCategory)?.icon}{' '}
            {categories.find(c => c.id === activeCategory)?.name} 설정
          </h2>
          
          <div className="space-y-6">
            {currentConfig?.items.map((item) => (
              <div key={item.key} className="border-b border-gray-700 pb-4">
                <div className="flex justify-between items-start mb-2">
                  <div>
                    <label className="font-medium">{item.name}</label>
                    <p className="text-sm text-gray-400">{item.description}</p>
                  </div>
                  <div className="w-64">
                    {item.type === 'boolean' ? (
                      <label className="flex items-center cursor-pointer">
                        <input
                          type="checkbox"
                          defaultChecked={item.value as boolean}
                          className="sr-only peer"
                        />
                        <div className="relative w-11 h-6 bg-gray-600 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-cyan-600"></div>
                        <span className="ml-3 text-sm">{item.value ? '활성' : '비활성'}</span>
                      </label>
                    ) : item.type === 'select' ? (
                      <select
                        defaultValue={item.value as string}
                        className="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-lg focus:ring-2 focus:ring-cyan-500"
                      >
                        {item.options?.map((opt) => (
                          <option key={opt} value={opt}>{opt}</option>
                        ))}
                      </select>
                    ) : item.type === 'number' ? (
                      <input
                        type="number"
                        defaultValue={item.value as number}
                        className="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-lg focus:ring-2 focus:ring-cyan-500"
                      />
                    ) : (
                      <input
                        type="text"
                        defaultValue={item.value as string}
                        className="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-lg focus:ring-2 focus:ring-cyan-500"
                      />
                    )}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* 시스템 정보 */}
      <div className="mt-6 bg-gray-800 rounded-lg p-6">
        <h3 className="text-lg font-bold mb-4">📊 시스템 정보</h3>
        <div className="grid grid-cols-4 gap-4 text-sm">
          <div className="bg-gray-700 p-3 rounded">
            <div className="text-gray-400">시스템 버전</div>
            <div className="font-mono">v1.0.0</div>
          </div>
          <div className="bg-gray-700 p-3 rounded">
            <div className="text-gray-400">백엔드 상태</div>
            <div className="text-green-400">● 정상</div>
          </div>
          <div className="bg-gray-700 p-3 rounded">
            <div className="text-gray-400">데이터베이스</div>
            <div className="text-green-400">● 연결됨</div>
          </div>
          <div className="bg-gray-700 p-3 rounded">
            <div className="text-gray-400">마지막 백업</div>
            <div className="font-mono">2026-01-05 03:00</div>
          </div>
        </div>
      </div>
    </div>
  );
}
