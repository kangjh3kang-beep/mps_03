import { io, Socket } from 'socket.io-client';

class AdminSocketService {
    private socket: Socket | null = null;
    private static instance: AdminSocketService;

    private constructor() { }

    public static getInstance(): AdminSocketService {
        if (!AdminSocketService.instance) {
            AdminSocketService.instance = new AdminSocketService();
        }
        return AdminSocketService.instance;
    }

    public connect() {
        if (this.socket?.connected) return;

        // Connect to backend (assuming localhost:3000 for now)
        this.socket = io('http://localhost:3000', {
            transports: ['websocket'],
            autoConnect: true,
        });

        this.socket.on('connect', () => {
            console.log('Admin Socket Connected');
            this.socket?.emit('join_admin');
        });

        this.socket.on('disconnect', () => {
            console.log('Admin Socket Disconnected');
        });
    }

    public onLiveData(callback: (data: any) => void) {
        this.socket?.on('live_data', callback);
    }

    public onStatusUpdate(callback: (data: any) => void) {
        this.socket?.on('status_update', callback);
    }

    public disconnect() {
        this.socket?.disconnect();
        this.socket = null;
    }
}

export const adminSocket = AdminSocketService.getInstance();
