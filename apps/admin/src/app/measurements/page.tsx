/**
 * 측정 데이터 관리 페이지
 * @path /measurements
 */

'use client';

import { useState, useEffect } from 'react';

interface Measurement {
  id: string;
  userId: string;
  userName: string;
  type: 'blood_glucose' | 'blood_pressure' | 'heart_rate' | 'oxygen_level';
  value: string | number;
  unit: string;
  timestamp: string;
  source: string;
  verified: boolean;
  quality: number;
}

const typeLabels: Record<string, { label: string; icon: string; color: string }> = {
  blood_glucose: { label: '혈당', icon: '🩸', color: 'text-red-400' },
  blood_pressure: { label: '혈압', icon: '💗', color: 'text-pink-400' },
  heart_rate: { label: '심박수', icon: '💚', color: 'text-green-400' },
  oxygen_level: { label: '산소포화도', icon: '🫁', color: 'text-blue-400' },
};

export default function MeasurementsPage() {
  const [measurements, setMeasurements] = useState<Measurement[]>([]);
  const [loading, setLoading] = useState(true);
  const [typeFilter, setTypeFilter] = useState('all');
  const [dateRange, setDateRange] = useState({ start: '', end: '' });
  const [showDetails, setShowDetails] = useState<string | null>(null);

  useEffect(() => {
    const sampleData: Measurement[] = [
      { id: '1', userId: 'u1', userName: '김건강', type: 'blood_glucose', value: 98, unit: 'mg/dL', timestamp: '2026-01-05 09:30', source: 'device', verified: true, quality: 95 },
      { id: '2', userId: 'u1', userName: '김건강', type: 'blood_pressure', value: '120/80', unit: 'mmHg', timestamp: '2026-01-05 09:30', source: 'device', verified: true, quality: 92 },
      { id: '3', userId: 'u2', userName: '이운동', type: 'heart_rate', value: 72, unit: 'bpm', timestamp: '2026-01-05 08:15', source: 'device', verified: true, quality: 98 },
      { id: '4', userId: 'u2', userName: '이운동', type: 'oxygen_level', value: 98, unit: '%', timestamp: '2026-01-05 08:15', source: 'device', verified: true, quality: 97 },
      { id: '5', userId: 'u3', userName: '박의사', type: 'blood_glucose', value: 145, unit: 'mg/dL', timestamp: '2026-01-04 14:20', source: 'manual', verified: false, quality: 85 },
      { id: '6', userId: 'u1', userName: '김건강', type: 'blood_glucose', value: 102, unit: 'mg/dL', timestamp: '2026-01-04 09:00', source: 'device', verified: true, quality: 94 },
      { id: '7', userId: 'u4', userName: '최건강', type: 'blood_pressure', value: '135/88', unit: 'mmHg', timestamp: '2026-01-04 07:30', source: 'device', verified: true, quality: 90 },
      { id: '8', userId: 'u1', userName: '김건강', type: 'heart_rate', value: 85, unit: 'bpm', timestamp: '2026-01-03 22:00', source: 'device', verified: true, quality: 96 },
    ];
    setMeasurements(sampleData);
    setLoading(false);
  }, []);

  const filteredMeasurements = measurements.filter(m => {
    if (typeFilter !== 'all' && m.type !== typeFilter) return false;
    return true;
  });

  const stats = {
    total: measurements.length,
    today: measurements.filter(m => m.timestamp.startsWith('2026-01-05')).length,
    verified: measurements.filter(m => m.verified).length,
    avgQuality: Math.round(measurements.reduce((sum, m) => sum + m.quality, 0) / measurements.length),
  };

  return (
    <div className="p-6 bg-gray-900 min-h-screen text-white">
      <h1 className="text-3xl font-bold mb-6">📊 측정 데이터 관리</h1>

      {/* 통계 카드 */}
      <div className="grid grid-cols-4 gap-4 mb-6">
        <div className="bg-gradient-to-r from-cyan-800 to-cyan-600 p-4 rounded-lg">
          <div className="text-3xl font-bold">{stats.total}</div>
          <div className="text-cyan-200">전체 측정</div>
        </div>
        <div className="bg-gradient-to-r from-green-800 to-green-600 p-4 rounded-lg">
          <div className="text-3xl font-bold">{stats.today}</div>
          <div className="text-green-200">오늘 측정</div>
        </div>
        <div className="bg-gradient-to-r from-purple-800 to-purple-600 p-4 rounded-lg">
          <div className="text-3xl font-bold">{stats.verified}</div>
          <div className="text-purple-200">검증 완료</div>
        </div>
        <div className="bg-gradient-to-r from-amber-800 to-amber-600 p-4 rounded-lg">
          <div className="text-3xl font-bold">{stats.avgQuality}%</div>
          <div className="text-amber-200">평균 품질</div>
        </div>
      </div>

      {/* 필터 */}
      <div className="flex gap-4 mb-6">
        <select
          className="px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg"
          value={typeFilter}
          onChange={(e) => setTypeFilter(e.target.value)}
        >
          <option value="all">모든 유형</option>
          <option value="blood_glucose">혈당</option>
          <option value="blood_pressure">혈압</option>
          <option value="heart_rate">심박수</option>
          <option value="oxygen_level">산소포화도</option>
        </select>
        <input
          type="date"
          className="px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg"
          value={dateRange.start}
          onChange={(e) => setDateRange({ ...dateRange, start: e.target.value })}
        />
        <input
          type="date"
          className="px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg"
          value={dateRange.end}
          onChange={(e) => setDateRange({ ...dateRange, end: e.target.value })}
        />
        <button className="px-4 py-2 bg-cyan-600 hover:bg-cyan-700 rounded-lg">
          내보내기
        </button>
      </div>

      {/* 데이터 테이블 */}
      <div className="bg-gray-800 rounded-lg overflow-hidden">
        <table className="w-full">
          <thead className="bg-gray-700">
            <tr>
              <th className="px-4 py-3 text-left">유형</th>
              <th className="px-4 py-3 text-left">사용자</th>
              <th className="px-4 py-3 text-left">측정값</th>
              <th className="px-4 py-3 text-left">시간</th>
              <th className="px-4 py-3 text-left">소스</th>
              <th className="px-4 py-3 text-left">품질</th>
              <th className="px-4 py-3 text-left">상태</th>
              <th className="px-4 py-3 text-center">작업</th>
            </tr>
          </thead>
          <tbody>
            {filteredMeasurements.map((m) => (
              <tr key={m.id} className="border-t border-gray-700 hover:bg-gray-750">
                <td className="px-4 py-3">
                  <span className={typeLabels[m.type]?.color || 'text-gray-400'}>
                    {typeLabels[m.type]?.icon} {typeLabels[m.type]?.label}
                  </span>
                </td>
                <td className="px-4 py-3">{m.userName}</td>
                <td className="px-4 py-3 font-mono text-lg">
                  {m.value} <span className="text-gray-400 text-sm">{m.unit}</span>
                </td>
                <td className="px-4 py-3 text-gray-400">{m.timestamp}</td>
                <td className="px-4 py-3">
                  <span className={`px-2 py-1 rounded text-xs ${m.source === 'device' ? 'bg-blue-600' : 'bg-gray-600'}`}>
                    {m.source === 'device' ? '기기' : '수동'}
                  </span>
                </td>
                <td className="px-4 py-3">
                  <div className="flex items-center gap-2">
                    <div className="w-16 h-2 bg-gray-700 rounded-full overflow-hidden">
                      <div 
                        className={`h-full rounded-full ${m.quality >= 90 ? 'bg-green-500' : m.quality >= 70 ? 'bg-yellow-500' : 'bg-red-500'}`}
                        style={{ width: `${m.quality}%` }}
                      />
                    </div>
                    <span className="text-sm">{m.quality}%</span>
                  </div>
                </td>
                <td className="px-4 py-3">
                  <span className={`px-2 py-1 rounded text-xs ${m.verified ? 'bg-green-600' : 'bg-yellow-600'}`}>
                    {m.verified ? '검증됨' : '대기중'}
                  </span>
                </td>
                <td className="px-4 py-3 text-center">
                  <button 
                    onClick={() => setShowDetails(showDetails === m.id ? null : m.id)}
                    className="px-2 py-1 bg-gray-600 hover:bg-gray-500 rounded text-sm"
                  >
                    상세
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* 측정 유형별 차트 (간단한 표시) */}
      <div className="grid grid-cols-4 gap-4 mt-6">
        {Object.entries(typeLabels).map(([type, info]) => {
          const count = measurements.filter(m => m.type === type).length;
          return (
            <div key={type} className="bg-gray-800 p-4 rounded-lg">
              <div className="flex items-center justify-between mb-2">
                <span className={info.color}>{info.icon} {info.label}</span>
                <span className="text-2xl font-bold">{count}</span>
              </div>
              <div className="h-2 bg-gray-700 rounded-full overflow-hidden">
                <div 
                  className="h-full bg-cyan-500 rounded-full"
                  style={{ width: `${(count / measurements.length) * 100}%` }}
                />
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
