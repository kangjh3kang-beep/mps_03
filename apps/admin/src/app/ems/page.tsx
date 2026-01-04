'use client';

import { useEffect, useState } from 'react';
import dynamic from 'next/dynamic';
import { adminSocket } from '@/lib/socket';

// Leaflet map must be loaded dynamically with ssr: false
const MapWithNoSSR = dynamic(() => import('../../components/ems/EmsMap'), {
    ssr: false,
    loading: () => <div className="w-full h-full flex items-center justify-center text-primary">Loading Map...</div>
});

export default function EmsPage() {
    const [alerts, setAlerts] = useState<any[]>([]);

    useEffect(() => {
        adminSocket.connect();

        adminSocket.onLiveData((data) => {
            const newAlert = {
                time: new Date(data.timestamp).toLocaleTimeString(),
                message: `실시간 데이터 수신: ${data.value.toFixed(2)}`,
                level: 'info'
            };
            setAlerts(prev => [newAlert, ...prev].slice(0, 5));
        });

        return () => {
            adminSocket.disconnect();
        };
    }, []);

    return (
        <div className="p-6 h-full flex flex-col gap-6">
            <div className="flex justify-between items-center">
                <div>
                    <h1 className="text-3xl font-bold text-primary neon-text-cyan">EMS 관제 시스템</h1>
                    <p className="text-muted-foreground">실시간 환경 데이터 및 리더기 상태 모니터링</p>
                </div>
                <div className="flex gap-4">
                    <StatusCard label="정상 가동" value="1,240" color="text-green-400" />
                    <StatusCard label="주의 필요" value="12" color="text-yellow-400" />
                    <StatusCard label="연결 끊김" value="5" color="text-red-400" />
                </div>
            </div>

            <div className="flex-1 glass-card overflow-hidden relative rounded-xl border border-white/10">
                <MapWithNoSSR />

                {/* Overlay Panel */}
                <div className="absolute top-4 right-4 w-80 glass-panel p-4 flex flex-col gap-4 z-[1000]">
                    <h3 className="text-lg font-bold text-white border-b border-white/10 pb-2">실시간 알림</h3>
                    <div className="flex flex-col gap-2">
                        {alerts.map((alert, i) => (
                            <AlertItem key={i} time={alert.time} message={alert.message} level={alert.level} />
                        ))}
                        <AlertItem time="10:23:45" message="서울 강남구: 미세먼지 수치 급증" level="warning" />
                        <AlertItem time="10:15:12" message="부산 해운대구: 수질 오염 감지" level="danger" />
                        <AlertItem time="09:58:30" message="시스템: 정기 데이터 백업 완료" level="info" />
                    </div>
                </div>
            </div>
        </div>
    );
}

function StatusCard({ label, value, color }: { label: string, value: string, color: string }) {
    return (
        <div className="glass-panel px-6 py-3 flex flex-col items-center min-w-[120px]">
            <span className="text-sm text-muted-foreground">{label}</span>
            <span className={`text-2xl font-bold ${color}`}>{value}</span>
        </div>
    );
}

function AlertItem({ time, message, level }: { time: string, message: string, level: 'info' | 'warning' | 'danger' }) {
    const colors = {
        info: 'border-l-blue-500 bg-blue-500/10',
        warning: 'border-l-yellow-500 bg-yellow-500/10',
        danger: 'border-l-red-500 bg-red-500/10'
    };

    return (
        <div className={`p-3 border-l-2 text-sm ${colors[level]} rounded-r`}>
            <div className="text-xs text-muted-foreground mb-1">{time}</div>
            <div className="text-white">{message}</div>
        </div>
    );
}
