'use client';

import Sidebar from '@/components/Sidebar';
import { Cpu, MessageSquare, Activity, Zap } from 'lucide-react';

export default function DashboardPage() {
    return (
        <div style={{ display: 'flex', minHeight: '100vh', background: '#050a14' }}>
            <Sidebar />

            <main style={{ flex: 1, padding: '2rem', overflowY: 'auto' }}>
                <header style={{ marginBottom: '2rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <div>
                        <h2 style={{ fontSize: '1.8rem', fontWeight: 'bold' }}>시스템 개요</h2>
                        <p style={{ color: 'var(--text-dim)' }}>만파식 생태계의 실시간 상태를 확인하세요.</p>
                    </div>
                    <div className="glass" style={{ padding: '0.5rem 1rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                        <div style={{ width: '8px', height: '8px', borderRadius: '50%', background: '#00ff00', boxShadow: '0 0 5px #00ff00' }}></div>
                        <span style={{ fontSize: '0.9rem' }}>서버 정상 작동 중</span>
                    </div>
                </header>

                <section style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '1.5rem', marginBottom: '3rem' }}>
                    <StatusCard
                        title="연결된 기기"
                        value="12"
                        unit="Units"
                        icon={<Cpu className="neon-text" />}
                        trend="+2 신규"
                    />
                    <StatusCard
                        title="실시간 로그"
                        value="1,284"
                        unit="Events/hr"
                        icon={<Activity className="neon-text" />}
                        trend="안정적"
                    />
                    <StatusCard
                        title="시스템 부하"
                        value="24"
                        unit="%"
                        icon={<Zap className="neon-text" />}
                        trend="최적화됨"
                    />
                </section>

                <div style={{ display: 'grid', gridTemplateColumns: '1.5fr 1fr', gap: '2rem' }}>
                    {/* 기기 상태 요약 */}
                    <div className="glass" style={{ padding: '1.5rem' }}>
                        <h3 style={{ marginBottom: '1.5rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                            <Cpu size={20} /> 기기 상태 요약
                        </h3>
                        <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
                            <DeviceItem name="MPS-Alpha-01" status="online" lastSeen="방금 전" />
                            <DeviceItem name="MPS-Beta-04" status="online" lastSeen="2분 전" />
                            <DeviceItem name="MPS-Gamma-09" status="offline" lastSeen="1시간 전" />
                        </div>
                    </div>

                    {/* 커뮤니티 최신 피드 */}
                    <div className="glass" style={{ padding: '1.5rem' }}>
                        <h3 style={{ marginBottom: '1.5rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                            <MessageSquare size={20} /> 최신 커뮤니티 소식
                        </h3>
                        <div style={{ display: 'flex', flexDirection: 'column', gap: '1.2rem' }}>
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

function StatusCard({ title, value, unit, icon, trend }: any) {
    return (
        <div className="glass" style={{ padding: '1.5rem' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '1rem' }}>
                <span style={{ color: 'var(--text-dim)', fontSize: '0.9rem' }}>{title}</span>
                {icon}
            </div>
            <div style={{ display: 'flex', alignItems: 'baseline', gap: '0.5rem' }}>
                <span style={{ fontSize: '2rem', fontWeight: 'bold' }}>{value}</span>
                <span style={{ color: 'var(--text-dim)', fontSize: '0.9rem' }}>{unit}</span>
            </div>
            <div style={{ marginTop: '1rem', fontSize: '0.8rem', color: 'var(--primary)' }}>
                {trend}
            </div>
        </div>
    );
}

function DeviceItem({ name, status, lastSeen }: any) {
    return (
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '0.8rem', borderRadius: '8px', background: 'rgba(255,255,255,0.03)' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
                <div style={{ width: '10px', height: '10px', borderRadius: '50%', background: status === 'online' ? '#00ff00' : '#ff4444' }}></div>
                <span>{name}</span>
            </div>
            <span style={{ fontSize: '0.8rem', color: 'var(--text-dim)' }}>{lastSeen}</span>
        </div>
    );
}

function FeedItem({ author, title, time }: any) {
    return (
        <div style={{ borderBottom: '1px solid var(--border)', paddingBottom: '0.8rem' }}>
            <h4 style={{ fontSize: '1rem', marginBottom: '0.3rem' }}>{title}</h4>
            <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.8rem', color: 'var(--text-dim)' }}>
                <span>{author}</span>
                <span>{time}</span>
            </div>
        </div>
    );
}
