import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || 'https://ekzytlhdggejhhhmfznw.supabase.co';
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || 'sb_publishable_IzgXxLME7nu71IDB0ESc3A_F983TXqA';

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
