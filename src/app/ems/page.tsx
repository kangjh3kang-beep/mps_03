import React, { useState, useEffect } from 'react';
import {
    Globe, Users, Activity, AlertTriangle, ShieldCheck, Zap,
    LayoutDashboard, Map, Database, Settings, Menu, X, RefreshCw
} from 'lucide-react';

const GlobalDashboard = () => {
    const [activeMenu, setActiveMenu] = useState('dashboard');
    const [isSidebarOpen, setIsSidebarOpen] = useState(true);
    const [isRefreshing, setIsRefreshing] = useState(false);
    const [liveStats, setLiveStats] = useState({
        countries: 124,
        users: 1240582,
        measurements: 45201,
        alerts: 3
    });

    // 실시간 데이터 업데이트 시뮬레이션
    useEffect(() => {
        const interval = setInterval(() => {
            setLiveStats(prev => ({
                ...prev,
                users: prev.users + Math.floor(Math.random() * 5),
                measurements: prev.measurements + Math.floor(Math.random() * 10),
                alerts: Math.random() > 0.95 ? prev.alerts + 1 : prev.alerts
            }));
        }, 3000);
        return () => clearInterval(interval);
    }, []);

    const stats = [
        { label: '활성 국가', value: liveStats.countries.toLocaleString(), icon: <Globe className="text-cyan-400" /> },
        { label: '전체 사용자', value: liveStats.users.toLocaleString(), icon: <Users className="text-purple-400" /> },
        { label: '실시간 측정 건수', value: liveStats.measurements.toLocaleString(), icon: <Activity className="text-green-400" /> },
        { label: '시스템 경고', value: liveStats.alerts, icon: <AlertTriangle className={liveStats.alerts > 5 ? "text-red-500 animate-pulse" : "text-amber-400"} /> },
    ];

    const menuItems = [
        { id: 'dashboard', label: '글로벌 대시보드', icon: <LayoutDashboard size={20} /> },
        { id: 'regions', label: '지역/그룹 관리', icon: <Map size={20} /> },
        { id: 'ai-monitor', label: 'AI & 시스템 모니터링', icon: <Activity size={20} /> },
        { id: 'research', label: '연구 데이터 허브', icon: <Database size={20} /> },
        { id: 'settings', label: '시스템 설정', icon: <Settings size={20} /> },
    ];

    const refreshData = () => {
        setIsRefreshing(true);
        setTimeout(() => setIsRefreshing(false), 1000);
    };

    return (
        <div className="flex min-h-screen bg-slate-950 text-white font-sans">
            {/* Sidebar Navigation */}
            <aside className={`${isSidebarOpen ? 'w-64' : 'w-20'} bg-slate-900/50 border-r border-slate-800 transition-all duration-300 flex flex-col sticky top-0 h-screen`}>
                <div className="p-6 flex items-center justify-between">
                    {isSidebarOpen && (
                        <div className="flex items-center gap-2">
                            <div className="w-8 h-8 bg-cyan-500 rounded-lg flex items-center justify-center shadow-[0_0_15px_rgba(6,182,212,0.5)]">
                                <ShieldCheck size={20} className="text-white" />
                            </div>
                            <span className="font-bold text-xl tracking-tighter text-cyan-400">MPS EMS</span>
                        </div>
                    )}
                    <button onClick={() => setIsSidebarOpen(!isSidebarOpen)} className="p-2 hover:bg-slate-800 rounded-lg transition-colors">
                        {isSidebarOpen ? <X size={20} /> : <Menu size={20} />}
                    </button>
                </div>

                <nav className="flex-1 px-4 space-y-2 mt-4">
                    {menuItems.map((item) => (
                        <button
                            key={item.id}
                            onClick={() => setActiveMenu(item.id)}
                            className={`w-full flex items-center gap-4 p-3 rounded-xl transition-all duration-200 ${activeMenu === item.id
                                ? 'bg-cyan-500/10 text-cyan-400 border border-cyan-500/20 shadow-[inset_0_0_10px_rgba(6,182,212,0.1)]'
                                : 'text-slate-400 hover:bg-slate-800/50 hover:text-slate-200'
                                }`}
                        >
                            {item.icon}
                            {isSidebarOpen && <span className="text-sm font-medium">{item.label}</span>}
                        </button>
                    ))}
                </nav>

                {isSidebarOpen && (
                    <div className="p-4 m-4 bg-slate-800/30 rounded-2xl border border-slate-700/50">
                        <div className="text-[10px] uppercase tracking-widest text-slate-500 mb-2 font-bold">System Status</div>
                        <div className="flex items-center gap-2 text-xs text-green-400">
                            <div className="w-1.5 h-1.5 bg-green-500 rounded-full animate-pulse"></div>
                            All Systems Operational
                        </div>
                    </div>
                )}
            </aside>

            {/* Main Content */}
            <main className="flex-1 overflow-y-auto p-8">
                <header className="flex justify-between items-center mb-10">
                    <div>
                        <h1 className="text-4xl font-black bg-gradient-to-r from-cyan-400 via-blue-500 to-purple-600 bg-clip-text text-transparent tracking-tight">
                            {menuItems.find(m => m.id === activeMenu)?.label}
                        </h1>
                        <p className="text-slate-500 text-sm mt-1">만파식 글로벌 생태계 통합 관리 시스템 v2.4.0</p>
                    </div>
                    <div className="flex gap-4 items-center">
                        <button
                            onClick={refreshData}
                            className={`p-2 rounded-full bg-slate-900 border border-slate-800 hover:border-cyan-500/50 transition-all ${isRefreshing ? 'animate-spin' : ''}`}
                        >
                            <RefreshCw size={18} className="text-slate-400" />
                        </button>
                        <div className="flex items-center gap-2 px-4 py-2 bg-green-500/10 border border-green-500/20 rounded-full text-green-400 text-xs font-bold">
                            <ShieldCheck size={14} /> 보안 가동 중
                        </div>
                        <div className="flex items-center gap-2 px-4 py-2 bg-cyan-500/10 border border-cyan-500/20 rounded-full text-cyan-400 text-xs font-bold">
                            <Zap size={14} /> AI 자가치유 활성
                        </div>
                    </div>
                </header>

                {activeMenu === 'dashboard' && (
                    <>
                        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-12">
                            {stats.map((stat, i) => (
                                <div key={i} className="group bg-slate-900/40 border border-slate-800/50 p-6 rounded-3xl backdrop-blur-2xl hover:border-cyan-500/40 transition-all duration-300 hover:translate-y-[-4px] shadow-xl">
                                    <div className="flex justify-between items-center mb-4">
                                        <span className="text-slate-500 text-xs font-bold uppercase tracking-wider">{stat.label}</span>
                                        <div className="p-2 bg-slate-800/50 rounded-xl group-hover:bg-cyan-500/10 transition-colors">
                                            {stat.icon}
                                        </div>
                                    </div>
                                    <div className="text-3xl font-black tracking-tight">{stat.value}</div>
                                    <div className="mt-2 flex items-center gap-1 text-[10px] text-green-400 font-bold">
                                        <Activity size={10} /> +2.4% vs last hour
                                    </div>
                                </div>
                            ))}
                        </div>

                        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                            <div className="lg:col-span-2 bg-slate-900/40 border border-slate-800/50 p-8 rounded-[2.5rem] backdrop-blur-2xl shadow-2xl">
                                <div className="flex justify-between items-center mb-8">
                                    <h2 className="text-xl font-bold flex items-center gap-2">
                                        <Globe className="text-cyan-400" size={20} /> 글로벌 활성도 및 데이터 트렌드
                                    </h2>
                                    <div className="flex gap-2">
                                        <span className="px-3 py-1 bg-slate-800 rounded-lg text-[10px] font-bold text-slate-400">LIVE</span>
                                    </div>
                                </div>
                                <div className="h-80 bg-slate-950/50 rounded-3xl border border-slate-800/50 flex items-center justify-center relative overflow-hidden group">
                                    <div className="absolute inset-0 opacity-10 bg-[url('https://www.transparenttextures.com/patterns/carbon-fibre.png')]"></div>
                                    <div className="absolute inset-0 bg-gradient-to-t from-cyan-500/5 to-transparent"></div>
                                    <div className="z-10 flex flex-col items-center gap-4">
                                        <div className="w-16 h-16 border-4 border-cyan-500/20 border-t-cyan-500 rounded-full animate-spin"></div>
                                        <div className="text-cyan-400/70 text-xs font-mono tracking-widest animate-pulse">MPS-GLOBAL-MESH-SYNCING...</div>
                                    </div>
                                    {/* Simulated data points */}
                                    <div className="absolute top-1/4 left-1/3 w-2 h-2 bg-cyan-400 rounded-full shadow-[0_0_10px_#22d3ee] animate-ping"></div>
                                    <div className="absolute bottom-1/3 right-1/4 w-2 h-2 bg-purple-500 rounded-full shadow-[0_0_10px_#a855f7] animate-ping" style={{ animationDelay: '1s' }}></div>
                                </div>
                            </div>

                            <div className="bg-slate-900/40 border border-slate-800/50 p-8 rounded-[2.5rem] backdrop-blur-2xl shadow-2xl">
                                <h2 className="text-xl font-bold mb-8 flex items-center gap-2">
                                    <Zap className="text-amber-400 size-5" /> AI 자가치유 엔진
                                </h2>
                                <div className="space-y-6">
                                    {[
                                        { time: '13:45', action: 'DB 커넥션 풀 재시작', status: 'Resolved', color: 'text-green-400', bg: 'bg-green-400/10' },
                                        { time: '13:12', action: 'API 레이턴시 최적화', status: 'Optimized', color: 'text-cyan-400', bg: 'bg-cyan-400/10' },
                                        { time: '12:05', action: '비정상 접근 차단', status: 'Blocked', color: 'text-red-400', bg: 'bg-red-400/10' },
                                        { time: '11:20', action: '메모리 누수 자동 복구', status: 'Resolved', color: 'text-green-400', bg: 'bg-green-400/10' },
                                    ].map((log, i) => (
                                        <div key={i} className="relative pl-6 border-l border-slate-800">
                                            <div className="absolute -left-[5px] top-0 w-2.5 h-2.5 bg-slate-800 rounded-full border border-slate-700"></div>
                                            <div className="flex justify-between text-[10px] mb-1 font-bold">
                                                <span className="text-slate-500">{log.time}</span>
                                                <span className={`${log.color} ${log.bg} px-2 py-0.5 rounded-md`}>{log.status}</span>
                                            </div>
                                            <div className="text-sm font-bold text-slate-300">{log.action}</div>
                                        </div>
                                    ))}
                                </div>
                                <button className="w-full mt-8 py-3 bg-slate-800/50 hover:bg-slate-800 rounded-2xl text-xs font-bold text-slate-400 transition-colors border border-slate-700/50">
                                    전체 로그 보기
                                </button>
                            </div>
                        </div>
                    </>
                )}

                {activeMenu === 'research' && (
                    <div className="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                            {[
                                { label: '총 연구 데이터셋', value: '1,420', color: 'text-white' },
                                { label: '참여 연구 기관', value: '85', color: 'text-white' },
                                { label: '데이터 무결성 점수', value: '99.9%', color: 'text-green-400' },
                            ].map((item, i) => (
                                <div key={i} className="bg-slate-900/40 border border-slate-800/50 p-8 rounded-3xl backdrop-blur-2xl">
                                    <div className="text-slate-500 text-xs font-bold uppercase tracking-widest mb-2">{item.label}</div>
                                    <div className={`text-4xl font-black ${item.color}`}>{item.value}</div>
                                </div>
                            ))}
                        </div>

                        <div className="bg-slate-900/40 border border-slate-800/50 p-10 rounded-[2.5rem] backdrop-blur-2xl shadow-2xl">
                            <div className="flex justify-between items-center mb-10">
                                <h2 className="text-2xl font-black tracking-tight flex items-center gap-3">
                                    <Database className="text-cyan-400" /> 최근 업로드된 외부 임상 데이터
                                </h2>
                                <button className="text-cyan-400 text-xs font-bold hover:underline">데이터 업로드 가이드</button>
                            </div>
                            <div className="overflow-x-auto">
                                <table className="w-full text-left border-collapse">
                                    <thead>
                                        <tr className="text-slate-500 border-b border-slate-800/50 text-[10px] uppercase tracking-widest font-black">
                                            <th className="pb-6 pl-4">기관명</th>
                                            <th className="pb-6">연구 주제</th>
                                            <th className="pb-6">샘플 수</th>
                                            <th className="pb-6">상태</th>
                                            <th className="pb-6 pr-4">해시 검증</th>
                                        </tr>
                                    </thead>
                                    <tbody className="text-sm">
                                        {[
                                            { org: 'Stanford Med', topic: 'Type 2 Diabetes Pattern', samples: '5,000', status: 'Analyzed', hash: 'Verified' },
                                            { org: 'Seoul Nat Univ', topic: 'EHD Gas Biomarkers', samples: '1,200', status: 'Processing', hash: 'Verified' },
                                            { org: 'Mayo Clinic', topic: 'Non-invasive Glucose', samples: '10,000', status: 'Queued', hash: 'Pending' },
                                            { org: 'Oxford Health', topic: 'Cardiovascular Risk AI', samples: '25,000', status: 'Analyzed', hash: 'Verified' },
                                        ].map((row, i) => (
                                            <tr key={i} className="group border-b border-slate-800/30 hover:bg-cyan-500/5 transition-all duration-200">
                                                <td className="py-6 pl-4 font-bold text-slate-200">{row.org}</td>
                                                <td className="py-6 text-slate-400 font-medium">{row.topic}</td>
                                                <td className="py-6 font-mono text-slate-300">{row.samples}</td>
                                                <td className="py-6">
                                                    <span className={`px-3 py-1 rounded-lg text-[10px] font-black tracking-tighter ${row.status === 'Analyzed' ? 'bg-green-500/10 text-green-400' :
                                                            row.status === 'Processing' ? 'bg-cyan-500/10 text-cyan-400' : 'bg-amber-500/10 text-amber-400'
                                                        }`}>{row.status}</span>
                                                </td>
                                                <td className="py-6 pr-4 text-cyan-400 text-[10px] font-black font-mono tracking-widest">{row.hash}</td>
                                            </tr>
                                        ))}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                )}

                {activeMenu !== 'dashboard' && activeMenu !== 'research' && (
                    <div className="h-[60vh] bg-slate-900/40 border border-slate-800/50 rounded-[3rem] flex flex-col items-center justify-center text-slate-500 gap-4">
                        <div className="w-20 h-20 bg-slate-800/50 rounded-full flex items-center justify-center">
                            <Settings size={40} className="animate-spin-slow" />
                        </div>
                        <div className="text-xl font-bold text-slate-400">{menuItems.find(m => m.id === activeMenu)?.label}</div>
                        <p className="text-sm">해당 모듈은 현재 글로벌 보안 프로토콜 업데이트 중입니다.</p>
                    </div>
                )}
            </main>
        </div>
    );
};

export default GlobalDashboard;
