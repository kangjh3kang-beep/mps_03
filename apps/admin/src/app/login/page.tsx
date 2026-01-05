'use client';

import { useState } from 'react';
import { authService } from '@/lib/auth';
import { useRouter } from 'next/navigation';

export default function LoginPage() {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [loading, setLoading] = useState(false);
    const router = useRouter();

    const handleLogin = async (e: React.FormEvent) => {
        e.preventDefault();
        setLoading(true);
        try {
            await authService.login(email, password);
            router.push('/dashboard');
        } catch (error: any) {
            alert(error.message);
        } finally {
            setLoading(false);
        }
    };

    const handleSocialLogin = async (provider: 'google' | 'github') => {
        alert('소셜 로그인은 현재 준비 중입니다.');
    };

    return (
        <div className="min-h-screen flex items-center justify-center bg-ink-950 bg-[url('https://www.transparenttextures.com/patterns/black-paper.png')]">
            <div className="ink-card p-10 w-full max-w-md bg-ink-900/50 backdrop-blur-md relative overflow-hidden">
                {/* Decorative Ink Splash */}
                <div className="absolute -top-20 -right-20 w-40 h-40 bg-accent-gold/10 rounded-full blur-3xl pointer-events-none" />
                
                <div className="text-center mb-10 relative z-10">
                    <h2 className="text-5xl font-brush text-ink-100 mb-2">접속 인증</h2>
                    <p className="text-ink-500 font-serif text-sm tracking-widest">MANPASIK ADMIN ACCESS</p>
                </div>

                <form onSubmit={handleLogin} className="flex flex-col gap-4 relative z-10">
                    <div className="space-y-4">
                        <input
                            type="email"
                            placeholder="이메일"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            className="w-full p-4 rounded-xl bg-ink-800/50 border border-ink-700 text-ink-100 placeholder-ink-600 focus:border-accent-gold outline-none transition-colors font-serif"
                            required
                        />
                        <input
                            type="password"
                            placeholder="비밀번호"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            className="w-full p-4 rounded-xl bg-ink-800/50 border border-ink-700 text-ink-100 placeholder-ink-600 focus:border-accent-gold outline-none transition-colors font-serif"
                            required
                        />
                    </div>
                    
                    <button
                        type="submit"
                        disabled={loading}
                        className="w-full p-4 mt-4 rounded-xl bg-ink-100 text-ink-900 font-bold hover:bg-accent-gold transition-colors font-serif shadow-lg disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                        {loading ? '인증 중...' : '로그인'}
                    </button>
                </form>

                <div className="my-8 flex items-center gap-4">
                    <div className="flex-1 h-px bg-ink-800"></div>
                    <span className="text-ink-600 text-xs font-serif">또는</span>
                    <div className="flex-1 h-px bg-ink-800"></div>
                </div>

                <div className="flex gap-4">
                    <button
                        onClick={() => handleSocialLogin('google')}
                        className="flex-1 p-3 rounded-xl border border-ink-700 hover:border-ink-500 text-ink-400 hover:text-ink-200 transition-colors font-serif text-sm"
                    >
                        Google
                    </button>
                    <button
                        onClick={() => handleSocialLogin('github')}
                        className="flex-1 p-3 rounded-xl border border-ink-700 hover:border-ink-500 text-ink-400 hover:text-ink-200 transition-colors font-serif text-sm"
                    >
                        GitHub
                    </button>
                </div>
            </div>
        </div>
    );
}
