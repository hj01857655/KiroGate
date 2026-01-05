@echo off
REM Docker 本地部署脚本

echo ===================================
echo   KiroGate Docker 本地部署
echo ===================================

REM 检查 Docker 是否安装
docker --version >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Docker 未安装
    echo 请先安装 Docker Desktop: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

echo ✅ Docker 已安装

REM 检查 .env 文件
if not exist .env (
    echo ❌ .env 文件不存在
    echo 请先复制 .env.example 为 .env 并配置
    pause
    exit /b 1
)

echo ✅ .env 文件存在

REM 停止旧容器
echo 🛑 停止旧容器...
docker-compose down

REM 构建并启动
echo 🚀 构建并启动服务...
docker-compose up -d --build

REM 等待服务启动
echo ⏳ 等待服务启动...
timeout /t 5 /nobreak >nul

REM 检查状态
docker-compose ps

echo.
echo ===================================
echo   部署完成！
echo ===================================
echo 访问地址: http://localhost:8000
echo 查看日志: docker-compose logs -f
echo 停止服务: docker-compose down
pause
