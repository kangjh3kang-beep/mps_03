'use client';

import React from 'react';
import Navbar from '@/components/Navbar';
import Sidebar from '@/components/Sidebar';

export default function PatentWritePage() {
    return (
        <div className="min-h-screen bg-[#050a14] text-white">
            <Navbar />
            <div className="flex pt-20">
                <Sidebar />
                <main className="flex-1 p-8 flex flex-col items-center justify-center text-slate-500">
                    <h1 className="text-2xl font-bold mb-4 text-white">Patent Writing Studio</h1>
                    <p>특허 명세서 자동 생성 및 작성 모듈 준비 중입니다.</p>
                </main>
            </div>
        </div>
    );
}
