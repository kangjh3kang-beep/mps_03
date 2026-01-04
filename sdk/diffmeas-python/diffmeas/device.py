"""
디바이스 관리 모듈
BLE/NFC 디바이스 검색, 연결, 관리
"""

import asyncio
import logging
from typing import Optional, List, Callable
from dataclasses import dataclass
from enum import Enum

logger = logging.getLogger(__name__)


class DeviceType(Enum):
    """디바이스 타입"""
    BLE = "ble"
    NFC = "nfc"
    USB = "usb"


class ConnectionState(Enum):
    """연결 상태"""
    DISCONNECTED = "disconnected"
    SCANNING = "scanning"
    CONNECTING = "connecting"
    CONNECTED = "connected"
    DISCONNECTING = "disconnecting"
    ERROR = "error"


@dataclass
class Device:
    """디바이스 정보"""
    id: str
    name: str
    type: DeviceType
    rssi: int = 0
    firmware_version: Optional[str] = None
    serial_number: Optional[str] = None
    battery_level: Optional[int] = None
    
    @property
    def is_low_battery(self) -> bool:
        """배터리 부족 여부"""
        return self.battery_level is not None and self.battery_level < 20
    
    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "name": self.name,
            "type": self.type.value,
            "rssi": self.rssi,
            "firmware_version": self.firmware_version,
            "serial_number": self.serial_number,
            "battery_level": self.battery_level,
        }


class DeviceManager:
    """
    디바이스 관리자
    BLE/NFC 디바이스 검색 및 연결 관리
    """
    
    def __init__(self, config):
        self._config = config
        self._state = ConnectionState.DISCONNECTED
        self._connected_device: Optional[Device] = None
        self._discovered_devices: List[Device] = []
        self._on_connection_change: Optional[Callable[[bool], None]] = None
    
    @property
    def state(self) -> ConnectionState:
        """현재 연결 상태"""
        return self._state
    
    @property
    def is_connected(self) -> bool:
        """연결 여부"""
        return self._state == ConnectionState.CONNECTED
    
    @property
    def connected_device(self) -> Optional[Device]:
        """연결된 디바이스"""
        return self._connected_device
    
    @property
    def on_connection_change(self) -> Optional[Callable[[bool], None]]:
        return self._on_connection_change
    
    @on_connection_change.setter
    def on_connection_change(self, callback: Callable[[bool], None]):
        self._on_connection_change = callback
    
    async def scan(
        self,
        timeout: float = 10.0,
        device_type: Optional[DeviceType] = None,
    ) -> List[Device]:
        """
        디바이스 검색
        
        Args:
            timeout: 검색 시간(초)
            device_type: 검색할 디바이스 타입 (None이면 전체)
            
        Returns:
            발견된 디바이스 목록
        """
        logger.info(f"Starting device scan (timeout: {timeout}s)")
        self._state = ConnectionState.SCANNING
        self._discovered_devices.clear()
        
        try:
            # 시뮬레이션: 실제로는 bleak 라이브러리 사용
            await asyncio.sleep(2.0)
            
            # Mock 디바이스
            self._discovered_devices = [
                Device(
                    id="DIFFMEAS-001",
                    name="DiffMeas Pro",
                    type=DeviceType.BLE,
                    rssi=-45,
                    firmware_version="2.1.0",
                    battery_level=85,
                ),
                Device(
                    id="DIFFMEAS-002",
                    name="DiffMeas Mini",
                    type=DeviceType.BLE,
                    rssi=-62,
                    firmware_version="2.0.5",
                    battery_level=60,
                ),
            ]
            
            if device_type:
                self._discovered_devices = [
                    d for d in self._discovered_devices
                    if d.type == device_type
                ]
            
            logger.info(f"Found {len(self._discovered_devices)} devices")
            return self._discovered_devices
            
        finally:
            self._state = ConnectionState.DISCONNECTED
    
    async def connect(self, device: Device) -> bool:
        """
        디바이스 연결
        
        Args:
            device: 연결할 디바이스
            
        Returns:
            연결 성공 여부
        """
        if self.is_connected:
            await self.disconnect()
        
        logger.info(f"Connecting to {device.name}...")
        self._state = ConnectionState.CONNECTING
        
        try:
            # 연결 시뮬레이션
            await asyncio.sleep(1.5)
            
            self._connected_device = device
            self._state = ConnectionState.CONNECTED
            
            if self._on_connection_change:
                self._on_connection_change(True)
            
            logger.info(f"Connected to {device.name}")
            return True
            
        except Exception as e:
            self._state = ConnectionState.ERROR
            logger.error(f"Connection failed: {e}")
            return False
    
    async def disconnect(self) -> bool:
        """
        디바이스 연결 해제
        
        Returns:
            연결 해제 성공 여부
        """
        if not self.is_connected:
            return True
        
        device_name = self._connected_device.name if self._connected_device else "Unknown"
        logger.info(f"Disconnecting from {device_name}...")
        self._state = ConnectionState.DISCONNECTING
        
        try:
            await asyncio.sleep(0.5)
            
            self._connected_device = None
            self._state = ConnectionState.DISCONNECTED
            
            if self._on_connection_change:
                self._on_connection_change(False)
            
            logger.info("Disconnected")
            return True
            
        except Exception as e:
            self._state = ConnectionState.ERROR
            logger.error(f"Disconnect failed: {e}")
            return False
    
    async def get_device_info(self) -> Optional[dict]:
        """연결된 디바이스 정보 조회"""
        if not self.is_connected or not self._connected_device:
            return None
        
        return self._connected_device.to_dict()
    
    async def get_battery_level(self) -> Optional[int]:
        """배터리 잔량 조회"""
        if not self.is_connected or not self._connected_device:
            return None
        
        # 시뮬레이션
        return self._connected_device.battery_level

