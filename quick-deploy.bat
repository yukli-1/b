@echo off
echo 🚀 开始快速部署...

echo 📦 安装依赖...
npm install

echo 🏗️ 构建项目...
npm run build

echo 📝 提交代码...
git add .
git commit -m "🚀 Quick deploy - %date% %time%"
git push origin main

echo ✅ 部署完成！
pause