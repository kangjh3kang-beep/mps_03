import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "만파식 (Manpasik) Ecosystem",
  description: "홍익인간의 이념으로 세상을 치유하는 디지털 헬스케어 플랫폼",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ko">
      <body className="antialiased bg-paper text-ink-900 selection:bg-ink-900 selection:text-paper">
        {children}
      </body>
    </html>
  );
}
