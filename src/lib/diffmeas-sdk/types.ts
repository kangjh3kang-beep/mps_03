/**
 * Manpasik DiffMeas SDK Type Definitions
 */

export interface CartridgeInfo {
    id: string;
    type: 'GLUCOSE' | 'LIPID' | 'PROTEIN' | 'CUSTOM';
    calibrationFactor: number;
    expiryDate: string;
    batchNumber: string;
}

export interface MeasurementResult {
    timestamp: number;
    rawValue: number;
    processedValue: number;
    differentialSignal: number;
    unit: string;
    confidenceScore: number;
    isStable: boolean;
}

export interface ReaderConfig {
    samplingRate: number; // Hz
    gain: number;
    offset: number;
    filterType: 'KALMAN' | 'MOVING_AVERAGE' | 'WAVELET';
    threshold: number;
}

export interface SignalPacket {
    sensing: number;
    reference: number;
    timestamp: number;
}
