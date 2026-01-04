'use client';

import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import L from 'leaflet';

// Fix for default marker icon in Leaflet with Next.js
const iconUrl = 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png';
const iconRetinaUrl = 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png';
const shadowUrl = 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png';

const customIcon = new L.Icon({
    iconUrl: iconUrl,
    iconRetinaUrl: iconRetinaUrl,
    shadowUrl: shadowUrl,
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
    shadowSize: [41, 41]
});

// Mock Data for Readers
const readers = [
    { id: 1, lat: 37.5665, lng: 126.9780, status: 'active', name: '서울 시청 리더기' },
    { id: 2, lat: 35.1796, lng: 129.0756, status: 'active', name: '부산 시청 리더기' },
    { id: 3, lat: 35.8714, lng: 128.6014, status: 'warning', name: '대구 시청 리더기' },
    { id: 4, lat: 37.4563, lng: 126.7052, status: 'active', name: '인천 시청 리더기' },
    { id: 5, lat: 35.1595, lng: 126.8526, status: 'inactive', name: '광주 시청 리더기' },
];

export default function EmsMap() {
    return (
        <MapContainer
            center={[36.5, 127.5]}
            zoom={7}
            style={{ height: '100%', width: '100%', background: '#0A0A0A' }}
        >
            <TileLayer
                attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>'
                url="https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
            />
            {readers.map(reader => (
                <Marker
                    key={reader.id}
                    position={[reader.lat, reader.lng]}
                    icon={customIcon}
                >
                    <Popup className="glass-panel text-black">
                        <div className="p-2">
                            <h3 className="font-bold">{reader.name}</h3>
                            <p>상태: <span className={
                                reader.status === 'active' ? 'text-green-600' :
                                    reader.status === 'warning' ? 'text-yellow-600' : 'text-red-600'
                            }>{reader.status.toUpperCase()}</span></p>
                        </div>
                    </Popup>
                </Marker>
            ))}
        </MapContainer>
    );
}
