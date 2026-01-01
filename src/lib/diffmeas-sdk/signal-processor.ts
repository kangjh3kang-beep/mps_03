import { SignalPacket } from './types';

/**
 * SignalProcessor: Ports C-based signal processing logic to TypeScript.
 * Implements Kalman Filter and Differential Signal Calculation.
 */
export class SignalProcessor {
    private q: number = 0.01; // Process noise covariance
    private r: number = 0.1;  // Measurement noise covariance
    private x: number = 0;    // Estimated value
    private p: number = 1;    // Estimation error covariance
    private k: number = 0;    // Kalman gain

    constructor(q?: number, r?: number) {
        if (q) this.q = q;
        if (r) this.r = r;
    }

    /**
     * Kalman Filter implementation for noise reduction.
     */
    public kalmanUpdate(measurement: number): number {
        // Prediction update
        this.p = this.p + this.q;

        // Measurement update
        this.k = this.p / (this.p + this.r);
        this.x = this.x + this.k * (measurement - this.x);
        this.p = (1 - this.k) * this.p;

        return this.x;
    }

    /**
     * Simple Moving Average (SMA) filter.
     */
    public movingAverage(data: number[], windowSize: number): number {
        if (data.length === 0) return 0;
        const window = data.slice(-windowSize);
        const sum = window.reduce((acc, val) => acc + val, 0);
        return sum / window.length;
    }

    /**
     * Calculates the differential signal between sensing and reference channels.
     * Formula: (Sensing - Reference) / Reference * CalibrationFactor
     */
    public calculateDifferentialSignal(sensing: number, reference: number, calibrationFactor: number = 1.0): number {
        if (reference === 0) return 0;

        // Apply Kalman filtering to both signals before calculation
        const filteredSensing = this.kalmanUpdate(sensing);
        const filteredReference = this.kalmanUpdate(reference);

        return ((filteredSensing - filteredReference) / filteredReference) * calibrationFactor;
    }

    /**
     * Process a full signal packet.
     */
    public processPacket(packet: SignalPacket, calibrationFactor: number): number {
        return this.calculateDifferentialSignal(packet.sensing, packet.reference, calibrationFactor);
    }
}
