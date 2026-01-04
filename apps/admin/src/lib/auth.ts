import { supabase } from './supabase';

// Mock Auth Service for Phase 2
export const authService = {
    async login(email: string, password: string) {
        // Simulate network delay
        await new Promise(resolve => setTimeout(resolve, 1000));

        if (email === 'admin@manpasik.com' && password === 'admin123') {
            return {
                user: {
                    id: 'admin_001',
                    email: email,
                    role: 'admin',
                    name: '최고 관리자'
                },
                session: {
                    access_token: 'mock_admin_token_xyz',
                    expires_at: Date.now() + 3600 * 1000
                }
            };
        }

        throw new Error('Invalid credentials');
    },

    async logout() {
        await supabase.auth.signOut();
        // Clear local storage if any
    },

    async getSession() {
        // In a real app, check Supabase session
        // For now, return mock if cookie exists (simplified)
        return null;
    }
};
