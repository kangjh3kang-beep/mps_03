import type { Metadata } from "next";
import "./globals.css";
import Navbar from "../components/Navbar";
import Footer from "../components/Footer";
import InkCursor from "../components/InkCursor";

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
    <html lang="ko" className="scroll-smooth">
      <body className="antialiased bg-paper text-ink-900 selection:bg-ink-900 selection:text-paper flex flex-col min-h-screen">
        <InkCursor />
        
        {/* SVG Filters for Liquid Effects */}
        <svg className="hidden">
          <defs>
            <filter id="liquid">
              <feTurbulence type="fractalNoise" baseFrequency="0.01 0.01" numOctaves="1" result="warp" />
              <feDisplacementMap xChannelSelector="R" yChannelSelector="G" scale="30" in="SourceGraphic" in2="warp" />
            </filter>
          </defs>
        </svg>

        <Navbar />
        <main className="flex-grow pt-20">
          {children}
        </main>
        <Footer />
      </body>
    </html>
  );
}
