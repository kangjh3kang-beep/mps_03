'use client';

import Sidebar from '@/components/Sidebar';
import { Cpu, MessageSquare, Activity, Zap, ArrowUpRight } from 'lucide-react';

export default function DashboardPage() {
    return (
        <div className="flex min-h-screen bg-ink-950 text-ink-100 font-serif">
            <Sidebar />

            <main className="flex-1 p-8 overflow-y-auto">
                <header className="flex justify-between items-center mb-8">
                    <div>
                        <h2 className="text-4xl font-brush text-ink-100 mb-2">시스템 개요</h2>
                        <p className="text-ink-500 font-serif">만파식 생태계의 실시간 상태를 확인하세요.</p>
                    </div>
                    <div className="ink-card px-4 py-2 flex items-center gap-2 bg-ink-900/50">
                        <div className="w-2 h-2 rounded-full bg-green-500 shadow-[0_0_10px_#22c55e]" />
                        <span className="text-sm text-ink-300">서버 정상 작동 중</span>
                    </div>
                </header>

                <section className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
                    <InkStatusCard
                        title="연결된 기기"
                        value="12"
                        unit="Units"
                        icon={<Cpu className="text-accent-gold" />}
                        trend="+2 신규"
                    />
                    <InkStatusCard
                        title="실시간 로그"
                        value="1,284"
                        unit="Events/hr"
                        icon={<Activity className="text-accent-gold" />}
                        trend="안정적"
                    />
                    <InkStatusCard
                        title="시스템 부하"
                        value="24"
                        unit="%"
                        icon={<Zap className="text-accent-gold" />}
                        trend="최적화됨"
                    />
                </section>

                <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
                    {/* 기기 상태 요약 */}
                    <div className="ink-card p-6 bg-ink-900/30">
                        <h3 className="text-xl font-bold mb-6 flex items-center gap-2 text-ink-100">
                            <Cpu size={20} className="text-ink-400" /> 기기 상태 요약
                        </h3>
                        <div className="flex flex-col gap-4">
                            <DeviceItem name="MPS-Alpha-01" status="online" lastSeen="방금 전" />
                            <DeviceItem name="MPS-Beta-04" status="online" lastSeen="2분 전" />
                            <DeviceItem name="MPS-Gamma-09" status="offline" lastSeen="1시간 전" />
                        </div>
                    </div>

                    {/* 커뮤니티 최신 피드 */}
                    <div className="ink-card p-6 bg-ink-900/30">
                        <h3 className="text-xl font-bold mb-6 flex items-center gap-2 text-ink-100">
                            <MessageSquare size={20} className="text-ink-400" /> 최신 커뮤니티 소식
                        </h3>
                        <div className="flex flex-col gap-4">
                            <FeedItem author="김철수" title="새로운 카트리지 사용 후기" time="10분 전" />
                            <FeedItem author="이영희" title="하드웨어 펌웨어 업데이트 안내" time="1시간 전" />
                            <FeedItem author="박민수" title="데이터 분석 팁 공유합니다" time="3시간 전" />
                        </div>
                    </div>
                </div>
            </main>
        </div>
    );
}

function InkStatusCard({ title, value, unit, icon, trend }: any) {
    return (
        <div className="ink-card p-6 bg-ink-900/50 hover:bg-ink-900/80 group">
            <div className="flex justify-between items-start mb-4">
                <span className="text-ink-400 text-sm font-serif">{title}</span>
                <div className="p-2 rounded-lg bg-ink-800 group-hover:bg-ink-700 transition-colors">
                    {icon}
                </div>
            </div>
            <div className="flex items-baseline gap-2 mb-2">
                <span className="text-4xl font-bold text-ink-100 font-brush">{value}</span>
                <span className="text-ink-500 text-sm">{unit}</span>
            </div>
            <div className="text-xs text-accent-gold flex items-center gap-1">
                <ArrowUpRight size={12} /> {trend}
            </div>
        </div>
    );
}

function DeviceItem({ name, status, lastSeen }: any) {
    return (
        <div className="flex justify-between items-center p-3 rounded-xl bg-ink-800/30 border border-ink-800 hover:border-ink-600 transition-colors">
            <div className="flex items-center gap-3">
                <div className={`w-2 h-2 rounded-full ${status === 'online' ? 'bg-green-500 shadow-[0_0_8px_#22c55e]' : 'bg-red-500'}`} />
                <span className="text-ink-200">{name}</span>
            </div>
            <span className="text-xs text-ink-500">{lastSeen}</span>
        </div>
    );
}

function FeedItem({ author, title, time }: any) {
    return (
        <div className="border-b border-ink-800 pb-3 last:border-0 last:pb-0">
            <h4 className="text-ink-200 mb-1 hover:text-accent-gold transition-colors cursor-pointer">{title}</h4>
            <div className="flex justify-between text-xs text-ink-500">
                <span>{author}</span>
                <span>{time}</span>
            </div>
        </div>
    );
}
