'use client';

import Link from 'next/link';
import { ShieldCheck, Menu, X } from 'lucide-react';
import { useState } from 'react';

export default function Navbar() {
    const [isOpen, setIsOpen] = useState(false);

    return (
        <nav className="fixed top-0 left-0 w-full z-50 bg-[#050a14]/80 backdrop-blur-md border-b border-white/5">
            <div className="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
                {/* Logo */}
                <Link href="/" className="flex items-center gap-2 group">
                    <div className="w-10 h-10 bg-cyan-500 rounded-xl flex items-center justify-center shadow-[0_0_20px_rgba(6,182,212,0.3)] group-hover:scale-110 transition-transform">
                        <ShieldCheck size={24} className="text-black" />
                    </div>
                    <span className="text-xl font-black tracking-tighter text-white">MANPASIK</span>
                </Link>

                {/* Desktop Menu */}
                <div className="hidden md:flex items-center gap-8">
                    <Link href="/about" className="text-sm font-bold text-slate-400 hover:text-cyan-400 transition-colors">소개</Link>
                    <Link href="/features" className="text-sm font-bold text-slate-400 hover:text-cyan-400 transition-colors">주요기능</Link>
                    <Link href="/ems" className="text-sm font-bold text-slate-400 hover:text-cyan-400 transition-colors">글로벌 EMS</Link>
                    <div className="h-4 w-[1px] bg-white/10 mx-2"></div>
                    <Link href="/login" className="text-sm font-bold text-white hover:text-cyan-400 transition-colors">로그인</Link>
                    <Link href="/signup" className="px-6 py-2.5 bg-cyan-500 text-black text-sm font-black rounded-xl hover:bg-cyan-400 transition-all shadow-[0_0_15px_rgba(6,182,212,0.3)]">
                        회원가입
                    </Link>
                </div>

                {/* Mobile Toggle */}
                <button onClick={() => setIsOpen(!isOpen)} className="md:hidden text-white">
                    {isOpen ? <X size={24} /> : <Menu size={24} />}
                </button>
            </div>

            {/* Mobile Menu */}
            {isOpen && (
                <div className="md:hidden bg-[#050a14] border-b border-white/5 px-6 py-8 flex flex-col gap-6 animate-in slide-in-from-top-4 duration-300">
                    <Link href="/about" className="text-lg font-bold text-slate-400">소개</Link>
                    <Link href="/features" className="text-lg font-bold text-slate-400">주요기능</Link>
                    <Link href="/ems" className="text-lg font-bold text-slate-400">글로벌 EMS</Link>
                    <hr className="border-white/5" />
                    <Link href="/login" className="text-lg font-bold text-white">로그인</Link>
                    <Link href="/signup" className="w-full py-4 bg-cyan-500 text-black text-center font-black rounded-2xl">
                        회원가입
                    </Link>
                </div>
            )}
        </nav>
    );
}
