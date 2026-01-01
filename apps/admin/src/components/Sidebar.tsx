'use client';

import Link from 'next/link';
import { LayoutDashboard, Cpu, Users, Settings, LogOut, Sun, Moon, Accessibility } from 'lucide-react';
import { supabase } from '@/lib/supabase';
import { useRouter } from 'next/navigation';
import { useTheme } from '@/lib/ThemeContext';

export default function Sidebar() {
    const router = useRouter();
    const { theme, setTheme } = useTheme();

    const handleLogout = async () => {
        await supabase.auth.signOut();
        router.push('/login');
    };

    return (
        <aside className="glass" style={{
            width: '260px',
            height: 'calc(100vh - 2rem)',
            margin: '1rem',
            display: 'flex',
            flexDirection: 'column',
            padding: '1.5rem'
        }}>
            <div style={{ marginBottom: '3rem' }}>
                <h1 className="neon-text" style={{ fontSize: '1.5rem', fontWeight: 'bold' }}>MPS CORE</h1>
            </div>

            <nav style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem', flex: 1 }}>
                <NavItem href="/dashboard" icon={<LayoutDashboard size={20} />} label="대시보드" active />
                <NavItem href="/devices" icon={<Cpu size={20} />} label="기기 관리" />
                <NavItem href="/community" icon={<Users size={20} />} label="커뮤니티" />
                <NavItem href="/settings" icon={<Settings size={20} />} label="설정" />
            </nav>

            <div style={{ marginBottom: '1.5rem', display: 'flex', gap: '0.5rem', justifyContent: 'center' }}>
                <ThemeButton active={theme === 'light'} onClick={() => setTheme('light')} icon={<Sun size={18} />} />
                <ThemeButton active={theme === 'dark'} onClick={() => setTheme('dark')} icon={<Moon size={18} />} />
                <ThemeButton active={theme === 'senior'} onClick={() => setTheme('senior')} icon={<Accessibility size={18} />} />
            </div>

            <button
                onClick={handleLogout}
                style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '0.8rem',
                    padding: '0.8rem',
                    color: '#ff4444',
                    background: 'transparent',
                    border: 'none',
                    textAlign: 'left'
                }}
            >
                <LogOut size={20} />
                <span>로그아웃</span>
            </button>
        </aside>
    );
}

function ThemeButton({ active, onClick, icon }: { active: boolean, onClick: () => void, icon: React.ReactNode }) {
    return (
        <button
            onClick={onClick}
            style={{
                padding: '0.5rem',
                borderRadius: '8px',
                border: '1px solid var(--border)',
                background: active ? 'var(--primary)' : 'transparent',
                color: active ? 'black' : 'var(--text-main)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
            }}
        >
            {icon}
        </button>
    );
}

function NavItem({ href, icon, label, active = false }: { href: string, icon: React.ReactNode, label: string, active?: boolean }) {
    return (
        <Link href={href} style={{
            display: 'flex',
            alignItems: 'center',
            gap: '0.8rem',
            padding: '0.8rem',
            borderRadius: '8px',
            background: active ? 'rgba(0, 242, 255, 0.1)' : 'transparent',
            color: active ? 'var(--primary)' : 'var(--text-dim)',
            transition: 'all 0.2s'
        }}>
            {icon}
            <span>{label}</span>
        </Link>
    );
}
