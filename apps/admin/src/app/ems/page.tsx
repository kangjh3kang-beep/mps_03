import React, { useState } from 'react';
import {
    Globe, Users, Activity, AlertTriangle, ShieldCheck, Zap,
    LayoutDashboard, Map, Database, Settings, Menu, X
} from 'lucide-react';

const GlobalDashboard = () => {
    const [activeMenu, setActiveMenu] = useState('dashboard');
    const [isSidebarOpen, setIsSidebarOpen] = useState(true);

    const stats = [
        { label: '활성 국가', value: '124', icon: <Globe className="text-cyan-400" /> },
        { label: '전체 사용자', value: '1,240,582', icon: <Users className="text-purple-400" /> },
        { label: '실시간 측정 건수', value: '45,201', icon: <Activity className="text-green-400" /> },
        { label: '시스템 경고', value: '3', icon: <AlertTriangle className="text-amber-400" /> },
    ];

    const menuItems = [
        { id: 'dashboard', label: '글로벌 대시보드', icon: <LayoutDashboard size={20} /> },
        { id: 'regions', label: '지역/그룹 관리', icon: <Map size={20} /> },
        { id: 'ai-monitor', label: 'AI & 시스템 모니터링', icon: <Activity size={20} /> },
        { id: 'research', label: '연구 데이터 허브', icon: <Database size={20} /> },
        { id: 'settings', label: '시스템 설정', icon: <Settings size={20} /> },
    ];

    return (
        <div className="flex min-h-screen bg-slate-950 text-white font-sans">
            {/* Sidebar Navigation */}
            <aside className={`${isSidebarOpen ? 'w-64' : 'w-20'} bg-slate-900/50 border-r border-slate-800 transition-all duration-300 flex flex-col`}>
                <div className="p-6 flex items-center justify-between">
                    {isSidebarOpen && <span className="font-bold text-xl text-cyan-400">MPS EMS</span>}
                    <button onClick={() => setIsSidebarOpen(!isSidebarOpen)} className="p-2 hover:bg-slate-800 rounded-lg">
                        {isSidebarOpen ? <X size={20} /> : <Menu size={20} />}
                    </button>
                </div>

                <nav className="flex-1 px-4 space-y-2">
                    {menuItems.map((item) => (
                        <button
                            key={item.id}
                            onClick={() => setActiveMenu(item.id)}
                            className={`w-full flex items-center gap-4 p-3 rounded-xl transition-colors ${activeMenu === item.id ? 'bg-cyan-500/10 text-cyan-400 border border-cyan-500/20' : 'text-slate-400 hover:bg-slate-800'
                                }`}
                        >
                            {item.icon}
                            {isSidebarOpen && <span className="text-sm font-medium">{item.label}</span>}
                        </button>
                    ))}
                </nav>
            </aside>

            {/* Main Content */}
            <main className="flex-1 overflow-y-auto p-8">
                <header className="flex justify-between items-center mb-8">
                    <h1 className="text-3xl font-bold bg-gradient-to-r from-cyan-400 to-blue-500 bg-clip-text text-transparent">
                        {menuItems.find(m => m.id === activeMenu)?.label}
                    </h1>
                    <div className="flex gap-4">
                        <div className="flex items-center gap-2 px-4 py-2 bg-green-500/10 border border-green-500/20 rounded-full text-green-400 text-xs">
                            <ShieldCheck size={14} /> 보안 가동 중
                        </div>
                        <div className="flex items-center gap-2 px-4 py-2 bg-cyan-500/10 border border-cyan-500/20 rounded-full text-cyan-400 text-xs">
                            <Zap size={14} /> AI 자가치유 활성
                        </div>
                    </div>
                </header>

                {activeMenu === 'dashboard' && (
                    <>
                        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-12">
                            {stats.map((stat, i) => (
                                <div key={i} className="bg-slate-900/50 border border-slate-800 p-6 rounded-2xl backdrop-blur-xl hover:border-cyan-500/50 transition-colors">
                                    <div className="flex justify-between items-center mb-4">
                                        <span className="text-slate-400 text-sm">{stat.label}</span>
                                        {stat.icon}
                                    </div>
                                    <div className="text-2xl font-bold">{stat.value}</div>
                                </div>
                            ))}
                        </div>

                        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                            <div className="lg:col-span-2 bg-slate-900/50 border border-slate-800 p-8 rounded-3xl">
                                <h2 className="text-xl font-semibold mb-6">글로벌 활성도 및 데이터 트렌드</h2>
                                <div className="h-80 bg-slate-800/30 rounded-xl flex items-center justify-center relative overflow-hidden">
                                    <div className="absolute inset-0 opacity-20 bg-[url('https://www.transparenttextures.com/patterns/world-map.png')] bg-center bg-no-repeat"></div>
                                    <div className="z-10 text-slate-500 text-sm">실시간 데이터 패킷 전송 중...</div>
                                </div>
                            </div>

                            <div className="bg-slate-900/50 border border-slate-800 p-8 rounded-3xl">
                                <h2 className="text-xl font-semibold mb-6 flex items-center gap-2">
                                    <Activity className="text-green-400 size-5" /> AI 자가치유 로그
                                </h2>
                                <div className="space-y-4">
                                    {[
                                        { time: '13:45', action: 'DB 커넥션 풀 재시작', status: 'Resolved', color: 'text-green-400' },
                                        { time: '13:12', action: 'API 레이턴시 최적화', status: 'Optimized', color: 'text-blue-400' },
                                        { time: '12:05', action: '비정상 접근 차단', status: 'Blocked', color: 'text-red-400' },
                                    ].map((log, i) => (
                                        <div key={i} className="border-l-2 border-slate-700 pl-4 py-2">
                                            <div className="flex justify-between text-xs mb-1">
                                                <span className="text-slate-500">{log.time}</span>
                                                <span className={log.color}>{log.status}</span>
                                            </div>
                                            <div className="text-sm font-medium">{log.action}</div>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        </div>
                    </>
                )}

                {activeMenu === 'research' && (
                    <div className="space-y-8">
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div className="bg-slate-900/50 border border-slate-800 p-6 rounded-2xl">
                                <div className="text-slate-400 text-sm mb-2">총 연구 데이터셋</div>
                                <div className="text-3xl font-bold">1,420</div>
                            </div>
                            <div className="bg-slate-900/50 border border-slate-800 p-6 rounded-2xl">
                                <div className="text-slate-400 text-sm mb-2">참여 연구 기관</div>
                                <div className="text-3xl font-bold">85</div>
                            </div>
                            <div className="bg-slate-900/50 border border-slate-800 p-6 rounded-2xl">
                                <div className="text-slate-400 text-sm mb-2">데이터 무결성 점수</div>
                                <div className="text-3xl font-bold text-green-400">99.9%</div>
                            </div>
                        </div>

                        <div className="bg-slate-900/50 border border-slate-800 p-8 rounded-3xl">
                            <h2 className="text-xl font-semibold mb-6">최근 업로드된 외부 임상 데이터</h2>
                            <table className="w-full text-left">
                                <thead>
                                    <tr className="text-slate-500 border-b border-slate-800">
                                        <th className="pb-4">기관명</th>
                                        <th className="pb-4">연구 주제</th>
                                        <th className="pb-4">샘플 수</th>
                                        <th className="pb-4">상태</th>
                                        <th className="pb-4">해시 검증</th>
                                    </tr>
                                </thead>
                                <tbody className="text-sm">
                                    {[
                                        { org: 'Stanford Med', topic: 'Type 2 Diabetes Pattern', samples: '5,000', status: 'Analyzed', hash: 'Verified' },
                                        { org: 'Seoul Nat Univ', topic: 'EHD Gas Biomarkers', samples: '1,200', status: 'Processing', hash: 'Verified' },
                                        { org: 'Mayo Clinic', topic: 'Non-invasive Glucose', samples: '10,000', status: 'Queued', hash: 'Pending' },
                                    ].map((row, i) => (
                                        <tr key={i} className="border-b border-slate-800/50 hover:bg-slate-800/20">
                                            <td className="py-4 font-medium">{row.org}</td>
                                            <td className="py-4 text-slate-400">{row.topic}</td>
                                            <td className="py-4">{row.samples}</td>
                                            <td className="py-4">
                                                <span className={`px-2 py-1 rounded-full text-[10px] ${row.status === 'Analyzed' ? 'bg-green-500/10 text-green-400' : 'bg-amber-500/10 text-amber-400'
                                                    }`}>{row.status}</span>
                                            </td>
                                            <td className="py-4 text-cyan-400 text-xs font-mono">{row.hash}</td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    </div>
                )}

                {activeMenu !== 'dashboard' && activeMenu !== 'research' && (
                    <div className="h-96 bg-slate-900/50 border border-slate-800 rounded-3xl flex items-center justify-center text-slate-500">
                        {menuItems.find(m => m.id === activeMenu)?.label} 상세 페이지 준비 중...
                    </div>
                )}
            </main>
        </div>
    );
};

export default GlobalDashboard;
