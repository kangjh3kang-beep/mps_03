'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { LayoutDashboard, Cpu, Users, Settings, LogOut, Map, BarChart } from 'lucide-react';
import { supabase } from '@/lib/supabase';
import { useRouter } from 'next/navigation';

export default function Sidebar() {
    const router = useRouter();
    const pathname = usePathname();

    const handleLogout = async () => {
        await supabase.auth.signOut();
        router.push('/login');
    };

    return (
        <aside className="w-64 h-[calc(100vh-2rem)] m-4 flex flex-col p-6 ink-card bg-ink-900/50">
            <div className="mb-10 text-center">
                <h1 className="text-3xl font-brush text-ink-100">만파식<span className="text-accent-red text-sm align-top ml-1">Admin</span></h1>
                <p className="text-xs text-ink-500 font-serif mt-1 tracking-widest">ECOSYSTEM CORE</p>
            </div>

            <nav className="flex flex-col gap-2 flex-1">
                <NavItem href="/dashboard" icon={<LayoutDashboard size={20} />} label="대시보드" active={pathname === '/dashboard'} />
                <NavItem href="/ems" icon={<Map size={20} />} label="EMS 관제" active={pathname === '/ems'} />
                <NavItem href="/analysis" icon={<BarChart size={20} />} label="전문가 분석" active={pathname === '/analysis'} />
                <NavItem href="/devices" icon={<Cpu size={20} />} label="기기 관리" active={pathname === '/devices'} />
                <NavItem href="/community" icon={<Users size={20} />} label="커뮤니티" active={pathname === '/community'} />
                <NavItem href="/settings" icon={<Settings size={20} />} label="설정" active={pathname === '/settings'} />
            </nav>

            <button
                onClick={handleLogout}
                className="flex items-center gap-3 p-3 text-accent-red hover:bg-accent-red/10 rounded-lg transition-colors mt-auto"
            >
                <LogOut size={20} />
                <span className="font-serif">로그아웃</span>
            </button>
        </aside>
    );
}

function NavItem({ href, icon, label, active = false }: { href: string, icon: React.ReactNode, label: string, active?: boolean }) {
    return (
        <Link 
            href={href} 
            className={`flex items-center gap-3 p-3 rounded-lg transition-all duration-300 font-serif ${
                active 
                ? 'bg-ink-800 text-accent-gold border-l-4 border-accent-gold shadow-lg' 
                : 'text-ink-400 hover:text-ink-100 hover:bg-ink-800/50'
            }`}
        >
            {icon}
            <span>{label}</span>
        </Link>
    );
}
