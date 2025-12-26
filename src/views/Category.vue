<template>
  <div class="category-page">
    <div class="container">
      <header class="page-header">
        <div class="breadcrumb" v-if="currentCategory">
          <router-link to="/" class="breadcrumb-link">首页</router-link>
          <span class="breadcrumb-separator">/</span>
          <span class="breadcrumb-current">分类</span>
          <span class="breadcrumb-separator">/</span>
          <span class="breadcrumb-current">{{ currentCategory }}</span>
        </div>
        <h1 class="page-title">
          <span v-if="!currentCategory">所有分类</span>
          <span v-else>{{ currentCategory }}</span>
          <span class="page-subtitle" v-if="currentCategory">分类</span>
        </h1>
        <p class="page-description">{{ categoryDescription }}</p>
        <div class="page-stats" v-if="currentCategory">
          <span class="stat-item">
            <i class="stat-icon">📄</i>
            {{ category?.count || 0 }} 篇文章
          </span>
        </div>
      </header>

      <div class="content-layout">
        <main class="main-content">
          <!-- 加载状态 -->
          <div v-if="blogStore.isLoading" class="loading-state">
            <div class="loading-spinner"></div>
            <p>加载中...</p>
          </div>

          <!-- 文章网格 -->
          <div v-else class="articles-grid">
            <ArticleCard 
              v-for="article in paginatedArticles" 
              :key="article.id"
              :article="article"
            />
          </div>
          
          <!-- 空状态 -->
          <div v-if="!blogStore.isLoading && categoryArticles.length === 0" class="empty-state">
            <div class="empty-icon">📭</div>
            <h3>暂无文章</h3>
            <p>{{ currentCategory ? `该分类下还没有文章` : '还没有发布任何文章' }}</p>
            <router-link to="/" class="back-home-btn">返回首页</router-link>
          </div>

          <!-- 分页 -->
          <div v-if="totalPages > 1" class="pagination">
            <button 
              class="pagination-btn" 
              :disabled="currentPage === 1"
              @click="currentPage--"
            >
              上一页
            </button>
            <div class="pagination-numbers">
              <button 
                v-for="page in visiblePages" 
                :key="page"
                class="pagination-number"
                :class="{ active: page === currentPage }"
                @click="currentPage = page"
              >
                {{ page }}
              </button>
            </div>
            <button 
              class="pagination-btn" 
              :disabled="currentPage === totalPages"
              @click="currentPage++"
            >
              下一页
            </button>
          </div>
        </main>

        <aside class="sidebar">
          <!-- 分类卡片 -->
          <div class="sidebar-card">
            <h3 class="sidebar-title">
              <i class="title-icon">📁</i>
              所有分类
            </h3>
            <div class="category-stats">
              <span class="total-categories">{{ blogStore.categories.length }} 个分类</span>
              <span class="total-articles">{{ totalArticles }} 篇文章</span>
            </div>
            <ul class="category-list">
              <li v-for="category in sortedCategories" :key="category.name">
                <router-link 
                  :to="{ name: 'Category', params: { name: category.name } }"
                  :class="{ active: currentCategory === category.name }"
                  class="category-link"
                >
                  <span class="category-info">
                    <span class="category-name">{{ category.name }}</span>
                    <span class="category-count">{{ category.count }} 篇</span>
                  </span>
                  <div class="category-progress">
                    <div 
                      class="progress-bar" 
                      :style="{ width: getCategoryProgress(category.count) + '%' }"
                    ></div>
                  </div>
                </router-link>
              </li>
            </ul>
          </div>

          <!-- 热门标签 -->
          <div class="sidebar-card">
            <h3 class="sidebar-title">
              <i class="title-icon">🏷️</i>
              热门标签
            </h3>
            <div class="tag-cloud">
              <router-link 
                v-for="tag in popularTags" 
                :key="tag.name"
                :to="{ name: 'Search', query: { tag: tag.name } }"
                class="tag-cloud-item"
                :style="{ 
                  fontSize: getTagSize(tag.count),
                  opacity: getTagOpacity(tag.count) 
                }"
              >
                {{ tag.name }}
                <span class="tag-count">({{ tag.count }})</span>
              </router-link>
            </div>
          </div>
        </aside>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref, watch, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useBlogStore } from '../stores/blog'
import ArticleCard from '../components/ArticleCard.vue'

const route = useRoute()
const blogStore = useBlogStore()

// 响应式数据
const currentPage = ref(1)
const articlesPerPage = ref(6)

// 计算属性
const currentCategory = computed(() => {
  return route.params.name ? decodeURIComponent(route.params.name) : ''
})

const category = computed(() => {
  return blogStore.categories.find(c => c.name === currentCategory.value)
})

const categoryArticles = computed(() => {
  if (!currentCategory.value) return blogStore.articles
  return blogStore.getArticlesByCategory(currentCategory.value)
})

