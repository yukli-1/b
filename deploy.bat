@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ======================================
:: 🚀 一键部署脚本 (Windows版)
:: 🎯 功能：自动化构建、提交、推送并部署到GitHub Pages
:: ======================================

:: 配置变量
set "PROJECT_NAME=vue-tech-blog"
set "BUILD_DIR=dist"
set "GITHUB_BRANCH=main"
set "REMOTE_ORIGIN=origin"

:: 颜色定义 (Windows CMD)
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "PURPLE=[95m"
set "CYAN=[96m"
set "WHITE=[97m"
set "NC=[0m"

:: 函数：打印消息
:print_message
echo %~1[%time:~0,8%] %~2%NC%
goto :eof

:: 函数：打印标题
:print_header
echo.
echo %CYAN%================================%NC%
echo %WHITE%%~1%NC%
echo %CYAN%================================%NC%
echo.
goto :eof

:: 函数：检查命令是否存在
:check_command
where %~1 >nul 2>&1
if errorlevel 1 (
    call :print_message %RED% "❌ 错误：未找到 %~1 命令，请先安装"
    pause
    exit /b 1
)
goto :eof

:: 函数：确认操作
:confirm
set /p "response=%YELLOW%❓ %~1 [y/N]: %NC%"
if /i "%response%"=="y" goto :eof
if /i "%response%"=="yes" goto :eof
exit /b 1

:: 主部署流程
:main
call :print_header "🚀 开始一键部署流程"

:: 1. 环境检查
call :print_message %BLUE% "🔍 检查环境依赖..."
call :check_command node
call :check_command npm
call :check_command git

:: 获取版本信息
for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
for /f "tokens=*" %%i in ('npm --version') do set NPM_VERSION=%%i
for /f "tokens=*" %%i in ('git --version') do set GIT_VERSION=%%i

call :print_message %GREEN% "✅ Node.js: !NODE_VERSION!"
call :print_message %GREEN% "✅ npm: !NPM_VERSION!"
call :print_message %GREEN% "✅ Git: !GIT_VERSION!"

:: 2. 项目检查
call :print_message %BLUE% "📁 检查项目配置..."

if not exist "package.json" (
    call :print_message %RED% "❌ 错误：未找到 package.json 文件"
    pause
    exit /b 1
)

if not exist ".git" (
    call :print_message %RED% "❌ 错误：这不是一个 Git 仓库"
    call :print_message %YELLOW% "💡 请先运行：git init"
    pause
    exit /b 1
)

call :print_message %GREEN% "✅ 项目配置检查通过"

:: 3. 依赖检查和安装
call :print_message %BLUE% "📦 检查项目依赖..."

if not exist "node_modules" (
    call :print_message %YELLOW% "🔧 安装项目依赖..."
    npm install
    if errorlevel 1 (
        call :print_message %RED% "❌ 依赖安装失败"
        pause
        exit /b 1
    )
    call :print_message %GREEN% "✅ 依赖安装完成"
) else (
    call :print_message %GREEN% "✅ 依赖已存在"
)

:: 4. 代码质量检查（可选）
echo %YELLOW%是否运行代码质量检查？(ESLint) [y/N]: %NC%
set /p "lint_confirm="
if /i "%lint_confirm%"=="y" goto run_lint
if /i "%lint_confirm%"=="yes" goto run_lint
goto git_check

:run_lint
call :print_message %BLUE% "🔍 运行代码质量检查..."
npm run lint
if errorlevel 1 (
    call :print_message %YELLOW% "⚠️ 代码检查发现问题，但继续部署..."
) else (
    call :print_message %GREEN% "✅ 代码质量检查通过"
)

:: 5. Git 状态检查
:git_check
call :print_message %BLUE% "🔄 检查 Git 状态..."

:: 检查是否有未提交的更改
git diff --quiet >nul 2>&1
git diff --cached --quiet >nul 2>&1
if errorlevel 1 (
    call :print_message %YELLOW% "⚠️ 发现未提交的更改"
    call :confirm "是否自动提交所有更改？"
    if not errorlevel 1 goto skip_commit
    
    call :print_message %BLUE% "📝 提交代码更改..."
    git add .
    
    :: 生成提交信息
    for /f "tokens=*" %%i in ('powershell -command "Get-Date -Format 'yyyy-MM-dd HH:mm:ss'"') do set TIMESTAMP=%%i
    set "COMMIT_MESSAGE=🚀 Auto deploy: !TIMESTAMP!"
    
    git commit -m "!COMMIT_MESSAGE!"
    if errorlevel 1 (
        call :print_message %RED% "❌ Git 提交失败"
        pause
        exit /b 1
    )
    call :print_message %GREEN% "✅ 代码提交完成"
) else (
    call :print_message %GREEN% "✅ 没有未提交的更改"
)

