<!-- 主页增强版 - 添加分页功能 -->
<template>
  <div class="home">
    <!-- 英雄区域 -->
    <section class="hero">
      <div class="container">
        <div class="hero-content">
          <div class="hero-text">
            <h1 class="hero-title">欢迎来到我的技术博客</h1>
            <p class="hero-subtitle">探索前端开发的无限可能，分享编程路上的点点滴滴</p>
            <div class="hero-stats">
              <div class="stat-item">
                <span class="stat-number">{{ blogStore.articles.length }}</span>
                <span class="stat-label">文章</span>
              </div>
              <div class="stat-item">
                <span class="stat-number">{{ blogStore.categories.length }}</span>
                <span class="stat-label">分类</span>
              </div>
              <div class="stat-item">
                <span class="stat-number">{{ totalViews }}</span>
                <span class="stat-label">浏览</span>
              </div>
            </div>
          </div>
          <div class="hero-image">
            <div class="hero-avatar">
              <img src="/images/avatar.jpg" alt="头像" @error="handleImageError">
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 主要内容区 -->
    <main class="main-content">
      <div class="container">
        <div class="content-layout">
          <!-- 文章列表 -->
          <div class="articles-section">
            <div class="section-header">
              <h2 class="section-title">
                <i class="icon">📝</i>
                最新文章
              </h2>
              <div class="section-actions">
                <select v-model="selectedCategory" class="category-filter">
                  <option value="">所有分类</option>
                  <option v-for="category in blogStore.categories" :key="category.name" :value="category.name">
                    {{ category.name }} ({{ category.count }})
                  </option>
                </select>
                <select v-model="sortBy" class="sort-filter">
                  <option value="date">最新发布</option>
                  <option value="views">最多浏览</option>
                  <option value="likes">最多点赞</option>
                </select>
              </div>
            </div>

            <!-- 加载状态 -->
            <div v-if="blogStore.isLoading" class="loading-container">
              <div class="loading-spinner"></div>
              <p>正在加载文章...</p>
            </div>

            <!-- 文章网格 -->
            <div v-else class="articles-grid">
              <ArticleCard 
                v-for="article in displayArticles" 
                :key="article.id" 
                :article="article"
                class="slide-in-right"
              />
            </div>

            <!-- 空状态 -->
            <div v-if="displayArticles.length === 0 && !blogStore.isLoading" class="empty-state">
              <div class="empty-icon">📭</div>
              <h3>暂无文章</h3>
              <p>该分类下还没有文章，敬请期待更多精彩内容</p>
            </div>

            <!-- 分页 -->
            <div class="pagination-wrapper">
              <Pagination 
                :current="currentPage"
                :total="filteredArticles.length"
                :page-size="pageSize"
                @page-change="handlePageChange"
                @page-size-change="handlePageSizeChange"
              />
            </div>
          </div>

          <!-- 侧边栏 -->
          <aside class="sidebar">
            <!-- 个人信息卡片 -->
            <div class="sidebar-card profile-card">
              <div class="profile-avatar">
                <img src="/images/avatar.jpg" alt="头像" @error="handleImageError">
              </div>
              <h3 class="profile-name">技术博主</h3>
              <p class="profile-bio">热爱前端开发，专注用户体验</p>
              <div class="profile-stats">
                <div class="profile-stat">
                  <span class="stat-value">{{ blogStore.articles.length }}</span>
                  <span class="stat-name">文章</span>
                </div>
                <div class="profile-stat">
                  <span class="stat-value">{{ blogStore.categories.length }}</span>
                  <span class="stat-name">分类</span>
                </div>
                <div class="profile-stat">
                  <span class="stat-value">{{ totalViews }}</span>
                  <span class="stat-name">浏览</span>
                </div>
              </div>
            </div>

            <!-- 热门标签 -->
            <div class="sidebar-card">
              <h3 class="sidebar-title">
                <i class="icon">🏷️</i>
                热门标签
              </h3>
              <div class="tags-cloud">
                <router-link 
                  v-for="tag in blogStore.tags" 
                  :key="tag.name"
                  :to="{ name: 'Search', query: { tag: tag.name } }"
                  class="tag-cloud-item"
                  :style="{ fontSize: getTagSize(tag.count) + 'rem' }"
                >
                  {{ tag.name }}
                </router-link>
              </div>
            </div>

            <!-- 分类统计 -->
            <div class="sidebar-card">
              <h3 class="sidebar-title">
                <i class="icon">📂</i>
                分类统计
              </h3>
              <ul class="category-list">
                <li v-for="category in blogStore.categories" :key="category.name">
                  <router-link :to="{ name: 'Category', params: { name: category.name } }">
                    <span class="category-name">{{ category.name }}</span>
                    <span class="category-count">{{ category.count }}</span>
                  </router-link>
                </li>
              </ul>
            </div>
          </aside>
        </div>
      </div>
    </main>
    
    <!-- 返回顶部 -->
    <BackToTop />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useBlogStore } from '../stores/blog'
