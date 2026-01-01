import Link from 'next/link';

export default function LandingPage() {
    return (
        <main className="min-h-screen flex flex-col items-center justify-center bg-[#050a14] relative overflow-hidden">
            {/* Background Animation Elements */}
            <div className="absolute top-0 left-0 w-full h-full overflow-hidden pointer-events-none">
                <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-cyan-500/10 blur-[120px] rounded-full"></div>
                <div className="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] bg-purple-500/10 blur-[120px] rounded-full"></div>
            </div>

            <div className="glass p-12 text-center max-w-2xl relative z-10 border-cyan-500/20 shadow-[0_0_50px_rgba(6,182,212,0.1)]">
                <div className="mb-8 inline-block px-4 py-1.5 bg-cyan-500/10 border border-cyan-500/20 rounded-full text-cyan-400 text-[10px] font-black tracking-[0.3em] uppercase">
                    Next-Gen Bio Ecosystem
                </div>

                <h1 className="text-7xl font-black tracking-tighter mb-6 bg-gradient-to-b from-white to-slate-500 bg-clip-text text-transparent">
                    MANPASIK
                </h1>

                <p className="text-slate-400 text-lg mb-10 leading-relaxed font-medium">
                    하드웨어 제어와 커뮤니티의 완벽한 통합.<br />
                    <span className="text-cyan-400/80">비전문가도 쉽게 관리하는 미래형 헬스케어 생태계</span>에 오신 것을 환영합니다.
                </p>

                <div className="flex flex-col sm:flex-row gap-4 justify-center">
                    <Link href="/login" className="px-10 py-4 bg-cyan-500 text-black font-black rounded-2xl hover:bg-cyan-400 transition-all hover:scale-105 shadow-[0_0_20px_rgba(6,182,212,0.4)]">
                        시스템 시작하기
                    </Link>
                    <Link href="/ems" className="px-10 py-4 bg-slate-900 text-white font-black rounded-2xl border border-slate-800 hover:border-slate-700 transition-all">
                        글로벌 EMS 확인
                    </Link>
                </div>

                <div className="mt-12 pt-8 border-t border-slate-800/50 flex justify-center gap-8 text-[10px] font-bold text-slate-500 uppercase tracking-widest">
                    <div className="flex items-center gap-2"><div className="w-1.5 h-1.5 bg-cyan-500 rounded-full"></div> AI Powered</div>
                    <div className="flex items-center gap-2"><div className="w-1.5 h-1.5 bg-purple-500 rounded-full"></div> Blockchain Secured</div>
                    <div className="flex items-center gap-2"><div className="w-1.5 h-1.5 bg-green-500 rounded-full"></div> Global Scalability</div>
                </div>
            </div>

            {/* Footer Credit */}
            <div className="absolute bottom-8 text-slate-600 text-[10px] font-bold tracking-widest uppercase">
                © 2026 MANPASIK GLOBAL HUMAN HEALTH ECOSYSTEM
            </div>
        </main>
    );
}
