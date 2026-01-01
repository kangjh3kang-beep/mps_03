'use client';

import React, { useState, useEffect, useRef } from 'react';
import Navbar from '@/components/Navbar';
import Sidebar from '@/components/Sidebar';
import { ReaderSDK } from '@/lib/diffmeas-sdk/reader-sdk';
import { MeasurementResult, CartridgeInfo } from '@/lib/diffmeas-sdk/types';
import { Activity, Bluetooth, Play, Square, RefreshCcw, AlertCircle } from 'lucide-react';

export default function BioMeasurePage() {
    const [isConnected, setIsConnected] = useState(false);
    const [isMeasuring, setIsMeasuring] = useState(false);
    const [results, setResults] = useState<MeasurementResult[]>([]);
    const [currentResult, setCurrentResult] = useState<MeasurementResult | null>(null);
    const readerRef = useRef<ReaderSDK | null>(null);
    const stopFuncRef = useRef<(() => void) | null>(null);

    useEffect(() => {
        readerRef.current = new ReaderSDK();
        return () => {
            if (stopFuncRef.current) stopFuncRef.current();
        };
    }, []);

    const handleConnect = async () => {
        if (!readerRef.current) return;
        const success = await readerRef.current.connect();
        setIsConnected(success);
    };

    const startMeasurement = () => {
        if (!readerRef.current || !isConnected) return;

        const mockCartridge: CartridgeInfo = {
            id: 'CT-2026-X1',
            type: 'GLUCOSE',
            calibrationFactor: 1.25,
            expiryDate: '2026-12-31',
            batchNumber: 'B-99'
        };

        setIsMeasuring(true);
        const stop = readerRef.current.startMeasurement(mockCartridge, (result) => {
            setCurrentResult(result);
            setResults(prev => [...prev.slice(-19), result]); // Keep last 20 points
        });
        stopFuncRef.current = stop;
    };

    const stopMeasurement = () => {
        if (stopFuncRef.current) {
            stopFuncRef.current();
            stopFuncRef.current = null;
        }
        setIsMeasuring(false);
    };

    return (
        <div className="min-h-screen bg-[#050a14] text-white">
            <Navbar />
            <div className="flex pt-20">
                <Sidebar />

                <main className="flex-1 p-8">
                    <header className="flex justify-between items-center mb-10">
                        <div>
                            <h1 className="text-4xl font-black tracking-tight bg-gradient-to-r from-cyan-400 to-blue-600 bg-clip-text text-transparent">
                                Bio Measurement
                            </h1>
                            <p className="text-slate-500 mt-2">차분 측정(Differential Measurement) 기반 정밀 분석</p>
                        </div>

                        <div className="flex gap-4">
                            {!isConnected ? (
                                <button
                                    onClick={handleConnect}
                                    className="flex items-center gap-2 px-6 py-3 bg-slate-900 border border-cyan-500/30 text-cyan-400 font-bold rounded-xl hover:bg-cyan-500/10 transition-all"
                                >
                                    <Bluetooth size={18} /> Connect Reader
                                </button>
                            ) : (
                                <div className="flex items-center gap-2 px-6 py-3 bg-cyan-500/10 border border-cyan-500/30 text-cyan-400 font-bold rounded-xl">
                                    <div className="w-2 h-2 bg-cyan-500 rounded-full animate-pulse"></div> Reader Connected
                                </div>
                            )}
                        </div>
                    </header>

                    <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                        {/* Real-time Chart Placeholder */}
                        <div className="lg:col-span-2 glass p-8 border-white/5 min-h-[400px] flex flex-col">
                            <div className="flex justify-between items-center mb-8">
                                <h2 className="text-xl font-bold flex items-center gap-2">
                                    <Activity className="text-cyan-400" size={20} /> Real-time Signal
                                </h2>
                                <div className="flex gap-2">
                                    {isConnected && !isMeasuring && (
                                        <button onClick={startMeasurement} className="p-2 bg-green-500/20 text-green-400 rounded-lg hover:bg-green-500/30 transition-all">
                                            <Play size={20} />
                                        </button>
                                    )}
                                    {isMeasuring && (
                                        <button onClick={stopMeasurement} className="p-2 bg-red-500/20 text-red-400 rounded-lg hover:bg-red-500/30 transition-all">
                                            <Square size={20} />
                                        </button>
                                    )}
                                </div>
                            </div>

                            <div className="flex-1 bg-slate-950/50 rounded-3xl border border-white/5 relative overflow-hidden flex items-center justify-center">
                                {isMeasuring ? (
                                    <div className="absolute inset-0 p-4 flex items-end gap-1">
                                        {results.map((r, i) => (
                                            <div
                                                key={i}
                                                className="flex-1 bg-cyan-500/40 border-t-2 border-cyan-400 transition-all duration-300"
                                                style={{ height: `${(r.processedValue / 150) * 100}%` }}
                                            ></div>
                                        ))}
                                    </div>
                                ) : (
                                    <div className="text-slate-700 flex flex-col items-center gap-4">
                                        <Activity size={48} className="opacity-20" />
                                        <p className="text-sm font-bold tracking-widest uppercase opacity-40">Waiting for Signal...</p>
                                    </div>
                                )}
                            </div>
                        </div>

                        {/* Analysis Panel */}
                        <div className="space-y-8">
                            <div className="glass p-8 border-white/5">
                                <h3 className="text-sm font-bold text-slate-500 uppercase tracking-widest mb-6">Current Result</h3>
                                {currentResult ? (
                                    <div className="space-y-6">
                                        <div className="text-center">
                                            <div className="text-5xl font-black text-white mb-2">{currentResult.processedValue.toFixed(1)}</div>
                                            <div className="text-xs font-bold text-cyan-400 uppercase tracking-widest">{currentResult.unit}</div>
                                        </div>
                                        <div className="grid grid-cols-2 gap-4">
                                            <div className="p-4 bg-white/5 rounded-2xl border border-white/5">
                                                <div className="text-[10px] text-slate-500 font-bold uppercase mb-1">Diff Signal</div>
                                                <div className="text-sm font-mono">{currentResult.differentialSignal.toFixed(4)}</div>
                                            </div>
                                            <div className="p-4 bg-white/5 rounded-2xl border border-white/5">
                                                <div className="text-[10px] text-slate-500 font-bold uppercase mb-1">Confidence</div>
                                                <div className="text-sm font-mono">{(currentResult.confidenceScore * 100).toFixed(1)}%</div>
                                            </div>
                                        </div>
                                    </div>
                                ) : (
                                    <div className="py-10 text-center text-slate-600 italic text-sm">측정 데이터가 없습니다.</div>
                                )}
                            </div>

                            <div className="glass p-8 border-white/5">
                                <h3 className="text-sm font-bold text-slate-500 uppercase tracking-widest mb-6">Cartridge Info</h3>
                                <div className="space-y-4 text-sm">
                                    <div className="flex justify-between">
                                        <span className="text-slate-500">ID</span>
                                        <span className="font-bold">CT-2026-X1</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span className="text-slate-500">Type</span>
                                        <span className="px-2 py-0.5 bg-cyan-500/10 text-cyan-400 text-[10px] font-black rounded">GLUCOSE</span>
                                    </div>
                                    <div className="flex justify-between">
                                        <span className="text-slate-500">Calibration</span>
                                        <span className="font-mono">x1.25</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
    );
}