import ArticleCard from '../components/ArticleCard.vue'
import Pagination from '../components/Pagination.vue'
import BackToTop from '../components/BackToTop.vue'
import LoadingSpinner from '../components/LoadingSpinner.vue'

const blogStore = useBlogStore()

const selectedCategory = ref('')
const sortBy = ref('date')
const currentPage = ref(1)
const pageSize = ref(6)

// 计算属性
const totalViews = computed(() => 
  blogStore.articles.reduce((sum, article) => sum + article.views, 0)
)

const filteredArticles = computed(() => {
  let articles = [...blogStore.articles]
  
  // 分类筛选
  if (selectedCategory.value) {
    articles = articles.filter(article => article.category === selectedCategory.value)
  }
  
  // 排序
  articles.sort((a, b) => {
    switch (sortBy.value) {
      case 'views':
        return b.views - a.views
      case 'likes':
        return b.likes - a.likes
      case 'date':
      default:
        return new Date(b.date) - new Date(a.date)
    }
  })
  
  return articles
})

const displayArticles = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  const end = start + pageSize.value
  return filteredArticles.value.slice(start, end)
})

// 方法
const getTagSize = (count) => {
  if (count >= 15) return 1.2
  if (count >= 10) return 1.1
  if (count >= 5) return 1
  return 0.9
}

const handleImageError = (e) => {
  e.target.src = 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAwIiBoZWlnaHQ9IjEwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICA8cmVjdCB3aWR0aD0iMTAwIiBoZWlnaHQ9IjEwMCIgZmlsbD0iI2Y1ZjVmNSIvPgogIDx0ZXh0IHg9IjUwIiB5PSI1NSIgZm9udC1mYW1pbHk9IkFyaWFsIiBmb250LXNpemU9IjE0IiBmaWxsPSIjOTk5IiB0ZXh0LWFuY2hvcj0ibWlkZGxlIj7mlrDlrabkvaE8L3RleHQ+Cjwvc3ZnPgo='
}

const handlePageChange = (page) => {
  currentPage.value = page
  // 滚动到页面顶部
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const handlePageSizeChange = (newPageSize) => {
  pageSize.value = newPageSize
  currentPage.value = 1 // 切换页大小时回到第一页
}

// 监听筛选条件变化，重置页码
watch([selectedCategory, sortBy], () => {
  currentPage.value = 1
})

// 生命周期
onMounted(async () => {
  await blogStore.loadArticles()
})
</script>

<style scoped>
.home {
  min-height: 100vh;
}

/* 英雄区域 */
.hero {
  background: linear-gradient(135deg, var(--primary-color) 0%, #66b1ff 100%);
  padding: 4rem 0 3rem;
  position: relative;
  overflow: hidden;
}

.hero::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml,<svg width="60" height="60" viewBox="0 0 60 60" xmlns="http://www.w3.org/2000/svg"><g fill="none" fill-rule="evenodd"><g fill="%23ffffff" fill-opacity="0.05"><path d="M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z"/></g></g></svg>') repeat;
  opacity: 0.3;
}

.hero-content {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 3rem;
  align-items: center;
  position: relative;
  z-index: 1;
}

.hero-title {
  color: white;
  font-size: 3rem;
  font-weight: 700;
  margin-bottom: 1rem;
  line-height: 1.2;
  animation: fadeInUp 0.8s ease-out;
}

.hero-subtitle {
  color: rgba(255, 255, 255, 0.9);
  font-size: 1.2rem;
  margin-bottom: 2rem;
  animation: fadeInUp 0.8s ease-out 0.2s both;
}

.hero-stats {
  display: flex;
  gap: 2rem;
  animation: fadeInUp 0.8s ease-out 0.4s both;
}

.stat-item {
  text-align: center;
  color: white;
}

.stat-number {
  display: block;
  font-size: 2rem;
  font-weight: 700;
  line-height: 1;
  margin-bottom: 0.25rem;
}

.stat-label {
  font-size: 0.9rem;
  opacity: 0.9;
}

.hero-image {
  display: flex;
  justify-content: center;
  animation: fadeInRight 0.8s ease-out 0.6s both;
}

.hero-avatar {
  width: 150px;
  height: 150px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.2);
  padding: 4px;
  backdrop-filter: blur(10px);
}

