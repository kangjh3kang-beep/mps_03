import { SignalProcessor } from './signal-processor';
import { CartridgeInfo, MeasurementResult, ReaderConfig, SignalPacket } from './types';

/**
 * ReaderSDK: Main interface for interacting with Manpasik hardware readers.
 */
export class ReaderSDK {
    private processor: SignalProcessor;
    private isConnected: boolean = false;
    private config: ReaderConfig;

    constructor(config?: ReaderConfig) {
        this.config = config || {
            samplingRate: 100,
            gain: 1.0,
            offset: 0,
            filterType: 'KALMAN',
            threshold: 0.5
        };
        this.processor = new SignalProcessor();
    }

    /**
     * Mock WebBluetooth connection.
     */
    public async connect(): Promise<boolean> {
        console.log('Connecting to Manpasik Reader via WebBluetooth...');
        return new Promise((resolve) => {
            setTimeout(() => {
                this.isConnected = true;
                console.log('Connected to Reader.');
                resolve(true);
            }, 1500);
        });
    }

    /**
     * Start data acquisition.
     */
    public startMeasurement(cartridge: CartridgeInfo, onData: (result: MeasurementResult) => void) {
        if (!this.isConnected) throw new Error('Reader not connected');

        console.log(`Starting measurement with cartridge: ${cartridge.id}`);

        // Simulate real-time data stream
        const interval = setInterval(() => {
            const mockSensing = 2.5 + Math.random() * 0.1;
            const mockReference = 2.4 + Math.random() * 0.05;

            const diffSignal = this.processor.calculateDifferentialSignal(
                mockSensing,
                mockReference,
                cartridge.calibrationFactor
            );

            const result: MeasurementResult = {
                timestamp: Date.now(),
                rawValue: mockSensing,
                processedValue: diffSignal * 100, // Scale for display
                differentialSignal: diffSignal,
                unit: 'mg/dL',
                confidenceScore: 0.95 + Math.random() * 0.04,
                isStable: true
            };

            onData(result);
        }, 1000 / this.config.samplingRate);

        return () => clearInterval(interval);
    }

    public disconnect() {
        this.isConnected = false;
        console.log('Disconnected from Reader.');
    }
}
