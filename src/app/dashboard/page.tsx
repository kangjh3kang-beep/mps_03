'use client';

import React from 'react';
import Navbar from '@/components/Navbar';
import Sidebar from '@/components/Sidebar';
import { Activity, FileText, Palette, TrendingUp, Shield, Zap } from 'lucide-react';

export default function DashboardPage() {
    return (
        <div className="min-h-screen bg-[#050a14] text-white">
            <Navbar />
            <div className="flex pt-20">
                <Sidebar />

                <main className="flex-1 p-8">
                    <header className="mb-10">
                        <h1 className="text-4xl font-black tracking-tight bg-gradient-to-r from-white to-slate-500 bg-clip-text text-transparent">
                            Enterprise Overview
                        </h1>
                        <p className="text-slate-500 mt-2">만파식 엔터프라이즈 생태계 통합 관리 보드</p>
                    </header>

                    {/* Widget Grid */}
                    <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">

                        {/* Bio Status Widget */}
                        <div className="glass p-8 border-cyan-500/20 hover:border-cyan-500/40 transition-all">
                            <div className="flex justify-between items-center mb-6">
                                <h2 className="text-xl font-bold flex items-center gap-2">
                                    <Activity className="text-cyan-400" size={20} /> Bio Status
                                </h2>
                                <span className="px-2 py-1 bg-cyan-500/10 text-cyan-400 text-[10px] font-black rounded">LIVE</span>
                            </div>
                            <div className="space-y-4">
                                <div className="flex justify-between items-end">
                                    <span className="text-slate-400 text-sm">최근 측정 지수</span>
                                    <span className="text-3xl font-black">98.4 <small className="text-xs font-normal text-slate-500">mg/dL</small></span>
                                </div>
                                <div className="h-2 bg-slate-800 rounded-full overflow-hidden">
                                    <div className="h-full bg-cyan-500 w-[75%] shadow-[0_0_10px_#06b6d4]"></div>
                                </div>
                                <p className="text-xs text-slate-500">안정적인 생체 신호가 감지되고 있습니다.</p>
                            </div>
                        </div>

                        {/* Patent Jobs Widget */}
                        <div className="glass p-8 border-purple-500/20 hover:border-purple-500/40 transition-all">
                            <div className="flex justify-between items-center mb-6">
                                <h2 className="text-xl font-bold flex items-center gap-2">
                                    <FileText className="text-purple-400" size={20} /> Patent Jobs
                                </h2>
                                <span className="px-2 py-1 bg-purple-500/10 text-purple-400 text-[10px] font-black rounded">3 ACTIVE</span>
                            </div>
                            <div className="space-y-3">
                                <PatentItem title="EHD Gas Sensor Algorithm" status="Analyzing" progress={65} />
                                <PatentItem title="Self-Healing Mesh Network" status="Drafting" progress={30} />
                                <PatentItem title="Bio-Signal Encryption" status="Review" progress={90} />
                            </div>
                        </div>

                        {/* Opal Projects Widget */}
                        <div className="glass p-8 border-amber-500/20 hover:border-amber-500/40 transition-all">
                            <div className="flex justify-between items-center mb-6">
                                <h2 className="text-xl font-bold flex items-center gap-2">
                                    <Palette className="text-amber-400" size={20} /> Opal Projects
                                </h2>
                                <span className="px-2 py-1 bg-amber-500/10 text-amber-400 text-[10px] font-black rounded">NEW FEED</span>
                            </div>
                            <div className="grid grid-cols-2 gap-4">
                                <div className="aspect-square bg-slate-800/50 rounded-xl border border-white/5 flex items-center justify-center">
                                    <Zap size={24} className="text-slate-600" />
                                </div>
                                <div className="aspect-square bg-slate-800/50 rounded-xl border border-white/5 flex items-center justify-center">
                                    <Shield size={24} className="text-slate-600" />
                                </div>
                            </div>
                            <button className="w-full mt-6 py-3 bg-amber-500/10 text-amber-400 text-xs font-bold rounded-xl border border-amber-500/20 hover:bg-amber-500/20 transition-all">
                                스튜디오 입장
                            </button>
                        </div>

                    </div>

                    {/* Secondary Row */}
                    <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mt-8">
                        <div className="glass p-8 border-white/5">
                            <h3 className="text-lg font-bold mb-6 flex items-center gap-2">
                                <TrendingUp className="text-green-400" size={18} /> Global Health Trend
                            </h3>
                            <div className="h-48 bg-slate-950/50 rounded-2xl border border-white/5 flex items-center justify-center">
                                <span className="text-slate-600 text-xs font-mono">TREND_VISUALIZATION_READY</span>
                            </div>
                        </div>
                        <div className="glass p-8 border-white/5">
                            <h3 className="text-lg font-bold mb-6 flex items-center gap-2">
                                <Shield className="text-blue-400" size={18} /> Security Audit Trail
                            </h3>
                            <div className="space-y-4">
                                <AuditLog time="17:24" action="Auth Key Rotation" status="Success" />
                                <AuditLog time="16:12" action="External Data Sync" status="Verified" />
                                <AuditLog time="15:05" action="System Self-Healing" status="Resolved" />
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
    );
}

function PatentItem({ title, status, progress }: any) {
    return (
        <div className="space-y-1">
            <div className="flex justify-between text-[10px] font-bold uppercase tracking-widest">
                <span className="text-slate-400">{title}</span>
                <span className="text-purple-400">{status}</span>
            </div>
            <div className="h-1.5 bg-slate-800 rounded-full overflow-hidden">
                <div className="h-full bg-purple-500" style={{ width: `${progress}%` }}></div>
            </div>
        </div>
    );
}

function AuditLog({ time, action, status }: any) {
    return (
        <div className="flex justify-between items-center text-xs border-b border-white/5 pb-2">
            <span className="text-slate-500 font-mono">{time}</span>
            <span className="font-medium">{action}</span>
            <span className="text-blue-400 font-bold">{status}</span>
        </div>
    );
}
