<template>
  <article class="article-card fade-in" @click="goToArticle">
    <div class="article-cover" v-if="article.cover">
      <img :src="article.cover" :alt="article.title" loading="lazy">
      <div class="article-overlay">
        <div class="article-category">{{ article.category }}</div>
      </div>
    </div>
    
    <div class="article-content">
      <div class="article-meta">
        <span class="meta-category">{{ article.category }}</span>
        <span class="meta-date">{{ formatDate(article.date) }}</span>
      </div>
      
      <h2 class="article-title">{{ article.title }}</h2>
      
      <p class="article-summary">{{ article.summary }}</p>
      
      <div class="article-tags">
        <span 
          v-for="tag in article.tags" 
          :key="tag" 
          class="tag"
          @click.stop="goToTag(tag)"
        >
          {{ tag }}
        </span>
      </div>
      
      <div class="article-footer">
        <div class="article-stats">
          <span class="stat">
            <i class="icon">👁️</i>
            {{ formatNumber(article.views) }}
          </span>
          <span class="stat">
            <i class="icon">❤️</i>
            {{ formatNumber(article.likes) }}
          </span>
        </div>
        
        <div class="read-more">
          <span>阅读更多</span>
          <i class="icon">→</i>
        </div>
      </div>
    </div>
  </article>
</template>

<script setup>
import { useRouter } from 'vue-router'

const props = defineProps({
  article: {
    type: Object,
    required: true
  }
})

const router = useRouter()

const goToArticle = () => {
  router.push({ name: 'Article', params: { id: props.article.id } })
}

const goToTag = (tag) => {
  router.push({ name: 'Search', query: { tag } })
}

const formatDate = (dateString) => {
  const date = new Date(dateString)
  const now = new Date()
  const diff = now - date
  const days = Math.floor(diff / (1000 * 60 * 60 * 24))
  
  if (days === 0) return '今天'
  if (days === 1) return '昨天'
  if (days < 7) return `${days}天前`
  if (days < 30) return `${Math.floor(days / 7)}周前`
  if (days < 365) return `${Math.floor(days / 30)}个月前`
  
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
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
.article-card {
  background: var(--bg-glass);
  backdrop-filter: blur(10px);
  border-radius: var(--border-radius-xl);
  overflow: hidden;
  box-shadow: var(--shadow);
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: var(--transition);
  cursor: pointer;
  height: 100%;
  display: flex;
  flex-direction: column;
  position: relative;
}

.article-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: var(--gradient-1);
  transform: scaleX(0);
  transition: transform 0.3s ease;
}

.article-card:hover::before {
  transform: scaleX(1);
}

.article-card:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: var(--shadow-hover);
}

.article-card:hover .read-more {
  transform: translateX(4px);
}

.article-cover {
  position: relative;
  height: 200px;
  overflow: hidden;
  background: var(--bg-secondary);
}

.article-cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: var(--transition);
}

.article-card:hover .article-cover img {
  transform: scale(1.05);
}

.article-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  padding: 1rem;
  background: linear-gradient(to bottom, rgba(0,0,0,0.7), transparent);
}

.article-category {
  display: inline-block;
  background: var(--primary-color);
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: var(--border-radius-sm);
  font-size: 0.8rem;
  font-weight: 500;
}

.article-content {
  padding: 1.5rem;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.article-meta {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 1rem;
}

.meta-category {
  color: var(--primary-color);
  font-size: 0.85rem;
  font-weight: 600;
}

.meta-date {
  color: var(--text-tertiary);
  font-size: 0.8rem;
}

.article-title {
  color: var(--text-primary);
  font-size: 1.25rem;
  font-weight: 700;
  line-height: 1.4;
  margin-bottom: 1rem;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  box-orient: vertical;
  overflow: hidden;
  transition: var(--transition-fast);
}

.article-card:hover .article-title {
  color: var(--primary-color);
}

.article-summary {
  color: var(--text-secondary);
  font-size: 0.9rem;
  line-height: 1.6;
  margin-bottom: 1rem;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  line-clamp: 3;
  -webkit-box-orient: vertical;
  box-orient: vertical;
  overflow: hidden;
  flex: 1;
}

.article-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.tag {
  background: var(--primary-light);
  color: var(--primary-color);
  padding: 0.2rem 0.6rem;
  border-radius: var(--border-radius-sm);
  font-size: 0.75rem;
  font-weight: 500;
  cursor: pointer;
  transition: var(--transition-fast);
  border: 1px solid transparent;
}

.tag:hover {
  background: var(--primary-color);
  color: white;
  transform: translateY(-1px);
}

.article-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 1rem;
  border-top: 1px solid var(--border-lighter);
}

.article-stats {
  display: flex;
  gap: 1rem;
}

.stat {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  color: var(--text-tertiary);
  font-size: 0.8rem;
}

.stat .icon {
  font-size: 0.9rem;
}

.read-more {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  color: var(--primary-color);
  font-size: 0.85rem;
  font-weight: 500;
  transition: var(--transition-fast);
}

/* 没有封面图的卡片样式 */
.article-card:not(:has(.article-cover)) .article-content {
  padding: 2rem;
}

/* 响应式 */
@media (max-width: 768px) {
  .article-content {
    padding: 1rem;
  }
  
  .article-card:not(:has(.article-cover)) .article-content {
    padding: 1.5rem;
  }
  
  .article-title {
    font-size: 1.1rem;
  }
  
  .article-cover {
    height: 150px;
  }
  
  .article-footer {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.5rem;
  }
  
  .article-stats {
    gap: 0.75rem;
  }
}

@media (max-width: 480px) {
  .article-meta {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.25rem;
  }
  
  .article-tags {
    gap: 0.25rem;
  }
  
  .tag {
    font-size: 0.7rem;
    padding: 0.15rem 0.5rem;
  }
}
</style>