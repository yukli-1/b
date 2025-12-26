<template>
  <div class="search-page">
    <div class="container">
      <header class="page-header">
        <h1 class="page-title">搜索结果</h1>
        <div class="search-box">
          <input 
            v-model="searchQuery" 
            type="text" 
            placeholder="搜索文章..." 
            @input="handleSearchInput"
            @keyup.enter="handleSearch"
            ref="searchInput"
          >
          <button @click="handleSearch" class="search-btn">
            <i class="icon">🔍</i>
          </button>
        </div>
      </header>

      <main class="main-content">
        <div v-if="isLoading" class="loading-state">
          <div class="loading-spinner"></div>
          <p>正在搜索...</p>
        </div>

        <div v-else-if="searchQuery" class="search-results">
          <div class="results-info">
            <p>找到 <strong>{{ searchResults.length }}</strong> 个相关结果</p>
            <div class="search-filters">
              <button 
                v-for="tag in popularTags" 
                :key="tag"
                class="tag-filter"
                @click="searchByTag(tag)"
              >
                {{ tag }}
              </button>
            </div>
          </div>

          <div v-if="searchResults.length > 0" class="results-grid">
            <transition-group name="fade" tag="div" class="results-list">
              <ArticleCard 
                v-for="article in searchResults" 
                :key="article.id"
                :article="article"
                class="result-item"
              />
            </transition-group>
          </div>

          <div v-else class="empty-results">
            <div class="empty-icon">🔍</div>
            <h3>没有找到相关文章</h3>
            <p>
              没有找到与 "{{ searchQuery }}" 相关的文章
              <br>
              试试其他关键词或查看热门标签
            </p>
            <button class="btn btn-primary" @click="clearSearch">
              清除搜索
            </button>
          </div>
        </div>

        <div v-else class="search-suggestions">
          <div class="suggestions-header">
            <h2>搜索建议</h2>
            <p>输入关键词搜索文章，或者点击下方热门标签</p>
          </div>

          <div class="popular-tags">
            <h3>🏷️ 热门标签</h3>
            <div class="tags-cloud">
              <button 
                v-for="tag in popularTags" 
                :key="tag"
                class="tag-cloud-item"
                @click="searchByTag(tag)"
              >
                {{ tag }}
              </button>
            </div>
          </div>

          <div class="recent-articles">
            <h3>📝 最新文章</h3>
            <div class="recent-list">
              <router-link 
                v-for="article in recentArticles" 
                :key="article.id"
                :to="{ name: 'Article', params: { id: article.id } }"
                class="recent-item"
              >
                <h4>{{ article.title }}</h4>
                <p>{{ article.summary }}</p>
                <div class="item-meta">
                  <span class="category">{{ article.category }}</span>
                  <span class="date">{{ formatDate(article.date) }}</span>
                </div>
              </router-link>
            </div>
          </div>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useBlogStore } from '../stores/blog'
import ArticleCard from '../components/ArticleCard.vue'

const route = useRoute()
const router = useRouter()
const blogStore = useBlogStore()

const searchQuery = ref('')
const searchInput = ref(null)
const isLoading = ref(false)

const searchResults = computed(() => {
  if (!searchQuery.value || searchQuery.value.trim().length < 2) return []
  return blogStore.searchArticles(searchQuery.value)
})

const popularTags = computed(() => 
  blogStore.tags.slice(0, 8).map(tag => tag.name)
)

const recentArticles = computed(() => 
  [...blogStore.articles].sort((a, b) => new Date(b.date) - new Date(a.date)).slice(0, 5)
)

// 防抖函数
const debounce = (func, wait) => {
  let timeout
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout)
      func(...args)
    }
    clearTimeout(timeout)
    timeout = setTimeout(later, wait)
  }
}

const handleSearch = debounce(async () => {
  if (!searchQuery.value.trim()) return
  
  isLoading.value = true
  
  // 模拟搜索延迟
  await new Promise(resolve => setTimeout(resolve, 500))
  
  isLoading.value = false
  
  // 更新URL参数
  router.push({ query: { q: searchQuery.value } })
}, 300)

const searchByTag = (tag) => {
  searchQuery.value = tag
  handleSearch()
}

const handleSearchInput = () => {
  if (searchQuery.value.trim().length >= 2) {
    handleSearch()
  }
}

const clearSearch = () => {
  searchQuery.value = ''
  router.push({ query: {} })
}

const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

onMounted(() => {
  // 从URL参数获取搜索关键词
  const query = route.query.q || route.query.tag
  if (query) {
    searchQuery.value = query
    handleSearch()
  }
  
  // 自动聚焦搜索框
  searchInput.value?.focus()
})
</script>

<style scoped>
.search-page {
  padding: 2rem 0;
  min-height: calc(100vh - 70px);
}

.page-header {
  text-align: center;
  margin-bottom: 3rem;
}

.page-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 2rem;
}

.search-box {
  display: flex;
  max-width: 600px;
  margin: 0 auto;
  background: var(--bg-color);
  border: 2px solid var(--border-color);
  border-radius: var(--border-radius-lg);
  overflow: hidden;
  transition: var(--transition-fast);
}

.search-box:focus-within {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 3px rgba(64, 158, 255, 0.1);
}

.search-box input {
  flex: 1;
  border: none;
  outline: none;
  padding: 1rem 1.5rem;
  font-size: 1.1rem;
  background: transparent;
  color: var(--text-primary);
}

