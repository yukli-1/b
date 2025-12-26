#!/bin/bash

# ======================================
# 🚀 一键部署脚本
# 🎯 功能：自动化构建、提交、推送并部署到GitHub Pages
# ======================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# 配置变量
PROJECT_NAME="vue-tech-blog"
BUILD_DIR="dist"
GITHUB_BRANCH="main"
REMOTE_ORIGIN="origin"

# 函数：打印彩色消息
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}[$(date '+%H:%M:%S')] ${message}${NC}"
}

print_header() {
    local message=$1
    echo ""
    echo "${CYAN}================================${NC}"
    echo -e "${WHITE}${message}${NC}"
    echo "${CYAN}================================${NC}"
    echo ""
}

# 函数：检查命令是否存在
check_command() {
    if ! command -v $1 &> /dev/null; then
        print_message $RED "❌ 错误：未找到 $1 命令，请先安装"
        exit 1
    fi
}

# 函数：确认操作
confirm() {
    local message=$1
    read -p "$(echo -e ${YELLOW}"❓ ${message} [y/N]: "${NC})" response
    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# 函数：获取当前分支
get_current_branch() {
    git branch --show-current
}

# 函数：检查是否有未提交的更改
check_uncommitted_changes() {
    if ! git diff --quiet || ! git diff --cached --quiet; then
        return 0
    else
        return 1
    fi
}

# 主部署流程
main() {
    print_header "🚀 开始一键部署流程"
    
    # 1. 环境检查
    print_message $BLUE "🔍 检查环境依赖..."
    check_command "node"
    check_command "npm"
    check_command "git"
    
    # 获取版本信息
    NODE_VERSION=$(node --version)
    NPM_VERSION=$(npm --version)
    GIT_VERSION=$(git --version)
    
    print_message $GREEN "✅ Node.js: $NODE_VERSION"
    print_message $GREEN "✅ npm: $NPM_VERSION"
    print_message $GREEN "✅ Git: $GIT_VERSION"
    
    # 2. 项目检查
    print_message $BLUE "📁 检查项目配置..."
    
    if [ ! -f "package.json" ]; then
        print_message $RED "❌ 错误：未找到 package.json 文件"
        exit 1
    fi
    
    if [ ! -d ".git" ]; then
        print_message $RED "❌ 错误：这不是一个 Git 仓库"
        print_message $YELLOW "💡 请先运行：git init"
        exit 1
    fi
    
    print_message $GREEN "✅ 项目配置检查通过"
    
    # 3. 依赖检查和安装
    print_message $BLUE "📦 检查项目依赖..."
    
    if [ ! -d "node_modules" ]; then
        print_message $YELLOW "🔧 安装项目依赖..."
        npm install
        if [ $? -ne 0 ]; then
            print_message $RED "❌ 依赖安装失败"
            exit 1
        fi
        print_message $GREEN "✅ 依赖安装完成"
    else
        print_message $GREEN "✅ 依赖已存在"
    fi
    
    # 4. 代码质量检查（可选）
    if confirm "是否运行代码质量检查？(ESLint)"; then
        print_message $BLUE "🔍 运行代码质量检查..."
        npm run lint
        if [ $? -ne 0 ]; then
            print_message $YELLOW "⚠️ 代码检查发现问题，但继续部署..."
        else
            print_message $GREEN "✅ 代码质量检查通过"
        fi
    fi
    
    # 5. Git 状态检查
    print_message $BLUE "🔄 检查 Git 状态..."
    
    if check_uncommitted_changes; then
        print_message $YELLOW "⚠️ 发现未提交的更改"
        if confirm "是否自动提交所有更改？"; then
            print_message $BLUE "📝 提交代码更改..."
            git add .
            
            # 生成提交信息
            COMMIT_MESSAGE="🚀 Auto deploy: $(date '+%Y-%m-%d %H:%M:%S')"
            
            git commit -m "$COMMIT_MESSAGE"
            if [ $? -ne 0 ]; then
                print_message $RED "❌ Git 提交失败"
                exit 1
            fi
            print_message $GREEN "✅ 代码提交完成"
        else
            print_message $YELLOW "⚠️ 跳过代码提交，可能影响部署"
        fi
    else
        print_message $GREEN "✅ 没有未提交的更改"
    fi
    
    # 6. 构建项目
    print_message $BLUE "🏗️  开始构建项目..."
    
    # 清理旧的构建文件
    if [ -d "$BUILD_DIR" ]; then
        print_message $YELLOW "🧹 清理旧的构建文件..."
        rm -rf $BUILD_DIR
    fi
    
    # 执行构建
    npm run build
    
    if [ $? -ne 0 ]; then
        print_message $RED "❌ 项目构建失败"
        exit 1
    fi
    
    print_message $GREEN "✅ 项目构建完成"
    
    # 7. 构建结果检查
    print_message $BLUE "📊 检查构建结果..."
    
    if [ ! -d "$BUILD_DIR" ]; then
        print_message $RED "❌ 构建目录不存在"
        exit 1
    fi
    
    BUILD_SIZE=$(du -sh $BUILD_DIR | cut -f1)
    FILE_COUNT=$(find $BUILD_DIR -type f | wc -l)
    
    print_message $GREEN "✅ 构建目录大小: $BUILD_SIZE"
    print_message $GREEN "✅ 构建文件数量: $FILE_COUNT"
    
    # 8. 推送到远程仓库
    print_message $BLUE "📤 推送代码到远程仓库..."
    
    CURRENT_BRANCH=$(get_current_branch)
    
    if [ "$CURRENT_BRANCH" != "$GITHUB_BRANCH" ]; then
        print_message $YELLOW "⚠️ 当前分支: $CURRENT_BRANCH，目标分支: $GITHUB_BRANCH"
        if confirm "是否切换到 $GITHUB_BRANCH 分支？"; then
            git checkout $GITHUB_BRANCH
            git pull origin $GITHUB_BRANCH
            git merge $CURRENT_BRANCH
        fi
    fi
    
    git push $REMOTE_ORIGIN $GITHUB_BRANCH
    
    if [ $? -ne 0 ]; then
        print_message $RED "❌ Git 推送失败"
        exit 1
    fi
    
    print_message $GREEN "✅ 代码推送成功"
    
    # 9. GitHub Actions 状态检查（可选）
    if confirm "是否检查 GitHub Actions 状态？"; then
        print_message $BLUE "🔄 检查 GitHub Actions 状态..."
        
        # 检查是否配置了 GitHub Actions
        if [ -d ".github/workflows" ]; then
            print_message $GREEN "✅ 发现 GitHub Actions 配置"
            print_message $CYAN "🔗 请访问 GitHub 查看部署状态:"
            echo -e "${WHITE}   https://github.com/$(git config --get remote.origin.url | sed 's/.*:\/\/github.com\///; s/\.git$//')/actions${NC}"
        else
            print_message $YELLOW "⚠️ 未发现 GitHub Actions 配置"
        fi
    fi
    
    # 10. 完成信息
    print_header "🎉 部署完成！"
    
    print_message $GREEN "✅ 本地构建完成"
    print_message $GREEN "✅ 代码已推送到 GitHub"
    print_message $GREEN "✅ GitHub Actions 将自动部署"
    
    echo ""
    print_message $CYAN "📋 部署信息汇总:"
    echo -e "${WHITE}   项目名称: ${WHITE}$PROJECT_NAME"
    echo -e "${WHITE}   构建目录: ${WHITE}$BUILD_DIR"
    echo -e "${WHITE}   目标分支: ${WHITE}$GITHUB_BRANCH"
    echo -e "${WHITE}   构建大小: ${WHITE}$BUILD_SIZE"
    echo -e "${WHITE}   部署时间: ${WHITE}$(date '+%Y-%m-%d %H:%M:%S')"
    
    echo ""
    print_message $YELLOW "🌐 部署完成后，您的网站将在以下地址可访问:"
    echo -e "${CYAN}   https://$(git config --get remote.origin.url | sed 's/.*:\/\/github.com\///; s/\.git$//').github.io/$PROJECT_NAME${NC}"
    
    echo ""
    print_message $GREEN "🎊 一键部署流程执行完成！"
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi