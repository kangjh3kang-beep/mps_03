import '@/styles/globals.css';
import type { Metadata } from 'next';
import { ThemeProvider } from '@/lib/ThemeContext';

export const metadata: Metadata = {
    title: '만파식 (Manpasik) - 하드웨어 제어 플랫폼',
    description: '전 세계를 연결하는 하드웨어 제어 및 커뮤니티 통합 플랫폼',
};

export default function RootLayout({
    children,
}: {
    children: React.ReactNode;
}) {
    return (
        <html lang="ko">
            <body>
                <ThemeProvider>
                    {children}
                </ThemeProvider>
            </body>
        </html>
    );
}
