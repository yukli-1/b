<template>
  <div class="archive-page">
    <div class="container">
      <header class="page-header">
        <h1 class="page-title">文章</h1>
        <p class="page-description">按时间线浏览所有文章</p>
      </header>

      <div class="archive-content">
        <div 
          v-for="(monthData, date) in archiveDates" 
          :key="date"
          class="archive-month"
        >
          <div class="archive-header">
            <h2 class="archive-title">
              <span class="year">{{ monthData.year }}</span>
              <span class="month">{{ monthData.month }}月</span>
            </h2>
            <span class="article-count">{{ monthData.articles.length }} 篇文章</span>
          </div>
          
          <div class="archive-list">
            <article 
              v-for="article in monthData.articles" 
              :key="article.id"
              class="archive-item"
              @click="goToArticle(article.id)"
            >
              <div class="archive-date">
                <span class="day">{{ new Date(article.date).getDate() }}</span>
              </div>
              <div class="archive-info">
                <h3 class="article-title">{{ article.title }}</h3>
                <div class="article-meta">
                  <span class="category">{{ article.category }}</span>
                  <span class="views">{{ article.views }} 阅读</span>
                  <span class="likes">{{ formatNumber(article.likes) }} 点赞</span>
                </div>
              </div>
            </article>
          </div>
        </div>

        <div v-if="Object.keys(archiveDates).length === 0" class="empty-state">
          <div class="empty-icon">📭</div>
          <h3>暂无文章</h3>
          <p>还没有发布任何文章</p>
        </div>
      </div>

      <!-- 统计信息 -->
      <aside class="archive-stats">
        <div class="stats-card">
          <h3>文章统计</h3>
          <div class="stats-grid">
            <div class="stat-item">
              <span class="stat-number">{{ blogStore.articles.length }}</span>
              <span class="stat-label">总文章数</span>
            </div>
            <div class="stat-item">
              <span class="stat-number">{{ Object.keys(archiveDates).length }}</span>
              <span class="stat-label">月份</span>
            </div>
            <div class="stat-item">
              <span class="stat-number">{{ totalViews }}</span>
              <span class="stat-label">总阅读量</span>
            </div>
            <div class="stat-item">
              <span class="stat-number">{{ totalLikes }}</span>
              <span class="stat-label">总点赞数</span>
            </div>
          </div>
        </div>
      </aside>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useBlogStore } from '../stores/blog'

const router = useRouter()
const blogStore = useBlogStore()

const archiveDates = computed(() => blogStore.getArchiveDates)

const totalViews = computed(() => 
  blogStore.articles.reduce((sum, article) => sum + article.views, 0)
)

const totalLikes = computed(() => {
  const total = blogStore.articles.reduce((sum, article) => sum + article.likes, 0)
  // 确保所有数字都显示为100以上
  if (total < 100) {
    return '100+'
  } else if (total >= 10000) {
    return Math.floor(total / 100) + '00+'
  } else {
    return Math.floor(total / 100) * 100 + '+'
  }
})

const goToArticle = (id) => {
  router.push({ name: 'Article', params: { id } })
}

const formatNumber = (num) => {
  // 确保所有数字都显示为100以上
  if (num < 100) {
    return '100+'
  } else if (num >= 10000) {
    return Math.floor(num / 100) + '00+'
  } else {
    return Math.floor(num / 100) * 100 + '+'
  }
}
</script>

<style scoped>
.archive-page {
  padding: 2rem 0;
}

.page-header {
  text-align: center;
  margin-bottom: 3rem;
}

.page-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 1rem;
}

.page-description {
  font-size: 1.1rem;
  color: var(--text-secondary);
}

.archive-content {
  max-width: 800px;
  margin: 0 auto 3rem;
}

.archive-month {
  margin-bottom: 3rem;
}

.archive-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 1rem;
  border-bottom: 2px solid var(--primary-color);
  margin-bottom: 1.5rem;
}

.archive-title {
  font-size: 1.5rem;
  font-weight: 600;
  color: var(--text-primary);
  display: flex;
  align-items: baseline;
  gap: 0.5rem;
}

.year {
  font-size: 1.8rem;
  color: var(--primary-color);
}

.month {
  font-size: 1.3rem;
}

.article-count {
  color: var(--text-secondary);
  font-size: 0.9rem;
}

.archive-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.archive-item {
  display: flex;
  align-items: center;
  background: var(--bg-color);
  border: 1px solid var(--border-light);
  border-radius: var(--border-radius);
  padding: 1.5rem;
  transition: var(--transition);
  cursor: pointer;
}

.archive-item:hover {
  box-shadow: var(--shadow);
  transform: translateX(4px);
  border-color: var(--primary-color);
}

.archive-date {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-right: 1.5rem;
  padding: 0.5rem;
  background: var(--primary-light);
  border-radius: var(--border-radius-sm);
  min-width: 60px;
}

.day {
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--primary-color);
  line-height: 1;
}

.archive-info {
  flex: 1;
}

.archive-item .article-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 0.5rem;
  line-height: 1.4;
}

.article-meta {
  display: flex;
  gap: 1rem;
  font-size: 0.85rem;
  color: var(--text-tertiary);
}

.category {
  color: var(--primary-color);
  font-weight: 500;
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

.archive-stats {
  max-width: 800px;
  margin: 0 auto;
}

.stats-card {
  background: var(--bg-color);
  border: 1px solid var(--border-light);
  border-radius: var(--border-radius);
  padding: 2rem;
  box-shadow: var(--shadow);
}

.stats-card h3 {
  font-size: 1.3rem;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 1.5rem;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 1.5rem;
}

.stat-item {
  text-align: center;
  padding: 1rem;
  background: var(--bg-secondary);
  border-radius: var(--border-radius);
  transition: var(--transition);
}

.stat-item:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-sm);
}

.stat-number {
  display: block;
  font-size: 2rem;
  font-weight: 700;
  color: var(--primary-color);
  margin-bottom: 0.5rem;
}

.stat-label {
  font-size: 0.9rem;
  color: var(--text-secondary);
}

@media (max-width: 768px) {
  .archive-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }
  
  .archive-date {
    margin-right: 0;
    margin-bottom: 0.5rem;
  }
  
  .article-meta {
    flex-wrap: wrap;
  }
  
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .archive-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.5rem;
  }
}

@media (max-width: 480px) {
  .page-title {
    font-size: 2rem;
  }
  
  .archive-item {
    padding: 1rem;
  }
  
  .stats-grid {
    grid-template-columns: 1fr;
  }
}
</style>