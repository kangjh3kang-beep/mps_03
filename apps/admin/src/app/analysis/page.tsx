'use client';

import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, AreaChart, Area } from 'recharts';

const healthData = [
    { name: '1월', score: 65, env: 40 },
    { name: '2월', score: 68, env: 45 },
    { name: '3월', score: 75, env: 55 },
    { name: '4월', score: 72, env: 50 },
    { name: '5월', score: 80, env: 65 },
    { name: '6월', score: 85, env: 70 },
];

const correlationData = [
    { name: 'Day 1', stress: 40, noise: 30 },
    { name: 'Day 2', stress: 55, noise: 45 },
    { name: 'Day 3', stress: 45, noise: 35 },
    { name: 'Day 4', stress: 70, noise: 60 },
    { name: 'Day 5', stress: 60, noise: 50 },
    { name: 'Day 6', stress: 75, noise: 65 },
    { name: 'Day 7', stress: 65, noise: 55 },
];

export default function AnalysisPage() {
    return (
        <div className="p-6 h-full flex flex-col gap-6 overflow-y-auto">
            <div className="flex justify-between items-center">
                <div>
                    <h1 className="text-3xl font-bold text-primary neon-text-cyan">전문가 분석 도구</h1>
                    <p className="text-muted-foreground">사용자 건강 데이터와 환경 요인 간의 심층 분석</p>
                </div>
                <button className="px-4 py-2 bg-primary text-black font-bold rounded-lg hover:bg-primary/80 transition">
                    리포트 다운로드
                </button>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                {/* Health Trend Chart */}
                <div className="glass-card p-6 rounded-xl border border-white/10">
                    <h3 className="text-xl font-bold mb-4 text-white">건강 점수 vs 환경 지수 트렌드</h3>
                    <div className="h-[300px] w-full">
                        <ResponsiveContainer width="100%" height="100%">
                            <AreaChart data={healthData}>
                                <defs>
                                    <linearGradient id="colorScore" x1="0" y1="0" x2="0" y2="1">
                                        <stop offset="5%" stopColor="#00E5FF" stopOpacity={0.8} />
                                        <stop offset="95%" stopColor="#00E5FF" stopOpacity={0} />
                                    </linearGradient>
                                    <linearGradient id="colorEnv" x1="0" y1="0" x2="0" y2="1">
                                        <stop offset="5%" stopColor="#FFD600" stopOpacity={0.8} />
                                        <stop offset="95%" stopColor="#FFD600" stopOpacity={0} />
                                    </linearGradient>
                                </defs>
                                <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
                                <XAxis dataKey="name" stroke="#A0A0A0" />
                                <YAxis stroke="#A0A0A0" />
                                <Tooltip
                                    contentStyle={{ backgroundColor: '#0A0A0A', border: '1px solid rgba(255,255,255,0.1)' }}
                                    itemStyle={{ color: '#fff' }}
                                />
                                <Legend />
                                <Area type="monotone" dataKey="score" stroke="#00E5FF" fillOpacity={1} fill="url(#colorScore)" name="건강 점수" />
                                <Area type="monotone" dataKey="env" stroke="#FFD600" fillOpacity={1} fill="url(#colorEnv)" name="환경 지수" />
                            </AreaChart>
                        </ResponsiveContainer>
                    </div>
                </div>

                {/* Correlation Chart */}
                <div className="glass-card p-6 rounded-xl border border-white/10">
                    <h3 className="text-xl font-bold mb-4 text-white">스트레스 - 소음 상관관계 분석</h3>
                    <div className="h-[300px] w-full">
                        <ResponsiveContainer width="100%" height="100%">
                            <LineChart data={correlationData}>
                                <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
                                <XAxis dataKey="name" stroke="#A0A0A0" />
                                <YAxis stroke="#A0A0A0" />
                                <Tooltip
                                    contentStyle={{ backgroundColor: '#0A0A0A', border: '1px solid rgba(255,255,255,0.1)' }}
                                    itemStyle={{ color: '#fff' }}
                                />
                                <Legend />
                                <Line type="monotone" dataKey="stress" stroke="#FF4444" strokeWidth={2} dot={{ r: 4 }} name="스트레스 지수" />
                                <Line type="monotone" dataKey="noise" stroke="#AAAAAA" strokeWidth={2} dot={{ r: 4 }} name="소음 레벨 (dB)" />
                            </LineChart>
                        </ResponsiveContainer>
                    </div>
                </div>
            </div>

            {/* Detailed Analysis Table */}
            <div className="glass-card p-6 rounded-xl border border-white/10">
                <h3 className="text-xl font-bold mb-4 text-white">상세 분석 데이터</h3>
                <div className="overflow-x-auto">
                    <table className="w-full text-left text-sm text-gray-400">
                        <thead className="text-xs uppercase bg-white/5 text-gray-200">
                            <tr>
                                <th className="px-6 py-3">날짜</th>
                                <th className="px-6 py-3">사용자 ID</th>
                                <th className="px-6 py-3">측정 항목</th>
                                <th className="px-6 py-3">결과값</th>
                                <th className="px-6 py-3">분석 결과</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr className="border-b border-white/5 hover:bg-white/5">
                                <td className="px-6 py-4">2026-01-02</td>
                                <td className="px-6 py-4">user_001</td>
                                <td className="px-6 py-4">코르티솔</td>
                                <td className="px-6 py-4">12.5 ug/dL</td>
                                <td className="px-6 py-4 text-green-400">정상</td>
                            </tr>
                            <tr className="border-b border-white/5 hover:bg-white/5">
                                <td className="px-6 py-4">2026-01-02</td>
                                <td className="px-6 py-4">user_002</td>
                                <td className="px-6 py-4">중금속(납)</td>
                                <td className="px-6 py-4">0.05 ppm</td>
                                <td className="px-6 py-4 text-yellow-400">주의</td>
                            </tr>
                            <tr className="border-b border-white/5 hover:bg-white/5">
                                <td className="px-6 py-4">2026-01-01</td>
                                <td className="px-6 py-4">user_003</td>
                                <td className="px-6 py-4">수질(pH)</td>
                                <td className="px-6 py-4">7.2</td>
                                <td className="px-6 py-4 text-green-400">정상</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
}
