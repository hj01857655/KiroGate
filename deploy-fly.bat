@echo off
REM Fly.io 部署脚本 (Windows)

echo ===================================
echo   KiroGate Fly.io 部署脚本
echo ===================================

REM 1. 检查 fly 是否安装
where fly >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Fly CLI 未安装
    echo 请运行: powershell -Command "iwr https://fly.io/install.ps1 -useb | iex"
    pause
    exit /b 1
)

echo ✅ Fly CLI 已安装

REM 2. 检查是否登录
fly auth whoami >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ 未登录 Fly.io
    echo 请运行: fly auth login
    pause
    exit /b 1
)

echo ✅ 已登录 Fly.io

REM 3. 创建应用（如果不存在）
fly apps list | findstr "kirogate" >nul 2>nul
if %errorlevel% neq 0 (
    echo 📦 创建应用 kirogate...
    fly apps create kirogate --org personal
)

REM 4. 创建持久化卷（如果不存在）
fly volumes list -a kirogate | findstr "kirogate_data" >nul 2>nul
if %errorlevel% neq 0 (
    echo 💾 创建持久化卷...
    fly volumes create kirogate_data --region nrt --size 1 -a kirogate
)

REM 5. 设置环境变量
echo.
echo ⚙️  配置环境变量
echo 请输入以下配置（直接回车跳过）：

set /p PROXY_API_KEY="PROXY_API_KEY (代理密码): "
set /p REFRESH_TOKEN="REFRESH_TOKEN (Kiro Token): "
set /p ADMIN_PASSWORD="ADMIN_PASSWORD (管理员密码): "
set /p ADMIN_SECRET_KEY="ADMIN_SECRET_KEY (Session 密钥): "

if not "%PROXY_API_KEY%"=="" (
    fly secrets set PROXY_API_KEY="%PROXY_API_KEY%" -a kirogate
)

if not "%REFRESH_TOKEN%"=="" (
    fly secrets set REFRESH_TOKEN="%REFRESH_TOKEN%" -a kirogate
)

if not "%ADMIN_PASSWORD%"=="" (
    fly secrets set ADMIN_PASSWORD="%ADMIN_PASSWORD%" -a kirogate
)

if not "%ADMIN_SECRET_KEY%"=="" (
    fly secrets set ADMIN_SECRET_KEY="%ADMIN_SECRET_KEY%" -a kirogate
)

REM 6. 部署
echo.
echo 🚀 开始部署...
fly deploy -a kirogate

echo.
echo ===================================
echo   部署完成！
echo ===================================
echo 访问地址: https://kirogate.fly.dev
echo 查看日志: fly logs -a kirogate
echo 查看状态: fly status -a kirogate
pause
