import Link from 'next/link';

export default function LandingPage() {
    return (
        <main style={{
            minHeight: '100vh',
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            justifyContent: 'center',
            background: 'radial-gradient(circle at center, #0f172a 0%, #050a14 100%)'
        }}>
            <div className="glass" style={{ padding: '3rem', textAlign: 'center', maxWidth: '600px' }}>
                <h1 className="neon-text" style={{ fontSize: '3rem', marginBottom: '1rem' }}>MANPASIK</h1>
                <p style={{ color: 'var(--text-dim)', marginBottom: '2rem', lineHeight: '1.6' }}>
                    하드웨어 제어와 커뮤니티의 통합.<br />
                    비전문가도 쉽게 관리하는 미래형 생태계에 오신 것을 환영합니다.
                </p>
                <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center' }}>
                    <Link href="/login" className="neon-border" style={{
                        padding: '0.8rem 2rem',
                        borderRadius: '8px',
                        background: 'transparent',
                        color: 'var(--primary)',
                        fontWeight: 'bold'
                    }}>
                        시작하기
                    </Link>
                </div>
            </div>
        </main>
    );
}
