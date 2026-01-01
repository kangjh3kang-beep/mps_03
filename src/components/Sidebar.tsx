'use client';

import Link from 'react-router-dom'; // Note: Next.js uses next/link, but I'll use standard Link for now or fix it to next/link
import LinkNext from 'next/link';
import {
    LayoutDashboard, Activity, FileText, Palette,
    Settings, LogOut, Shield, Zap, Globe, Database
} from 'lucide-react';
import { supabase } from '@/lib/supabase';
import { useRouter, usePathname } from 'next/navigation';

export default function Sidebar() {
    const router = useRouter();
    const pathname = usePathname();

    const handleLogout = async () => {
        await supabase.auth.signOut();
        router.push('/login');
    };

    const menuGroups = [
        {
            label: 'Core Platform',
            items: [
                { href: '/dashboard', icon: <LayoutDashboard size={18} />, label: 'Dashboard' },
                { href: '/ems', icon: <Globe size={18} />, label: 'Global EMS' },
            ]
        },
        {
            label: 'Bio / DiffMeas',
            items: [
                { href: '/bio/measure', icon: <Activity size={18} />, label: 'Measurement' },
                { href: '/bio/analysis', icon: <Database size={18} />, label: 'AI Analysis' },
            ]
        },
        {
            label: 'Intellectual Property',
            items: [
                { href: '/patent/write', icon: <FileText size={18} />, label: 'Patent Studio' },
                { href: '/patent/analyze', icon: <Shield size={18} />, label: 'IP Analysis' },
            ]
        },
        {
            label: 'Creative Studio',
            items: [
                { href: '/opal/studio', icon: <Palette size={18} />, label: 'Opal Studio' },
            ]
        }
    ];

    return (
        <aside className="w-64 bg-[#050a14] border-r border-white/5 flex flex-col h-[calc(100vh-5rem)] sticky top-20">
            <div className="flex-1 overflow-y-auto py-6 px-4 space-y-8">
                {menuGroups.map((group, idx) => (
                    <div key={idx} className="space-y-2">
                        <h3 className="text-[10px] font-black text-slate-600 uppercase tracking-[0.2em] px-4 mb-4">
                            {group.label}
                        </h3>
                        <div className="space-y-1">
                            {group.items.map((item) => (
                                <LinkNext
                                    key={item.href}
                                    href={item.href}
                                    className={`flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 group ${pathname === item.href
                                            ? 'bg-cyan-500/10 text-cyan-400 border border-cyan-500/20 shadow-[inset_0_0_10px_rgba(6,182,212,0.1)]'
                                            : 'text-slate-400 hover:bg-white/5 hover:text-slate-200'
                                        }`}
                                >
                                    <span className={`${pathname === item.href ? 'text-cyan-400' : 'text-slate-500 group-hover:text-cyan-400'} transition-colors`}>
                                        {item.icon}
                                    </span>
                                    <span className="text-sm font-bold">{item.label}</span>
                                </LinkNext>
                            ))}
                        </div>
                    </div>
                ))}
            </div>

            <div className="p-4 border-t border-white/5">
                <button
                    onClick={handleLogout}
                    className="w-full flex items-center gap-3 px-4 py-3 text-slate-500 hover:text-red-400 hover:bg-red-400/5 rounded-xl transition-all duration-200 font-bold text-sm"
                >
                    <LogOut size={18} />
                    <span>Logout</span>
                </button>
            </div>
        </aside>
    );
}
