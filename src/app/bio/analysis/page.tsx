'use client';

import React from 'react';
import Navbar from '@/components/Navbar';
import Sidebar from '@/components/Sidebar';

export default function AnalysisPage() {
    return (
        <div className="min-h-screen bg-[#050a14] text-white">
            <Navbar />
            <div className="flex pt-20">
                <Sidebar />
                <main className="flex-1 p-8 flex flex-col items-center justify-center text-slate-500">
                    <h1 className="text-2xl font-bold mb-4 text-white">AI Calibration View</h1>
                    <p>측정 데이터 분석 및 AI 보정 모듈 준비 중입니다.</p>
                </main>
            </div>
        </div>
    );
}