const totalArticles = computed(() => {
  return blogStore.categories.reduce((sum, cat) => sum + cat.count, 0)
})

const totalPages = computed(() => {
  return Math.ceil(categoryArticles.value.length / articlesPerPage.value)
})

const paginatedArticles = computed(() => {
  const start = (currentPage.value - 1) * articlesPerPage.value
  const end = start + articlesPerPage.value
  return categoryArticles.value.slice(start, end)
})

const sortedCategories = computed(() => {
  return [...blogStore.categories].sort((a, b) => b.count - a.count)
})

const popularTags = computed(() => {
  return [...blogStore.tags].sort((a, b) => b.count - a.count).slice(0, 12)
})

const visiblePages = computed(() => {
  const pages = []
  const maxVisible = 5
  let start = Math.max(1, currentPage.value - 2)
  let end = Math.min(totalPages.value, start + maxVisible - 1)
  
  if (end - start + 1 < maxVisible) {
    start = Math.max(1, end - maxVisible + 1)
  }
  
  for (let i = start; i <= end; i++) {
    pages.push(i)
  }
  return pages
})

const categoryDescription = computed(() => {
  if (!currentCategory.value) {
    return '探索所有文章分类，发现您感兴趣的内容'
  }
  return `浏览 ${currentCategory.value} 分类下的 ${category.value?.count || 0} 篇文章`
})

// 方法
const getCategoryProgress = (count) => {
  const maxCount = Math.max(...blogStore.categories.map(c => c.count))
  return (count / maxCount) * 100
}

const getTagSize = (count) => {
  const maxCount = Math.max(...blogStore.tags.map(t => t.count))
  const ratio = count / maxCount
  if (ratio > 0.8) return '1.1rem'
  if (ratio > 0.6) return '1rem'
  if (ratio > 0.4) return '0.9rem'
  return '0.8rem'
}

const getTagOpacity = (count) => {
  const maxCount = Math.max(...blogStore.tags.map(t => t.count))
  const ratio = count / maxCount
  return 0.6 + (ratio * 0.4)
}

// 监听路由变化
watch(() => route.params.name, () => {
  currentPage.value = 1
  window.scrollTo(0, 0)
})

// 监听分页变化
watch(currentPage, () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
})

// 生命周期
onMounted(() => {
  if (!blogStore.articles.length) {
    blogStore.loadArticles()
  }
})
</script>

<style scoped>
.category-page {
  padding: 2rem 0;
  min-height: calc(100vh - 200px);
  position: relative;
}

.category-page::before {
  content: '';
  position: fixed;
  top: 0;
  right: 0;
  width: 40%;
  height: 100%;
  background: linear-gradient(135deg, rgba(37, 99, 235, 0.05) 0%, transparent 50%);
  z-index: -1;
  pointer-events: none;
}

/* 页面头部 */
.page-header {
  text-align: center;
  margin-bottom: 3rem;
  position: relative;
}

.breadcrumb {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  margin-bottom: 1.5rem;
  font-size: 0.9rem;
}

.breadcrumb-link {
  color: var(--text-secondary);
  text-decoration: none;
  transition: var(--transition-fast);
}

.breadcrumb-link:hover {
  color: var(--primary-color);
}

.breadcrumb-separator {
  color: var(--text-tertiary);
}

.breadcrumb-current {
  color: var(--text-primary);
  font-weight: 500;
}

.page-title {
  font-size: 2.5rem;
  font-weight: 800;
  background: var(--gradient-1);
  background-size: 200% 200%;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 1rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  animation: gradientShift 8s ease infinite;
  text-shadow: 0 4px 10px rgba(37, 99, 235, 0.1);
}

.page-subtitle {
  font-size: 1rem;
  font-weight: 400;
  color: var(--text-secondary);
  opacity: 0.8;
}

.page-description {
  font-size: 1.1rem;
  color: var(--text-secondary);
  max-width: 600px;
  margin: 0 auto 1.5rem;
  line-height: 1.6;
}

.page-stats {
  display: flex;
  justify-content: center;
  gap: 2rem;
  margin-top: 1rem;
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--text-secondary);
  font-size: 0.9rem;
}

.stat-icon {
  font-size: 1rem;
}

/* 内容布局 */
.content-layout {
  display: grid;
  grid-template-columns: 1fr 320px;
  gap: 3rem;
  align-items: start;
}

.main-content {
  min-height: 400px;
}

/* 文章网格 */
.articles-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 2rem;
}

/* 加载状态 */
.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 4rem;
  color: var(--text-secondary);
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 3px solid var(--border-light);
  border-top: 3px solid var(--primary-color);
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 1rem;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 4rem 2rem;
  color: var(--text-secondary);
}

.empty-icon {
  font-size: 4rem;
  margin-bottom: 1.5rem;
  opacity: 0.6;
}