:skip_commit

:: 6. 构建项目
call :print_message %BLUE% "🏗️  开始构建项目..."

:: 清理旧的构建文件
if exist "%BUILD_DIR%" (
    call :print_message %YELLOW% "🧹 清理旧的构建文件..."
    rmdir /s /q "%BUILD_DIR%"
)

:: 执行构建
npm run build

if errorlevel 1 (
    call :print_message %RED% "❌ 项目构建失败"
    pause
    exit /b 1
)

call :print_message %GREEN% "✅ 项目构建完成"

:: 7. 构建结果检查
call :print_message %BLUE% "📊 检查构建结果..."

if not exist "%BUILD_DIR%" (
    call :print_message %RED% "❌ 构建目录不存在"
    pause
    exit /b 1
)

:: 计算文件数量
set file_count=0
for /r "%BUILD_DIR%" %%f in (*) do set /a file_count+=1

call :print_message %GREEN% "✅ 构建文件数量: !file_count!"

:: 8. 推送到远程仓库
call :print_message %BLUE% "📤 推送代码到远程仓库..."

:: 获取当前分支
for /f "tokens=*" %%i in ('git branch --show-current') do set CURRENT_BRANCH=%%i

if not "%CURRENT_BRANCH%"=="%GITHUB_BRANCH%" (
    call :print_message %YELLOW% "⚠️ 当前分支: !CURRENT_BRANCH!，目标分支: %GITHUB_BRANCH%"
    call :confirm "是否切换到 %GITHUB_BRANCH% 分支？"
    if not errorlevel 1 goto skip_checkout
    
    git checkout %GITHUB_BRANCH%
    git pull origin %GITHUB_BRANCH%
    git merge !CURRENT_BRANCH!
)

:skip_checkout
git push %REMOTE_ORIGIN% %GITHUB_BRANCH%

if errorlevel 1 (
    call :print_message %RED% "❌ Git 推送失败"
    pause
    exit /b 1
)

call :print_message %GREEN% "✅ 代码推送成功"

:: 9. GitHub Actions 状态检查（可选）
echo %YELLOW%是否检查 GitHub Actions 状态？ [y/N]: %NC%
set /p "actions_confirm="
if /i "%actions_confirm%"=="y" goto check_actions
if /i "%actions_confirm%"=="yes" goto check_actions
goto finish

:check_actions
call :print_message %BLUE% "🔄 检查 GitHub Actions 状态..."

if exist ".github\workflows" (
    call :print_message %GREEN% "✅ 发现 GitHub Actions 配置"
    
    :: 获取GitHub仓库URL
    for /f "tokens=*" %%i in ('git config --get remote.origin.url') do set REPO_URL=%%i
    set "REPO_URL=!REPO_URL:https://github.com/=!"
    set "REPO_URL=!REPO_URL:.git=!"
    
    call :print_message %CYAN% "🔗 请访问 GitHub 查看部署状态:"
    echo %WHITE%   https://github.com/!REPO_URL!/actions%NC%
) else (
    call :print_message %YELLOW% "⚠️ 未发现 GitHub Actions 配置"
)

:: 10. 完成信息
:finish
call :print_header "🎉 部署完成！"

call :print_message %GREEN% "✅ 本地构建完成"
call :print_message %GREEN% "✅ 代码已推送到 GitHub"
call :print_message %GREEN% "✅ GitHub Actions 将自动部署"

echo.
call :print_message %CYAN% "📋 部署信息汇总:"
echo %WHITE%   项目名称: %PROJECT_NAME%
echo %WHITE%   构建目录: %BUILD_DIR%
echo %WHITE%   目标分支: %GITHUB_BRANCH%
echo %WHITE%   构建文件数量: !file_count!
for /f "tokens=*" %%i in ('powershell -command "Get-Date -Format 'yyyy-MM-dd HH:mm:ss'"') do set TIMESTAMP=%%i
echo %WHITE%   部署时间: !TIMESTAMP!

echo.
call :print_message %YELLOW% "🌐 部署完成后，您的网站将在以下地址可访问:"

:: 获取GitHub仓库URL用于显示
for /f "tokens=*" %%i in ('git config --get remote.origin.url') do set REPO_URL=%%i
set "REPO_URL=!REPO_URL:https://github.com/=!"
set "REPO_URL=!REPO_URL:.git=!"

echo %CYAN%   https://!REPO_URL!.github.io/%PROJECT_NAME%%NC%

echo.
call :print_message %GREEN% "🎊 一键部署流程执行完成！"

echo.
pause
goto :eof

:: 脚本入口
call main %*