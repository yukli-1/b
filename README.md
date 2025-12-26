# 🚀 Vue.js 技术博客

一个现代化的技术博客系统，使用 Vue 3 + Vite + Pinia 构建。

## ✨ 特性

- 🎨 **现代化UI设计** - 炫酷蓝色主题，支持亮色/暗色模式切换
- 📱 **完全响应式** - 适配桌面、平板、手机所有设备
- ⚡ **极速性能** - Vite构建，懒加载，代码分割
- 🔍 **强大搜索** - 支持标题、内容、标签搜索
- 📁 **分类系统** - 文章分类管理，统计展示
- 💬 **评论互动** - 用户评论功能
- 🏷️ **标签云** - 热门标签可视化
- 📊 **数据统计** - 文章浏览量、点赞数统计
- 🌙 **主题切换** - 支持亮色/暗色主题
- 🎯 **SEO优化** - 语义化HTML，meta标签优化

## 🛠 技术栈

### 前端框架
- **Vue 3.5+** - 组合式API
- **Vue Router 4** - 路由管理
- **Pinia** - 状态管理
- **Vite** - 构建工具

### 样式技术
- **CSS3** - 现代CSS特性
- **CSS Grid/Flexbox** - 响应式布局
- **CSS变量** - 主题系统
- **Tailwind** (可选) - 工具类

### 开发工具
- **ESLint** - 代码规范
- **TypeScript** - 类型支持
- **Prettier** - 代码格式化

## 📦 安装与运行

### 环境要求
- Node.js 16+
- npm 7+

### 安装依赖
```bash
npm install
```

### 开发模式
```bash
npm run dev
```

### 构建生产版本
```bash
npm run build
```

### 预览构建结果
```bash
npm run preview
```

## 📁 项目结构

```
my-blog/
├── public/              # 静态资源
│   ├── images/         # 图片资源
│   └── vite.svg       # Vite图标
├── src/
│   ├── components/     # 可复用组件
│   │   ├── ArticleCard.vue
│   │   ├── Header.vue
│   │   └── Footer.vue
│   ├── views/          # 页面组件
│   │   ├── Home.vue
│   │   ├── Article.vue
│   │   ├── Category.vue
│   │   └── About.vue
│   ├── stores/         # 状态管理
│   │   └── blog.js
│   ├── router/         # 路由配置
│   │   └── index.js
│   ├── styles/         # 样式文件
│   │   └── global.css
│   ├── App.vue         # 根组件
│   └── main.js         # 入口文件
├── dist/              # 构建输出
├── package.json        # 项目配置
└── README.md          # 项目说明
```

## 🎯 功能演示

### 1. 首页展示
- 英雄区域：渐变背景 + 动画效果
- 文章网格：卡片式布局展示
- 数据统计：文章数、分类数、浏览量
- 筛选功能：分类筛选 + 时间排序

### 2. 文章详情
- Markdown渲染：支持代码高亮
- 文章导航：上一篇/下一篇
- 评论系统：用户互动功能
- 分享功能：社交媒体分享

### 3. 分类页面
- 分类列表：可视化分类统计
- 文章筛选：按分类查看文章
- 分页功能：优雅的分页导航
- 标签云：热门标签展示

### 4. 搜索功能
- 实时搜索：输入即搜索
- 多字段搜索：标题+内容+标签
- 搜索高亮：关键词高亮显示
- 搜索历史：最近搜索记录

## 🎨 主题系统

### 亮色主题
- 主色调：`#2563eb` (蓝色)
- 背景色：`#ffffff` (白色)
- 文字色：`#1e293b` (深灰)

### 暗色主题
- 主色调：`#3b82f6` (蓝色)
- 背景色：`#0f172a` (深蓝黑)
- 文字色：`#e5e5e5` (浅灰)

### 自定义主题
通过修改 `src/styles/global.css` 中的CSS变量来自定义主题色彩。

## 📱 响应式设计

- **桌面端** (>1024px)：多列布局
- **平板端** (768px-1024px)：双列布局
- **手机端** (<768px)：单列布局

## 🚀 部署

### 静态部署
1. 运行 `npm run build`
2. 将 `dist/` 目录上传到服务器
3. 配置服务器重写规则

### Vercel部署
```bash
npm install -g vercel
vercel --prod
```

### Netlify部署
1. 连接GitHub仓库
2. 配置构建命令：`npm run build`
3. 设置发布目录：`dist`

## 🤝 贡献

欢迎提交Issue和Pull Request！

### 开发流程
1. Fork 本仓库
2. 创建特性分支
3. 提交代码
4. 创建Pull Request

## 📄 许可证

MIT License

## 👨‍💻 作者

- **GitHub**: [@your-username](https://github.com/your-username)
- **Email**: your-email@example.com

---

⭐ 如果这个项目对你有帮助，请给它一个星标！