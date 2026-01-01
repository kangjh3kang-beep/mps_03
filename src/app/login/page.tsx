'use client';

import { useState } from 'react';
import { supabase } from '@/lib/supabase';
import { useRouter } from 'next/navigation';

export default function LoginPage() {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [loading, setLoading] = useState(false);
    const router = useRouter();

    const handleLogin = async (e: React.FormEvent) => {
        e.preventDefault();
        setLoading(true);
        const { error } = await supabase.auth.signInWithPassword({ email, password });
        if (error) alert(error.message);
        else router.push('/dashboard');
        setLoading(false);
    };

    const handleSocialLogin = async (provider: 'google' | 'github') => {
        const redirectTo = typeof window !== 'undefined'
            ? `${window.location.origin}/auth/callback`
            : '';

        const { error } = await supabase.auth.signInWithOAuth({
            provider,
            options: {
                redirectTo: redirectTo
            }
        });

        if (error) {
            console.error('Social Login Error:', error.message);
            alert(`로그인 오류: ${error.message}`);
        }
    };

    return (
        <div style={{
            minHeight: '100vh',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            background: '#050a14'
        }}>
            <div className="glass" style={{ padding: '2.5rem', width: '100%', maxWidth: '400px' }}>
                <h2 className="neon-text" style={{ textAlign: 'center', marginBottom: '2rem' }}>접속 인증</h2>

                <form onSubmit={handleLogin} style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
                    <input
                        type="email"
                        placeholder="이메일"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                        style={{
                            padding: '0.8rem',
                            borderRadius: '8px',
                            border: '1px solid var(--border)',
                            background: 'rgba(255,255,255,0.05)',
                            color: 'white'
                        }}
                        required
                    />
                    <input
                        type="password"
                        placeholder="비밀번호"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        style={{
                            padding: '0.8rem',
                            borderRadius: '8px',
                            border: '1px solid var(--border)',
                            background: 'rgba(255,255,255,0.05)',
                            color: 'white'
                        }}
                        required
                    />
                    <button
                        type="submit"
                        disabled={loading}
                        className="neon-border"
                        style={{
                            padding: '0.8rem',
                            borderRadius: '8px',
                            background: 'var(--primary)',
                            color: 'black',
                            fontWeight: 'bold',
                            marginTop: '1rem'
                        }}
                    >
                        {loading ? '인증 중...' : '로그인'}
                    </button>
                </form>

                <div style={{ margin: '2rem 0', display: 'flex', alignItems: 'center', gap: '1rem' }}>
                    <div style={{ flex: 1, height: '1px', background: 'var(--border)' }}></div>
                    <span style={{ color: 'var(--text-dim)', fontSize: '0.8rem' }}>또는</span>
                    <div style={{ flex: 1, height: '1px', background: 'var(--border)' }}></div>
                </div>

                <div style={{ display: 'flex', gap: '1rem' }}>
                    <button
                        onClick={() => handleSocialLogin('google')}
                        style={{
                            flex: 1,
                            padding: '0.6rem',
                            borderRadius: '8px',
                            border: '1px solid var(--border)',
                            background: 'transparent',
                            color: 'white'
                        }}
                    >
                        Google
                    </button>
                    <button
                        onClick={() => handleSocialLogin('github')}
                        style={{
                            flex: 1,
                            padding: '0.6rem',
                            borderRadius: '8px',
                            border: '1px solid var(--border)',
                            background: 'transparent',
                            color: 'white'
                        }}
                    >
                        GitHub
                    </button>
                </div>
            </div>
        </div>
    );
}
