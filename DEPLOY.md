# 🚀 一键部署脚本使用说明

本项目提供了三种不同平台的一键部署脚本，可以自动化完成代码构建、Git提交、推送到远程仓库以及触发GitHub Actions部署的完整流程。

## 📁 脚本文件说明

| 脚本文件 | 适用平台 | 使用方法 | 特性 |
|---------|---------|---------|------|
| `deploy.sh` | Linux/macOS | `./deploy.sh` | 完整的Bash脚本，支持彩色输出和详细日志 |
| `deploy.bat` | Windows (CMD) | `deploy.bat` | Windows批处理脚本，兼容所有Windows版本 |
| `deploy.ps1` | Windows (PowerShell) | `.\deploy.ps1` | PowerShell脚本，支持更多高级参数 |

## 🎯 脚本功能

### 🔍 环境检查
- 自动检测 Node.js、npm、Git 是否已安装
- 显示版本信息，确保环境配置正确

### 📦 项目管理
- 自动安装项目依赖（如果 node_modules 不存在）
- 可选的代码质量检查（ESLint）
- 构建前的准备工作

### 🏗️ 自动构建
- 清理旧的构建文件
- 执行 `npm run build` 命令
- 检查构建结果和文件统计

### 🔄 Git 操作
- 检查未提交的代码更改
- 自动添加和提交更改
- 推送到指定的远程分支
- 支持分支切换和合并

### 📊 状态报告
- 详细的部署日志
- 构建统计信息
- GitHub Actions 部署状态检查
- 部署完成后的访问链接

## 🚀 快速使用

### Windows 用户（推荐使用 PowerShell）

```powershell
# 基础部署
.\deploy.ps1

# 跳过代码检查
.\deploy.ps1 -SkipLint

# 跳过Git检查（仅构建）
.\deploy.ps1 -SkipGitCheck

# 自定义提交信息
.\deploy.ps1 -CommitMessage "修复了登录问题"
```

### Windows 用户（CMD）

```cmd
# 双击运行或在CMD中执行
deploy.bat
```

### Linux/macOS 用户

```bash
# 给脚本执行权限
chmod +x deploy.sh

# 运行脚本
./deploy.sh
```

## 📋 部署前检查清单

1. **Git 配置**
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

2. **GitHub 仓库配置**
   - 确保本地仓库已连接到远程仓库
   - GitHub Pages 功能已启用
   - GitHub Actions 工作流已配置

3. **项目配置**
   - `package.json` 包含正确的构建脚本
   - `vite.config.js` 配置正确
   - 依赖包已完整安装

## 🔧 自定义配置

您可以根据需要修改脚本中的配置变量：

```bash
# 项目名称
PROJECT_NAME="vue-tech-blog"

# 构建目录
BUILD_DIR="dist"

# 目标分支
GITHUB_BRANCH="main"

# 远程仓库名称
REMOTE_ORIGIN="origin"
```

## ⚡ 部署流程说明

1. **环境验证** → 检查必要的开发工具
2. **项目检查** → 验证项目结构和配置
3. **依赖管理** → 安装或更新项目依赖
4. **代码质量** → 运行 ESLint 检查（可选）
5. **Git 操作** → 提交本地更改（如果需要）
6. **项目构建** → 执行生产构建
7. **结果验证** → 检查构建输出
8. **代码推送** → 推送到远程仓库
9. **CI/CD 触发** → 自动触发 GitHub Actions
10. **部署报告** → 显示部署结果和访问链接

## 🌐 部署结果

部署成功后，您的网站将在以下地址可访问：

```
https://[您的GitHub用户名].github.io/[项目名称]/
```

例如：
```
https://johnsmith.github.io/vue-tech-blog/
```

## ❗ 常见问题

### Q: 脚本执行权限错误？
**A:** Linux/macOS 用户需要先给脚本添加执行权限：
```bash
chmod +x deploy.sh
```

### Q: Git 推送失败？
**A:** 检查网络连接和 Git 配置：
```bash
git remote -v
git config --list
```

### Q: 构建失败？
**A:** 查看构建错误信息，通常是由于：
- 依赖包版本冲突
- 代码语法错误
- 配置文件问题

### Q: GitHub Actions 没有触发？
**A:** 确保：
- `.github/workflows/` 目录下有配置文件
- 推送到了正确的分支
- GitHub 仓库启用了 Actions 功能

## 📞 技术支持

如果遇到问题，请检查：
1. 脚本输出的错误信息
2. 项目控制台的错误日志
3. GitHub Actions 的执行日志
4. 网络连接状态

---

💡 **提示：** 首次使用建议先在小分支上测试，确保一切正常后再合并到主分支进行生产部署。