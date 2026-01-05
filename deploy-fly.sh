#!/bin/bash
# Fly.io 部署脚本

echo "==================================="
echo "  KiroGate Fly.io 部署脚本"
echo "==================================="

# 1. 检查 fly 是否安装
if ! command -v fly &> /dev/null; then
    echo "❌ Fly CLI 未安装"
    echo "请运行: curl -L https://fly.io/install.sh | sh"
    exit 1
fi

echo "✅ Fly CLI 已安装"

# 2. 检查是否登录
if ! fly auth whoami &> /dev/null; then
    echo "❌ 未登录 Fly.io"
    echo "请运行: fly auth login"
    exit 1
fi

echo "✅ 已登录 Fly.io"

# 3. 检查应用是否存在
if ! fly apps list | grep -q "kirogate"; then
    echo "📦 创建应用 kirogate..."
    fly apps create kirogate --org personal
fi

# 4. 检查卷是否存在
if ! fly volumes list -a kirogate | grep -q "kirogate_data"; then
    echo "💾 创建持久化卷..."
    fly volumes create kirogate_data --region nrt --size 1 -a kirogate
fi

# 5. 设置环境变量
echo ""
echo "⚙️  配置环境变量"
echo "请输入以下配置（直接回车跳过）："

read -p "PROXY_API_KEY (代理密码): " PROXY_API_KEY
read -p "REFRESH_TOKEN (Kiro Token): " REFRESH_TOKEN
read -p "ADMIN_PASSWORD (管理员密码): " ADMIN_PASSWORD
read -p "ADMIN_SECRET_KEY (Session 密钥): " ADMIN_SECRET_KEY

if [ ! -z "$PROXY_API_KEY" ]; then
    fly secrets set PROXY_API_KEY="$PROXY_API_KEY" -a kirogate
fi

if [ ! -z "$REFRESH_TOKEN" ]; then
    fly secrets set REFRESH_TOKEN="$REFRESH_TOKEN" -a kirogate
fi

if [ ! -z "$ADMIN_PASSWORD" ]; then
    fly secrets set ADMIN_PASSWORD="$ADMIN_PASSWORD" -a kirogate
fi

if [ ! -z "$ADMIN_SECRET_KEY" ]; then
    fly secrets set ADMIN_SECRET_KEY="$ADMIN_SECRET_KEY" -a kirogate
fi

# 6. 部署
echo ""
echo "🚀 开始部署..."
fly deploy -a kirogate

echo ""
echo "==================================="
echo "  部署完成！"
echo "==================================="
echo "访问地址: https://kirogate.fly.dev"
echo "查看日志: fly logs -a kirogate"
echo "查看状态: fly status -a kirogate"