.empty-state h3 {
  font-size: 1.5rem;
  color: var(--text-primary);
  margin-bottom: 1rem;
}

.back-home-btn {
  display: inline-block;
  margin-top: 1.5rem;
  padding: 0.75rem 1.5rem;
  background: var(--primary-color);
  color: white;
  text-decoration: none;
  border-radius: var(--border-radius);
  transition: var(--transition);
}

.back-home-btn:hover {
  background: var(--primary-dark);
  transform: translateY(-2px);
}

/* 分页 */
.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 0.5rem;
  margin-top: 3rem;
  padding-top: 2rem;
  border-top: 1px solid var(--border-lighter);
}

.pagination-btn {
  padding: 0.5rem 1rem;
  background: var(--bg-color);
  border: 1px solid var(--border-light);
  border-radius: var(--border-radius);
  color: var(--text-primary);
  cursor: pointer;
  transition: var(--transition-fast);
}

.pagination-btn:hover:not(:disabled) {
  background: var(--primary-light);
  border-color: var(--primary-color);
}

.pagination-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.pagination-numbers {
  display: flex;
  gap: 0.25rem;
}

.pagination-number {
  width: 2.5rem;
  height: 2.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--bg-color);
  border: 1px solid var(--border-light);
  border-radius: var(--border-radius);
  color: var(--text-primary);
  cursor: pointer;
  transition: var(--transition-fast);
}

.pagination-number:hover {
  background: var(--primary-light);
  border-color: var(--primary-color);
}

.pagination-number.active {
  background: var(--primary-color);
  border-color: var(--primary-color);
  color: white;
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
  transition: var(--transition);
}

.sidebar-card:hover {
  box-shadow: var(--shadow-lg);
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

.title-icon {
  font-size: 1.2rem;
}

/* 分类统计 */
.category-stats {
  display: flex;
  justify-content: space-between;
  margin-bottom: 1rem;
  padding-bottom: 0.75rem;
  border-bottom: 1px solid var(--border-lighter);
  font-size: 0.85rem;
  color: var(--text-secondary);
}

/* 分类列表 */
.category-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.category-list li {
  margin-bottom: 0.75rem;
}

.category-link {
  display: block;
  color: var(--text-primary);
  text-decoration: none;
  padding: 0.75rem;
  border-radius: var(--border-radius);
  transition: var(--transition-fast);
  position: relative;
}

.category-link:hover,
.category-link.active {
  background: var(--primary-light);
  color: var(--primary-color);
}

.category-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.5rem;
}

.category-name {
  font-weight: 500;
}

.category-count {
  font-size: 0.8rem;
  color: var(--text-secondary);
  background: var(--bg-secondary);
  padding: 0.2rem 0.5rem;
  border-radius: var(--border-radius-sm);
}

.category-progress {
  height: 3px;
  background: var(--border-lighter);
  border-radius: 2px;
  overflow: hidden;
}

.progress-bar {
  height: 100%;
  background: var(--primary-color);
  border-radius: 2px;
  transition: width 0.3s ease;
}

/* 标签云 */
.tag-cloud {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.tag-cloud-item {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  padding: 0.3rem 0.6rem;
  background: var(--primary-light);
  color: var(--primary-color);
  text-decoration: none;
  border-radius: var(--border-radius-sm);
  transition: var(--transition-fast);
  border: 1px solid transparent;
}

.tag-cloud-item:hover {
  background: var(--primary-color);
  color: white;
  transform: translateY(-1px);
}

.tag-count {
  font-size: 0.7rem;
  opacity: 0.8;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .content-layout {
    grid-template-columns: 1fr 280px;
    gap: 2rem;
  }
  
  .articles-grid {
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  }
}

@media (max-width: 768px) {
  .content-layout {
    grid-template-columns: 1fr;
    gap: 2rem;
  }
  
  .sidebar {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1.5rem;
  }
  
  .page-title {
    font-size: 2rem;
  }
  
  .page-stats {
    flex-direction: column;
    gap: 1rem;
  }
  
  .articles-grid {
    grid-template-columns: 1fr;
  }
  
  .breadcrumb {
    font-size: 0.8rem;
  }
}

@media (max-width: 480px) {
  .category-page {
    padding: 1rem 0;
  }
  
  .page-header {
    margin-bottom: 2rem;
  }
  
  .page-title {
    font-size: 1.75rem;
  }
  
  .sidebar {
    grid-template-columns: 1fr;
  }
  
  .sidebar-card {
    padding: 1rem;
  }
  
  .pagination {
    flex-wrap: wrap;
    gap: 0.25rem;
  }
  
  .pagination-btn,
  .pagination-number {
    padding: 0.4rem 0.8rem;
    font-size: 0.9rem;
  }
  
  .tag-cloud {
    gap: 0.3rem;
  }
}
</style>