.search-box input::placeholder {
  color: var(--text-placeholder);
}

.search-btn {
  background: var(--primary-color);
  border: none;
  color: white;
  padding: 1rem 1.5rem;
  cursor: pointer;
  transition: var(--transition-fast);
  font-size: 1.2rem;
}

.search-btn:hover {
  background: #66b1ff;
}

.loading-state {
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

@keyframes spin {
  to { transform: rotate(360deg); }
}

.search-results {
  margin-bottom: 2rem;
}

.results-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid var(--border-light);
  flex-wrap: wrap;
  gap: 1rem;
}

.results-info p {
  font-size: 1.1rem;
  color: var(--text-primary);
}

.search-filters {
  display: flex;
  gap: 0.5rem;
  flex-wrap: wrap;
}

.tag-filter {
  padding: 0.5rem 1rem;
  background: var(--primary-light);
  color: var(--primary-color);
  border: 1px solid var(--primary-color);
  border-radius: var(--border-radius);
  cursor: pointer;
  transition: var(--transition-fast);
  font-size: 0.9rem;
}

.tag-filter:hover {
  background: var(--primary-color);
  color: white;
}

.results-grid {
  width: 100%;
}

.empty-results {
  text-align: center;
  padding: 3rem;
  color: var(--text-secondary);
}

.empty-icon {
  font-size: 4rem;
  margin-bottom: 1rem;
}

.empty-results h3 {
  font-size: 1.5rem;
  margin-bottom: 1rem;
  color: var(--text-primary);
}

.empty-results p {
  margin-bottom: 2rem;
  line-height: 1.6;
}

.search-suggestions {
  max-width: 800px;
  margin: 0 auto;
}

.suggestions-header {
  text-align: center;
  margin-bottom: 3rem;
}

.suggestions-header h2 {
  font-size: 2rem;
  color: var(--text-primary);
  margin-bottom: 0.5rem;
}

.suggestions-header p {
  color: var(--text-secondary);
  font-size: 1.1rem;
}

.popular-tags {
  margin-bottom: 3rem;
}

.popular-tags h3 {
  font-size: 1.3rem;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 1.5rem;
  text-align: center;
}

.tags-cloud {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 1rem;
}

.tag-cloud-item {
  padding: 0.75rem 1.5rem;
  background: var(--bg-color);
  border: 1px solid var(--border-color);
  border-radius: var(--border-radius);
  color: var(--text-primary);
  cursor: pointer;
  transition: var(--transition-fast);
  font-weight: 500;
  font-size: 1rem;
}

.tag-cloud-item:hover {
  background: var(--primary-color);
  color: white;
  border-color: var(--primary-color);
  transform: translateY(-2px);
  box-shadow: var(--shadow);
}

.recent-articles {
  margin-bottom: 2rem;
}

.recent-articles h3 {
  font-size: 1.3rem;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 1.5rem;
  text-align: center;
}

.recent-list {
  display: grid;
  gap: 1.5rem;
}

.recent-item {
  display: block;
  background: var(--bg-color);
  border: 1px solid var(--border-light);
  border-radius: var(--border-radius);
  padding: 1.5rem;
  text-decoration: none;
  color: var(--text-primary);
  transition: var(--transition);
}

.recent-item:hover {
  box-shadow: var(--shadow);
  border-color: var(--primary-color);
  transform: translateY(-2px);
}

.recent-item h4 {
  font-size: 1.1rem;
  font-weight: 600;
  margin-bottom: 0.5rem;
  color: var(--text-primary);
}

.recent-item p {
  color: var(--text-secondary);
  font-size: 0.9rem;
  line-height: 1.5;
  margin-bottom: 1rem;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
}

.item-meta {
  display: flex;
  gap: 1rem;
  font-size: 0.85rem;
}

.category {
  color: var(--primary-color);
  font-weight: 500;
}

.date {
  color: var(--text-tertiary);
}

/* 过渡动画 */
.fade-enter-active,
.fade-leave-active {
  transition: all 0.3s ease;
}

.fade-enter-from {
  opacity: 0;
  transform: translateY(20px);
}

.fade-leave-to {
  opacity: 0;
  transform: translateY(-20px);
}

.fade-move {
  transition: transform 0.3s ease;
}

/* 优化结果列表 */
.results-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 2rem;
}

.result-item {
  transition: all 0.3s ease;
}

.result-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

/* 响应式 */
@media (max-width: 768px) {
  .page-title {
    font-size: 2rem;
  }
  
  .search-box {
    margin: 0 1rem;
  }
  
  .search-box input {
    font-size: 1rem;
    padding: 0.75rem 1rem;
  }
  
  .results-info {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }
  
  .search-filters {
    width: 100%;
  }
  
  .results-list {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }
  
  .suggestions-header {
    margin: 0 1rem 2rem;
  }
  
  .tags-cloud {
    gap: 0.5rem;
  }
  
  .tag-cloud-item {
    padding: 0.5rem 1rem;
    font-size: 0.9rem;
  }
}

@media (max-width: 480px) {
  .search-page {
    padding: 1rem 0;
  }
  
  .page-header {
    margin-bottom: 2rem;
  }
  
  .page-title {
    font-size: 1.5rem;
  }
  
  .search-box input {
    padding: 0.5rem 0.75rem;
  }
  
  .search-btn {
    padding: 0.5rem 0.75rem;
  }
  
  .recent-item {
    padding: 1rem;
  }
}
</style>