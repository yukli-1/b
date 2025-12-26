# 🔧 手动部署指南

## 当前状态
✅ 代码已本地提交到Git仓库  
✅ 部署脚本已创建完成  
❌ 需要配置远程仓库并推送代码  

## 🚀 手动部署步骤

### 1. 配置Git用户信息（如果尚未配置）
```bash
git config user.email "your-email@example.com"
git config user.name "Your Name"
```

### 2. 添加远程仓库
```bash
git remote add origin https://github.com/yukli-1/b.git
```

### 3. 推送代码到GitHub
```bash
git push -u origin main
```

### 4. 在GitHub上启用Pages
1. 访问您的仓库：https://github.com/yukli-1/b
2. 点击 Settings (设置)
3. 在左侧菜单找到 Pages
4. Source 选择 "GitHub Actions"

### 5. 部署完成后访问地址
```
https://yukli-1.github.io/b/
```

## 📝 使用部署脚本

如果npm权限问题解决后，可以直接运行：

### Windows PowerShell
```powershell
.\deploy.ps1
```

### Windows CMD
```cmd
.\deploy.bat
```

### 快速部署
```cmd
.\quick-deploy.bat
```

## ⚠️ 常见问题

### npm权限问题
```cmd
# 清理npm缓存
npm cache clean --force

# 或者使用管理员权限运行
```

### Git推送问题
```cmd
# 如果推送失败，强制推送（谨慎使用）
git push -f origin main

# 或者检查分支名称
git branch -a
```

## 🎯 自动化部署特性

一旦GitHub Actions设置完成，每次推送代码到main分支时：
- ✅ 自动运行测试
- ✅ 自动构建项目
- ✅ 自动部署到GitHub Pages
- ✅ 自动更新网站

## 📊 项目部署状态监控

访问以下链接监控部署状态：
```
https://github.com/yukli-1/b/actions
```