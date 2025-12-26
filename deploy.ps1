# ======================================
# 🚀 一键部署脚本 (PowerShell版)
# 🎯 功能：自动化构建、提交、推送并部署到GitHub Pages
# ======================================

param(
    [switch]$SkipTests,
    [switch]$SkipLint,
    [switch]$SkipGitCheck,
    [string]$CommitMessage = ""
)

# 配置变量
$PROJECT_NAME = "vue-tech-blog"
$BUILD_DIR = "dist"
$GITHUB_BRANCH = "main"
$REMOTE_ORIGIN = "origin"

# 颜色输出函数
function Write-ColoredMessage {
    param(
        [string]$Color,
        [string]$Message
    )
    
    $Colors = @{
        "Red" = "Red"
        "Green" = "Green"
        "Yellow" = "Yellow"
        "Blue" = "Blue"
        "Purple" = "Magenta"
        "Cyan" = "Cyan"
        "White" = "White"
    }
    
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] $Message" -ForegroundColor $Colors[$Color]
}

function Write-Header {
    param([string]$Message)
    
    Write-Host ""
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor White
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host ""
}

# 检查命令是否存在
function Test-Command {
    param([string]$Command)
    
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# 确认操作
function Confirm-Action {
    param([string]$Message)
    
    $response = Read-Host "❓ $Message [y/N]"
    return $response -match "^[yY](es)?$"
}

# 获取当前Git分支
function Get-CurrentBranch {
    try {
        return (git branch --show-current).Trim()
    }
    catch {
        return ""
    }
}

# 检查是否有未提交的更改
function Test-UncommittedChanges {
    try {
        $status = git status --porcelain
        return $status.Length -gt 0
    }
    catch {
        return $false
    }
}

# 主部署流程
function Start-Deployment {
    Write-Header "🚀 开始一键部署流程"
    
    # 1. 环境检查
    Write-ColoredMessage "Blue" "🔍 检查环境依赖..."
    
    $requiredCommands = @("node", "npm", "git")
    foreach ($cmd in $requiredCommands) {
        if (-not (Test-Command $cmd)) {
            Write-ColoredMessage "Red" "❌ 错误：未找到 $cmd 命令，请先安装"
            exit 1
        }
    }
    
    # 获取版本信息
    $NODE_VERSION = & node --version
    $NPM_VERSION = & npm --version
    $GIT_VERSION = (git --version).Split(' ')[2]
    
    Write-ColoredMessage "Green" "✅ Node.js: $NODE_VERSION"
    Write-ColoredMessage "Green" "✅ npm: $NPM_VERSION"
    Write-ColoredMessage "Green" "✅ Git: $GIT_VERSION"
    
    # 2. 项目检查
    Write-ColoredMessage "Blue" "📁 检查项目配置..."
    
    if (-not (Test-Path "package.json")) {
        Write-ColoredMessage "Red" "❌ 错误：未找到 package.json 文件"
        exit 1
    }
    
    if (-not (Test-Path ".git")) {
        Write-ColoredMessage "Red" "❌ 错误：这不是一个 Git 仓库"
        Write-ColoredMessage "Yellow" "💡 请先运行：git init"
        exit 1
    }
    
    Write-ColoredMessage "Green" "✅ 项目配置检查通过"
    
    # 3. 依赖检查和安装
    Write-ColoredMessage "Blue" "📦 检查项目依赖..."
    
    if (-not (Test-Path "node_modules")) {
        Write-ColoredMessage "Yellow" "🔧 安装项目依赖..."
        $result = npm install
        if ($LASTEXITCODE -ne 0) {
            Write-ColoredMessage "Red" "❌ 依赖安装失败"
            exit 1
        }
        Write-ColoredMessage "Green" "✅ 依赖安装完成"
    }
    else {
        Write-ColoredMessage "Green" "✅ 依赖已存在"
    }
    
    # 4. 代码质量检查（可选）
    if (-not $SkipLint) {
        if (Confirm-Action "是否运行代码质量检查？(ESLint)") {
            Write-ColoredMessage "Blue" "🔍 运行代码质量检查..."
            $result = npm run lint
            if ($LASTEXITCODE -ne 0) {
                Write-ColoredMessage "Yellow" "⚠️ 代码检查发现问题，但继续部署..."
            }
            else {
                Write-ColoredMessage "Green" "✅ 代码质量检查通过"
            }
        }
    }
    
    # 5. Git 状态检查
    if (-not $SkipGitCheck) {
        Write-ColoredMessage "Blue" "🔄 检查 Git 状态..."
        
        if (Test-UncommittedChanges) {
            Write-ColoredMessage "Yellow" "⚠️ 发现未提交的更改"
            if (Confirm-Action "是否自动提交所有更改？") {
                Write-ColoredMessage "Blue" "📝 提交代码更改..."
                
                git add .
                
                # 生成提交信息
                $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                if ($CommitMessage -eq "") {
                    $commitMsg = "🚀 Auto deploy: $timestamp"
                }
                else {
                    $commitMsg = $CommitMessage
                }
                
                git commit -m $commitMsg
                if ($LASTEXITCODE -ne 0) {
                    Write-ColoredMessage "Red" "❌ Git 提交失败"
                    exit 1
                }
                Write-ColoredMessage "Green" "✅ 代码提交完成"
            }
            else {
                Write-ColoredMessage "Yellow" "⚠️ 跳过代码提交，可能影响部署"
            }
        }
        else {
            Write-ColoredMessage "Green" "✅ 没有未提交的更改"
        }
    }
    
    # 6. 构建项目
    Write-ColoredMessage "Blue" "🏗️  开始构建项目..."
    
    # 清理旧的构建文件
    if (Test-Path $BUILD_DIR) {
        Write-ColoredMessage "Yellow" "🧹 清理旧的构建文件..."
        Remove-Item -Recurse -Force $BUILD_DIR
    }
    
    # 执行构建
    $buildResult = npm run build
    
    if ($LASTEXITCODE -ne 0) {
        Write-ColoredMessage "Red" "❌ 项目构建失败"
        exit 1
    }
    
    Write-ColoredMessage "Green" "✅ 项目构建完成"
    
    # 7. 构建结果检查
    Write-ColoredMessage "Blue" "📊 检查构建结果..."
    
    if (-not (Test-Path $BUILD_DIR)) {
        Write-ColoredMessage "Red" "❌ 构建目录不存在"
        exit 1
    }
    
    $buildSize = (Get-ChildItem -Path $BUILD_DIR -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1MB
    $fileCount = (Get-ChildItem -Path $BUILD_DIR -Recurse -File).Count
    
    Write-ColoredMessage "Green" "✅ 构建目录大小: $([math]::Round($buildSize, 2)) MB"
    Write-ColoredMessage "Green" "✅ 构建文件数量: $fileCount"
    
    # 8. 推送到远程仓库
    Write-ColoredMessage "Blue" "📤 推送代码到远程仓库..."
    
    $currentBranch = Get-CurrentBranch
    
    if ($currentBranch -ne $GITHUB_BRANCH) {
        Write-ColoredMessage "Yellow" "⚠️ 当前分支: $currentBranch，目标分支: $GITHUB_BRANCH"
        if (Confirm-Action "是否切换到 $GITHUB_BRANCH 分支？") {
            git checkout $GITHUB_BRANCH
            git pull origin $GITHUB_BRANCH
            git merge $currentBranch
        }
    }
    
    git push $REMOTE_ORIGIN $GITHUB_BRANCH
    
    if ($LASTEXITCODE -ne 0) {
        Write-ColoredMessage "Red" "❌ Git 推送失败"
        exit 1
    }
    
    Write-ColoredMessage "Green" "✅ 代码推送成功"
    
    # 9. GitHub Actions 状态检查（可选）
    if (Confirm-Action "是否检查 GitHub Actions 状态？") {
        Write-ColoredMessage "Blue" "🔄 检查 GitHub Actions 状态..."
        
        if (Test-Path ".github\workflows") {
            Write-ColoredMessage "Green" "✅ 发现 GitHub Actions 配置"
            
            # 获取GitHub仓库URL
            $repoUrl = git config --get remote.origin.url
            $repoUrl = $repoUrl -replace "https://github.com/", "" -replace ".git$", ""
            
            Write-ColoredMessage "Cyan" "🔗 请访问 GitHub 查看部署状态:"
            Write-Host "   https://github.com/$repoUrl/actions" -ForegroundColor White
        }
        else {
            Write-ColoredMessage "Yellow" "⚠️ 未发现 GitHub Actions 配置"
        }
    }
    
    # 10. 完成信息
    Write-Header "🎉 部署完成！"
    
    Write-ColoredMessage "Green" "✅ 本地构建完成"
    Write-ColoredMessage "Green" "✅ 代码已推送到 GitHub"
    Write-ColoredMessage "Green" "✅ GitHub Actions 将自动部署"
    
    Write-Host ""
    Write-ColoredMessage "Cyan" "📋 部署信息汇总:"
    Write-Host "   项目名称: $PROJECT_NAME" -ForegroundColor White
    Write-Host "   构建目录: $BUILD_DIR" -ForegroundColor White
    Write-Host "   目标分支: $GITHUB_BRANCH" -ForegroundColor White
    Write-Host "   构建大小: $([math]::Round($buildSize, 2)) MB" -ForegroundColor White
    Write-Host "   部署时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor White
    
    Write-Host ""
    Write-ColoredMessage "Yellow" "🌐 部署完成后，您的网站将在以下地址可访问:"
    
    # 获取GitHub仓库URL用于显示
    $repoUrl = git config --get remote.origin.url
    $repoUrl = $repoUrl -replace "https://github.com/", "" -replace ".git$", ""
    
    Write-Host "   https://$repoUrl.github.io/$PROJECT_NAME" -ForegroundColor Cyan
    
    Write-Host ""
    Write-ColoredMessage "Green" "🎊 一键部署流程执行完成！"
}

# 脚本入口
try {
    Start-Deployment
}
catch {
    Write-ColoredMessage "Red" "❌ 部署过程中发生错误: $($_.Exception.Message)"
    exit 1
}