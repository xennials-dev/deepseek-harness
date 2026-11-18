# DeepSeek Harness + Local LLM Starter
Write-Host "Checking LM Studio..." -ForegroundColor Cyan
if (-not (Get-Process -Name "LM Studio" -ErrorAction SilentlyContinue)) {
    Write-Host "Launching LM Studio..." -ForegroundColor Yellow
    Start-Process "C:\Users\tee\AppData\Local\Programs\LM Studio\LM Studio.exe"
} else {
    Write-Host "LM Studio is already running." -ForegroundColor Green
}

Write-Host "Checking Local Failover Proxy (Port 11435)..." -ForegroundColor Cyan
try {
    $null = Invoke-RestMethod -Uri "http://127.0.0.1:11435/v1/models" -TimeoutSec 2 -ErrorAction Stop
    Write-Host "Failover proxy is active." -ForegroundColor Green
} catch {
    Write-Host "Starting Failover Proxy daemon..." -ForegroundColor Yellow
    Start-Process -FilePath "node" -ArgumentList "C:\Users\tee\.dsh\local-llm-proxy.mjs" -WindowStyle Hidden
}

Write-Host "Starting DeepSeek Harness Web..." -ForegroundColor Cyan
$env:DEEPSEEK_BASE_URL = "http://127.0.0.1:11435/v1"
$env:DEEPSEEK_API_KEY = "lm-studio"
pnpm dsh web
