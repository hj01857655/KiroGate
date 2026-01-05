# Fly.io 部署指南

## 第一步：注册 Fly.io 账号

1. 访问 https://fly.io/app/sign-up
2. 使用 GitHub 账号登录（推荐）
3. 绑定信用卡（免费额度足够用，不会扣费）

---

## 第二步：获取 Fly.io API Token

1. 访问 https://fly.io/dashboard
2. 点击右上角头像 → **Account Settings**
3. 左侧菜单找到 **Access Tokens**
4. 点击 **Create Token**
5. 名称填：`GitHub Actions`
6. 复制生成的 Token（只显示一次，记得保存）

---

## 第三步：在 GitHub 设置 Secrets

1. 打开仓库：https://github.com/hj01857655/KiroGate_dev
2. 点击 **Settings** → **Secrets and variables** → **Actions**
3. 点击 **New repository secret**，依次添加：

### 必填 Secrets

| Name | Value | 说明 |
|------|-------|------|
| `FLY_API_TOKEN` | 刚才复制的 Token | Fly.io 部署凭证 |
| `PROXY_API_KEY` | 你的密码 | API 访问密码 |
| `REFRESH_TOKEN` | 你的 Kiro Token | 从 Kiro IDE 获取 |

### 可选 Secrets

| Name | Value | 说明 |
|------|-------|------|
| `ADMIN_PASSWORD` | 管理员密码 | 默认 admin123 |
| `ADMIN_SECRET_KEY` | 随机字符串 | Session 签名密钥 |

---

## 第四步：修改 fly.toml 配置

需要在 Fly.io 创建应用后才能部署。我帮你准备好了配置。

---

## 第五步：首次部署

### 方式一：使用 GitHub Actions（推荐）

1. 确保已添加所有 Secrets
2. 推送代码到 main 分支会自动部署
3. 查看部署进度：https://github.com/hj01857655/KiroGate_dev/actions

### 方式二：手动创建应用

如果 GitHub Actions 失败，需要先手动创建应用：

1. 访问 https://fly.io/dashboard
2. 点击 **Create App**
3. 应用名填：`kirogate`（或其他名字）
4. 区域选：`Tokyo (nrt)`
5. 创建后，修改 `fly.toml` 第一行的 `app = "kirogate"` 为你的应用名
6. 推送代码重新触发部署

---

## 第六步：配置环境变量

部署成功后，在 Fly.io Dashboard 设置环境变量：

1. 打开应用：https://fly.io/apps/kirogate
2. 点击 **Secrets**
3. 添加环境变量（与 GitHub Secrets 相同）

---

## 第七步：访问服务

部署成功后访问：`https://kirogate.fly.dev`

如果应用名不是 kirogate，访问：`https://你的应用名.fly.dev`

---

## 常用命令（可选）

如果安装了 Fly CLI，可以使用：

```bash
# 查看日志
fly logs -a kirogate

# 查看状态
fly status -a kirogate

# 重启应用
fly apps restart kirogate

# 查看环境变量
fly secrets list -a kirogate
```

---

## 故障排查

### 1. 部署失败

查看 GitHub Actions 日志：
https://github.com/hj01857655/KiroGate_dev/actions

### 2. 应用不存在

需要先在 Fly.io Dashboard 手动创建应用。

### 3. 环境变量未生效

确保在 Fly.io Dashboard 的 Secrets 中添加了所有必需的环境变量。

---

## 费用说明

Fly.io 免费额度：
- 3 个共享 CPU 虚拟机
- 3GB 持久化存储
- 160GB 出站流量/月

**本项目配置（256MB 内存）完全在免费额度内，不会产生费用。**
