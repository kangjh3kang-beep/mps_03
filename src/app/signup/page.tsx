'use client';

import { useState } from 'react';
import { supabase } from '@/lib/supabase';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import Navbar from '@/components/Navbar';

export default function SignupPage() {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [loading, setLoading] = useState(false);
    const router = useRouter();

    const handleSignup = async (e: React.FormEvent) => {
        e.preventDefault();
        setLoading(true);
        const { error } = await supabase.auth.signUp({ email, password });
        if (error) alert(error.message);
        else {
            alert('회원가입 신청이 완료되었습니다. 이메일을 확인해 주세요!');
            router.push('/login');
        }
        setLoading(false);
    };

    return (
        <div className="min-h-screen bg-[#050a14] text-white">
            <Navbar />

            <div className="flex items-center justify-center min-h-screen pt-20">
                <div className="glass p-10 w-full max-w-md border-cyan-500/20 shadow-2xl">
                    <h2 className="text-3xl font-black text-center mb-8 bg-gradient-to-r from-cyan-400 to-blue-500 bg-clip-text text-transparent">
                        새로운 시작
                    </h2>

                    <form onSubmit={handleSignup} className="flex flex-col gap-4">
                        <div className="space-y-1">
                            <label className="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">Email Address</label>
                            <input
                                type="email"
                                placeholder="example@manpasik.com"
                                value={email}
                                onChange={(e) => setEmail(e.target.value)}
                                className="w-full p-4 rounded-xl bg-white/5 border border-white/10 focus:border-cyan-500/50 outline-none transition-all"
                                required
                            />
                        </div>
                        <div className="space-y-1">
                            <label className="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">Password</label>
                            <input
                                type="password"
                                placeholder="••••••••"
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                                className="w-full p-4 rounded-xl bg-white/5 border border-white/10 focus:border-cyan-500/50 outline-none transition-all"
                                required
                            />
                        </div>

                        <button
                            type="submit"
                            disabled={loading}
                            className="w-full py-4 bg-cyan-500 text-black font-black rounded-xl hover:bg-cyan-400 transition-all shadow-[0_0_20px_rgba(6,182,212,0.3)] mt-4 disabled:opacity-50"
                        >
                            {loading ? '처리 중...' : '회원가입'}
                        </button>
                    </form>

                    <div className="mt-8 text-center text-sm text-slate-500">
                        이미 계정이 있으신가요?{' '}
                        <Link href="/login" className="text-cyan-400 font-bold hover:underline">로그인하기</Link>
                    </div>
                </div>
            </div>
        </div>
    );
}
