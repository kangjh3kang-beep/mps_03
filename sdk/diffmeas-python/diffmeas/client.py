"""
DiffMeas Python Client
메인 클라이언트 클래스
"""

import asyncio
import logging
from typing import Optional, Callable, Any
from dataclasses import dataclass

from .device import DeviceManager
from .measurement import MeasurementHandler
from .exceptions import DiffMeasException, AuthenticationError

logger = logging.getLogger(__name__)


@dataclass
class ClientConfig:
    """클라이언트 설정"""
    api_key: str
    user_id: Optional[str] = None
    base_url: str = "https://api.manpasik.com"
    timeout: int = 30
    debug: bool = False
    auto_reconnect: bool = True
    reconnect_interval: int = 5


class DiffMeasClient:
    """
    DiffMeas SDK 메인 클라이언트
    
    사용 예시:
    ```python
    async with DiffMeasClient(api_key="your-api-key") as client:
        devices = await client.device_manager.scan()
        await client.device_manager.connect(devices[0])
        result = await client.measurement.measure(MeasurementType.GLUCOSE)
        print(f"혈당: {result.value} {result.unit}")
    ```
    """
    
    def __init__(
        self,
        api_key: str,
        user_id: Optional[str] = None,
        config: Optional[ClientConfig] = None,
    ):
        self._api_key = api_key
        self._user_id = user_id
        self._config = config or ClientConfig(api_key=api_key, user_id=user_id)
        self._initialized = False
        
        # 서브시스템
        self._device_manager: Optional[DeviceManager] = None
        self._measurement_handler: Optional[MeasurementHandler] = None
        
        # 콜백
        self._on_error: Optional[Callable[[Exception], None]] = None
        self._on_connection_change: Optional[Callable[[bool], None]] = None
        
        if self._config.debug:
            logging.basicConfig(level=logging.DEBUG)
    
    async def __aenter__(self):
        """비동기 컨텍스트 매니저 진입"""
        await self.initialize()
        return self
    
    async def __aexit__(self, exc_type, exc_val, exc_tb):
        """비동기 컨텍스트 매니저 종료"""
        await self.close()
    
    async def initialize(self) -> bool:
        """
        SDK 초기화
        
        Returns:
            bool: 초기화 성공 여부
        """
        if self._initialized:
            return True
        
        try:
            # API 키 검증
            if not self._api_key:
                raise AuthenticationError("API key is required")
            
            # 서브시스템 초기화
            self._device_manager = DeviceManager(self._config)
            self._measurement_handler = MeasurementHandler(
                self._device_manager,
                self._config,
            )
            
            self._initialized = True
            logger.info(f"DiffMeas SDK initialized (version {__import__('diffmeas').__version__})")
            return True
            
        except Exception as e:
            logger.error(f"Failed to initialize SDK: {e}")
            if self._on_error:
                self._on_error(e)
            raise DiffMeasException(f"Initialization failed: {e}") from e
    
    async def close(self):
        """SDK 종료 및 리소스 정리"""
        if not self._initialized:
            return
        
        try:
            if self._device_manager:
                await self._device_manager.disconnect()
            
            self._initialized = False
            logger.info("DiffMeas SDK closed")
            
        except Exception as e:
            logger.error(f"Error during shutdown: {e}")
    
    @property
    def device_manager(self) -> DeviceManager:
        """디바이스 관리자 접근"""
        if not self._initialized or not self._device_manager:
            raise DiffMeasException("SDK not initialized")
        return self._device_manager
    
    @property
    def measurement(self) -> MeasurementHandler:
        """측정 핸들러 접근"""
        if not self._initialized or not self._measurement_handler:
            raise DiffMeasException("SDK not initialized")
        return self._measurement_handler
    
    @property
    def is_connected(self) -> bool:
        """디바이스 연결 상태"""
        return (
            self._device_manager is not None and
            self._device_manager.is_connected
        )
    
    def on_error(self, callback: Callable[[Exception], None]):
        """에러 콜백 등록"""
        self._on_error = callback
    
    def on_connection_change(self, callback: Callable[[bool], None]):
        """연결 상태 변경 콜백 등록"""
        self._on_connection_change = callback
        if self._device_manager:
            self._device_manager.on_connection_change = callback

