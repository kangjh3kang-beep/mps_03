# Manpasik Ecosystem 통합 테스트 실행 스크립트
# PowerShell 스크립트

Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "만파식적 생태계 통합 테스트" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan

# 서비스 상태 확인 함수
function Test-ServiceHealth {
    param (
        [string]$Name,
        [string]$Url
    )
    
    try {
        $response = Invoke-WebRequest -Uri $Url -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Write-Host "  ✅ $Name" -ForegroundColor Green -NoNewline
            Write-Host " - 정상" -ForegroundColor Green
            return $true
        }
    }
    catch {
        Write-Host "  ❌ $Name" -ForegroundColor Red -NoNewline
        Write-Host " - 연결 실패" -ForegroundColor Red
        return $false
    }
    return $false
}

Write-Host ""
Write-Host "1. 서비스 헬스체크" -ForegroundColor Yellow
Write-Host "-" * 40

$services = @{
    "Auth Service" = "http://localhost:8001/health"
    "Measurement Service" = "http://localhost:8002/api/health"
    "AI Service" = "http://localhost:3003/health"
    "Payment Service" = "http://localhost:3004/health"
    "Notification Service" = "http://localhost:3005/health"
    "Video Service" = "http://localhost:3006/health"
    "Translation Service" = "http://localhost:3007/health"
    "Data Service" = "http://localhost:3008/health"
    "Admin Service" = "http://localhost:3009/health"
    "API Gateway" = "http://localhost:8080/health"
}

$successCount = 0
$totalCount = $services.Count

foreach ($service in $services.GetEnumerator()) {
    if (Test-ServiceHealth -Name $service.Key -Url $service.Value) {
        $successCount++
    }
}

Write-Host ""
Write-Host "2. API 기능 테스트" -ForegroundColor Yellow
Write-Host "-" * 40

# 회원가입 테스트
try {
    $timestamp = [DateTimeOffset]::Now.ToUnixTimeSeconds()
    $signupBody = @{
        email = "test_$timestamp@example.com"
        password = "TestPassword123!"
        name = "테스트사용자"
    } | ConvertTo-Json

    $signupResponse = Invoke-RestMethod -Uri "http://localhost:8001/api/auth/signup" `
        -Method POST `
        -ContentType "application/json" `
        -Body $signupBody `
        -ErrorAction Stop
    
    if ($signupResponse.success) {
        Write-Host "  ✅ 회원가입 API - 정상" -ForegroundColor Green
        $token = $signupResponse.token
        
        # 측정 데이터 저장 테스트
        $measurementBody = @{
            type = "glucose"
            value = 98
            unit = "mg/dL"
        } | ConvertTo-Json
        
        try {
            $measureResponse = Invoke-RestMethod -Uri "http://localhost:8002/api/measurements" `
                -Method POST `
                -ContentType "application/json" `
                -Headers @{ Authorization = "Bearer $token" } `
                -Body $measurementBody `
                -ErrorAction Stop
            
            Write-Host "  ✅ 측정 데이터 저장 - 정상" -ForegroundColor Green
        }
        catch {
            Write-Host "  ⚠️ 측정 데이터 저장 - 인증 필요" -ForegroundColor Yellow
        }
    }
}
catch {
    Write-Host "  ⚠️ 회원가입 API - 서비스 확인 필요" -ForegroundColor Yellow
}

# AI 코칭 테스트
try {
    $aiBody = @{
        glucose = 105
        systolic = 125
        diastolic = 82
        heart_rate = 75
        oxygen_saturation = 97
    } | ConvertTo-Json

    $aiResponse = Invoke-RestMethod -Uri "http://localhost:3003/api/coaching/recommendations" `
        -Method POST `
        -ContentType "application/json" `
        -Body $aiBody `
        -ErrorAction Stop
    
    if ($aiResponse.recommendations) {
        Write-Host "  ✅ AI 코칭 API - 정상" -ForegroundColor Green
    }
}
catch {
    Write-Host "  ⚠️ AI 코칭 API - 서비스 확인 필요" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "테스트 결과: $successCount/$totalCount 서비스 정상 작동" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan

if ($successCount -eq $totalCount) {
    Write-Host "🎉 모든 서비스가 정상 작동합니다!" -ForegroundColor Green
} else {
    Write-Host "⚠️ 일부 서비스가 시작되지 않았습니다." -ForegroundColor Yellow
    Write-Host "   docker-compose logs 명령으로 로그를 확인하세요." -ForegroundColor Yellow
}

