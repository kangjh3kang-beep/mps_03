const { createClient } = require('@supabase/supabase-js');

// Supabase 접속 정보 (사용자님의 프로젝트 정보)
const supabaseUrl = 'https://ekzytlhdggejhhhmfznw.supabase.co';
// 주의: 사용자 생성을 위해서는 'service_role' 키가 필요합니다. 
// 이 키는 절대 외부에 노출되지 않도록 주의하세요.
const supabaseServiceKey = 'sb_secret_B6QEp8DQK6ZWJ24TE-TrJw_oKXJGl4F';

const supabase = createClient(supabaseUrl, supabaseServiceKey, {
    auth: {
        autoRefreshToken: false,
        persistSession: false
    }
});

async function createTestUser(email, password) {
    console.log(`Attempting to create user: ${email}...`);

    const { data, error } = await supabase.auth.admin.createUser({
        email: email,
        password: password,
        email_confirm: true // 이메일 인증 절차 건너뛰기
    });

    if (error) {
        console.error('Error creating user:', error.message);
    } else {
        console.log('Successfully created user!');
        console.log('User ID:', data.user.id);
    }
}

// 테스트용 계정 정보 (원하시는 대로 수정하세요)
const testEmail = 'kangjh3kang@naver.com';
const testPassword = 'k3j3h3g3f3!';

createTestUser(testEmail, testPassword);
