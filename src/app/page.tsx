import Link from 'next/link';
import Navbar from '@/components/Navbar';
import { Activity, Shield, Zap, Globe, Database, Users } from 'lucide-react';

export default function LandingPage() {
    return (
        <div className="bg-[#050a14] text-white font-sans">
            <Navbar />

            <main className="relative">
                {/* Hero Section */}
                <section className="min-h-screen flex flex-col items-center justify-center relative overflow-hidden px-6">
                    {/* Background Animation Elements */}
                    <div className="absolute top-0 left-0 w-full h-full overflow-hidden pointer-events-none">
                        <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-cyan-500/10 blur-[120px] rounded-full"></div>
                        <div className="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] bg-purple-500/10 blur-[120px] rounded-full"></div>
                    </div>

                    <div className="glass p-12 text-center max-w-3xl relative z-10 border-cyan-500/20 shadow-[0_0_50px_rgba(6,182,212,0.1)] animate-in fade-in zoom-in duration-1000">
                        <div className="mb-8 inline-block px-4 py-1.5 bg-cyan-500/10 border border-cyan-500/20 rounded-full text-cyan-400 text-[10px] font-black tracking-[0.3em] uppercase">
                            Next-Gen Bio Ecosystem
                        </div>

                        <h1 className="text-7xl md:text-8xl font-black tracking-tighter mb-6 bg-gradient-to-b from-white to-slate-500 bg-clip-text text-transparent">
                            MANPASIK
                        </h1>

                        <p className="text-slate-400 text-lg md:text-xl mb-10 leading-relaxed font-medium max-w-xl mx-auto">
                            하드웨어 제어와 커뮤니티의 완벽한 통합.<br />
                            <span className="text-cyan-400/80">비전문가도 쉽게 관리하는 미래형 헬스케어 생태계</span>에 오신 것을 환영합니다.
                        </p>

                        <div className="flex flex-col sm:flex-row gap-4 justify-center">
                            <Link href="/signup" className="px-10 py-4 bg-cyan-500 text-black font-black rounded-2xl hover:bg-cyan-400 transition-all hover:scale-105 shadow-[0_0_20px_rgba(6,182,212,0.4)]">
                                무료로 시작하기
                            </Link>
                            <Link href="/ems" className="px-10 py-4 bg-slate-900 text-white font-black rounded-2xl border border-slate-800 hover:border-slate-700 transition-all">
                                글로벌 EMS 확인
                            </Link>
                        </div>
                    </div>
                </section>

                {/* Features Section */}
                <section className="py-24 px-6 max-w-7xl mx-auto">
                    <div className="text-center mb-16">
                        <h2 className="text-4xl font-black mb-4">혁신적인 생태계 기능</h2>
                        <p className="text-slate-500">만파식은 단순한 플랫폼을 넘어 인류의 건강한 미래를 설계합니다.</p>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                        <FeatureCard
                            icon={<Zap className="text-cyan-400" />}
                            title="AI 자가치유 시스템"
                            description="시스템 오류를 실시간으로 탐지하고 스스로 복구하는 지능형 인프라를 제공합니다."
                        />
                        <FeatureCard
                            icon={<Shield className="text-purple-400" />}
                            title="데이터 무결성 보장"
                            description="블록체인 기반 해시 체인 기술로 모든 건강 데이터를 위변조로부터 보호합니다."
                        />
                        <FeatureCard
                            icon={<Globe className="text-green-400" />}
                            title="글로벌 EMS 연동"
                            description="전 세계 어디서나 실시간으로 건강 지표를 모니터링하고 관리할 수 있습니다."
                        />
                    </div>
                </section>

                {/* Stats Section */}
                <section className="py-24 bg-slate-900/30 border-y border-white/5">
                    <div className="max-w-7xl mx-auto px-6 grid grid-cols-2 md:grid-cols-4 gap-12 text-center">
                        <StatItem value="124+" label="활성 국가" />
                        <StatItem value="1.2M+" label="누적 사용자" />
                        <StatItem value="99.9%" label="데이터 신뢰도" />
                        <StatItem value="24/7" label="실시간 모니터링" />
                    </div>
                </section>
            </main>

            {/* Footer */}
            <footer className="py-12 px-6 border-t border-white/5 text-center">
                <div className="text-slate-600 text-[10px] font-bold tracking-widest uppercase mb-4">
                    © 2026 MANPASIK GLOBAL HUMAN HEALTH ECOSYSTEM
                </div>
                <div className="flex justify-center gap-6 text-xs text-slate-500">
                    <Link href="/privacy" className="hover:text-white transition-colors">개인정보처리방침</Link>
                    <Link href="/terms" className="hover:text-white transition-colors">이용약관</Link>
                    <Link href="/contact" className="hover:text-white transition-colors">고객지원</Link>
                </div>
            </footer>
        </div>
    );
}

function FeatureCard({ icon, title, description }: any) {
    return (
        <div className="glass p-8 border-white/5 hover:border-cyan-500/30 transition-all group">
            <div className="w-12 h-12 bg-white/5 rounded-xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                {icon}
            </div>
            <h3 className="text-xl font-bold mb-4">{title}</h3>
            <p className="text-slate-500 text-sm leading-relaxed">{description}</p>
        </div>
    );
}

function StatItem({ value, label }: any) {
    return (
        <div>
            <div className="text-4xl font-black text-cyan-400 mb-2">{value}</div>
            <div className="text-xs font-bold text-slate-500 uppercase tracking-widest">{label}</div>
        </div>
    );
}