.hero-avatar img {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  object-fit: cover;
}

/* 主要内容区 */
.main-content {
  padding: 3rem 0;
}

.content-layout {
  display: grid;
  grid-template-columns: 1fr 320px;
  gap: 3rem;
}

.articles-section {
  min-height: 400px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  flex-wrap: wrap;
  gap: 1rem;
}

.section-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--text-primary);
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.section-actions {
  display: flex;
  gap: 1rem;
}

.category-filter,
.sort-filter {
  padding: 0.5rem 1rem;
  border: 1px solid var(--border-color);
  border-radius: var(--border-radius);
  background: var(--bg-color);
  color: var(--text-primary);
  font-size: 0.9rem;
  cursor: pointer;
  transition: var(--transition-fast);
}

.category-filter:focus,
.sort-filter:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

.articles-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 2rem;
}

.loading-container {
  text-align: center;
  padding: 3rem;
  color: var(--text-secondary);
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid var(--border-light);
  border-top: 4px solid var(--primary-color);
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 1rem;
}

.empty-state {
  text-align: center;
  padding: 3rem;
  color: var(--text-secondary);
}

.empty-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.pagination-wrapper {
  margin-top: 3rem;
  text-align: center;
}

/* 侧边栏 */
.sidebar {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.sidebar-card {
  background: var(--bg-color);
  border: 1px solid var(--border-light);
  border-radius: var(--border-radius);
  padding: 1.5rem;
  box-shadow: var(--shadow);
}

.sidebar-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 1rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

/* 个人信息卡片 */
.profile-card {
  text-align: center;
}

.profile-avatar {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  margin: 0 auto 1rem;
  overflow: hidden;
  border: 3px solid var(--primary-color);
}

.profile-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.profile-name {
  font-size: 1.2rem;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 0.5rem;
}

.profile-bio {
  color: var(--text-secondary);
  margin-bottom: 1rem;
  font-size: 0.9rem;
}

.profile-stats {
  display: flex;
  justify-content: space-around;
  padding-top: 1rem;
  border-top: 1px solid var(--border-lighter);
}

.profile-stat {
  text-align: center;
}

.stat-value {
  display: block;
  font-size: 1.2rem;
  font-weight: 600;
  color: var(--primary-color);
}

.stat-name {
  font-size: 0.8rem;
  color: var(--text-tertiary);
}

/* 标签云 */
.tags-cloud {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.tag-cloud-item {
  color: var(--primary-color);
  text-decoration: none;
  transition: var(--transition-fast);
  font-weight: 500;
}

.tag-cloud-item:hover {
  color: #66b1ff;
  text-decoration: underline;
}

/* 分类列表 */
.category-list {
  list-style: none;
  padding: 0;
}

.category-list li {
  margin-bottom: 0.5rem;
}

.category-list a {
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: var(--text-primary);
  text-decoration: none;
  padding: 0.5rem;
  border-radius: var(--border-radius-sm);
  transition: var(--transition-fast);
}

.category-list a:hover {
  background: var(--bg-secondary);
  color: var(--primary-color);
}

.category-name {
  font-weight: 500;
}

.category-count {
  background: var(--primary-light);
  color: var(--primary-color);
  padding: 0.2rem 0.5rem;
  border-radius: var(--border-radius-sm);
  font-size: 0.8rem;
  font-weight: 500;
}

/* 动画 */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeInRight {
  from {
    opacity: 0;
    transform: translateX(30px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

/* 响应式 */
@media (max-width: 1024px) {
  .content-layout {
    grid-template-columns: 1fr;
  }
  
  .sidebar {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1.5rem;
  }
}

@media (max-width: 768px) {
  .hero-content {
    grid-template-columns: 1fr;
    text-align: center;
    gap: 2rem;
  }
  
  .hero-title {
    font-size: 2rem;
  }
  
  .hero-subtitle {
    font-size: 1rem;
  }
  
  .hero-stats {
    justify-content: center;
  }
  
  .articles-grid {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }
  
  .section-header {
    flex-direction: column;
    align-items: stretch;
  }
  
  .section-actions {
    flex-direction: column;
  }
  
  .profile-stats {
    flex-direction: column;
    gap: 0.5rem;
  }
}

@media (max-width: 480px) {
  .hero {
    padding: 2rem 0 1.5rem;
  }
  
  .hero-title {
    font-size: 1.5rem;
  }
  
  .main-content {
    padding: 2rem 0;
  }
  
  .sidebar-card {
    padding: 1rem;
  }
}
</style>