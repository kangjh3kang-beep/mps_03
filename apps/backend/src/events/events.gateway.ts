import {
    SubscribeMessage,
    WebSocketGateway,
    WebSocketServer,
    OnGatewayConnection,
    OnGatewayDisconnect,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';

@WebSocketGateway({
    cors: {
        origin: '*',
    },
})
export class EventsGateway implements OnGatewayConnection, OnGatewayDisconnect {
    @WebSocketServer()
    server: Server;

    handleConnection(client: Socket) {
        console.log(`Client connected: ${client.id}`);
    }

    handleDisconnect(client: Socket) {
        console.log(`Client disconnected: ${client.id}`);
    }

    @SubscribeMessage('join_admin')
    handleJoinAdmin(client: Socket) {
        client.join('admin_channel');
        console.log(`Client ${client.id} joined admin_channel`);
        return { event: 'joined_admin', data: 'success' };
    }

    @SubscribeMessage('measure_data')
    handleMeasureData(client: Socket, payload: any) {
        // Broadcast to all admins
        this.server.to('admin_channel').emit('live_data', payload);
        // console.log('Relayed data:', payload);
    }

    @SubscribeMessage('session_status')
    handleSessionStatus(client: Socket, payload: any) {
        this.server.to('admin_channel').emit('status_update', payload);
    }
}
