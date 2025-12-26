<template>
  <div class="article-page">
    <div class="container">
      <article class="article">
        <!-- 文章头部 -->
        <header class="article-header">
          <div class="article-breadcrumb">
            <router-link to="/">首页</router-link>
            <span class="separator">/</span>
            <router-link :to="`/category/${article.category}`">{{ article.category }}</router-link>
            <span class="separator">/</span>
            <span class="current">文章详情</span>
          </div>
          
          <h1 class="article-title">{{ article.title }}</h1>
          
          <div class="article-meta">
            <div class="meta-left">
              <span class="meta-item">
                <i class="icon">📅</i>
                {{ formatDate(article.date) }}
              </span>
              <span class="meta-item">
                <i class="icon">📁</i>
                {{ article.category }}
              </span>
              <span class="meta-item">
                <i class="icon">👁️</i>
                {{ formatNumber(article.views) }} 阅读
              </span>
              <span class="meta-item">
                <i class="icon">❤️</i>
                {{ formatNumber(article.likes) }} 点赞
              </span>
            </div>
            
            <div class="meta-right">
              <button class="btn btn-sm" @click="likeArticle" :class="{ 'liked': isLiked }">
                <i class="icon">{{ isLiked ? '❤️' : '🤍' }}</i>
                {{ isLiked ? '已点赞' : '点赞' }}
              </button>
              <button class="btn btn-sm" @click="shareArticle">
                <i class="icon">📤</i>
                分享
              </button>
            </div>
          </div>
        </header>

        <!-- 文章内容 -->
        <div class="article-content">
          <div class="content-wrapper" v-html="articleContent"></div>
        </div>

        <!-- 文章标签 -->
        <footer class="article-footer">
          <div class="article-tags">
            <i class="icon">🏷️</i>
            <div class="tags">
              <router-link 
                v-for="tag in article.tags" 
                :key="tag"
                :to="{ name: 'Search', query: { tag } }"
                class="tag"
              >
                {{ tag }}
              </router-link>
            </div>
          </div>
        </footer>
      </article>

      <!-- 相关文章 -->
      <section class="related-articles">
        <h2 class="section-title">
          <i class="icon">📚</i>
          相关文章
        </h2>
        <div class="related-grid">
          <ArticleCard 
            v-for="relatedArticle in relatedArticles" 
            :key="relatedArticle.id"
            :article="relatedArticle"
          />
        </div>
      </section>

      <!-- 评论区 -->
      <section class="comments-section">
        <h2 class="section-title">
          <i class="icon">💬</i>
          评论区
        </h2>
        
        <!-- 评论输入 -->
        <div class="comment-form">
          <div class="form-group">
            <textarea 
              v-model="commentText"
              placeholder="发表你的看法..."
              rows="3"
              class="comment-input"
            ></textarea>
          </div>
          <div class="form-actions">
            <button 
              class="btn btn-primary"
              @click="submitComment"
              :disabled="!commentText.trim()"
            >
              发表评论
            </button>
          </div>
        </div>

        <!-- 评论列表 -->
        <div class="comments-list">
          <div v-for="comment in comments" :key="comment.id" class="comment-item">
            <div class="comment-avatar">
              <img :src="comment.avatar" :alt="comment.name">
            </div>
            <div class="comment-content">
              <div class="comment-header">
                <span class="comment-name">{{ comment.name }}</span>
                <span class="comment-time">{{ formatCommentTime(comment.time) }}</span>
              </div>
              <div class="comment-text">{{ comment.text }}</div>
              <div class="comment-actions">
                <button class="comment-btn" @click="likeComment(comment.id)">
                  <i class="icon">👍</i>
                  {{ comment.likes }}
                </button>
                <button class="comment-btn" @click="replyComment(comment.id)">
                  <i class="icon">💬</i>
                  回复
                </button>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useBlogStore } from '../stores/blog'
import ArticleCard from '../components/ArticleCard.vue'

const route = useRoute()
const blogStore = useBlogStore()

const isLiked = ref(false)
const commentText = ref('')
const comments = ref([
  {
    id: 1,
    name: '技术爱好者',
    avatar: '/images/avatar.jpg',
    text: '写得很详细，学到了很多！特别是对Vue3组合式API的解释很到位。',
    time: new Date('2025-12-24T10:30:00'),
    likes: 12
  },
  {
    id: 2,
    name: '前端新手',
    avatar: '/images/avatar.jpg',
    text: '作为初学者，这篇文章对我帮助很大。希望能看到更多这样的教程。',
    time: new Date('2025-12-24T14:20:00'),
    likes: 8
  }
])

const article = computed(() => {
  const id = parseInt(route.params.id)
  return blogStore.getArticleById(id) || {
    id: 0,
    title: '文章不存在',
    content: '抱歉，您查找的文章不存在。',
    category: '',
    tags: [],
    date: new Date().toISOString(),
    views: 0,
    likes: 0
  }
})

const articleContent = computed(() => {
  return article.value.content.replace(/\n/g, '<br>')
})

const relatedArticles = computed(() => {
  return blogStore.articles
    .filter(a => a.id !== article.value.id && a.category === article.value.category)
    .slice(0, 3)
})

const formatDate = (dateString) => {
  const date = new Date(dateString)
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

const formatCommentTime = (time) => {
  const now = new Date()
  const diff = now - time
  const minutes = Math.floor(diff / 60000)
  const hours = Math.floor(diff / 3600000)
  const days = Math.floor(diff / 86400000)

  if (minutes < 1) return '刚刚'
  if (minutes < 60) return `${minutes}分钟前`
  if (hours < 24) return `${hours}小时前`
  if (days < 30) return `${days}天前`
  
  return time.toLocaleDateString('zh-CN')
}

const likeArticle = () => {
  isLiked.value = !isLiked.value
  if (isLiked.value) {
    article.value.likes++
  } else {
    article.value.likes--
  }
}

const shareArticle = () => {
  if (navigator.share) {
    navigator.share({
      title: article.value.title,
      text: article.value.summary,
      url: window.location.href
    })
  } else {
    navigator.clipboard.writeText(window.location.href)
    alert('链接已复制到剪贴板')
  }
}

const submitComment = () => {
  if (!commentText.value.trim()) return
  
  const newComment = {
    id: comments.value.length + 1,
    name: '访客',
    avatar: '/images/avatar.jpg',
    text: commentText.value,
    time: new Date(),
    likes: 0
  }
  
  comments.value.unshift(newComment)
  commentText.value = ''
}

const likeComment = (commentId) => {
  const comment = comments.value.find(c => c.id === commentId)
  if (comment) {
    comment.likes++
  }
}

const replyComment = (commentId) => {
  const comment = comments.value.find(c => c.id === commentId)
  if (comment) {
    commentText.value = `@${comment.name} `
  }
}

onMounted(() => {
  // 增加阅读量
  if (article.value.id > 0) {
    article.value.views++
  }
})
</script>

<style scoped>
.article-page {
  padding: 2rem 0;
}

.article {
  background: var(--bg-color);
  border-radius: var(--border-radius-lg);
  box-shadow: var(--shadow);
  border: 1px solid var(--border-light);
  overflow: hidden;
  margin-bottom: 3rem;
}

.article-header {
  padding: 2rem;
  border-bottom: 1px solid var(--border-lighter);
}

.article-breadcrumb {
  display: flex;
  align-items: center;
  margin-bottom: 1.5rem;
  font-size: 0.9rem;
}

.article-breadcrumb a {
  color: var(--text-secondary);
  text-decoration: none;
  transition: var(--transition-fast);
}

.article-breadcrumb a:hover {
  color: var(--primary-color);
}

.separator {
  margin: 0 0.5rem;
  color: var(--text-tertiary);
}

.current {
  color: var(--text-primary);
  font-weight: 500;
}

.article-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: var(--text-primary);
  line-height: 1.3;
  margin-bottom: 1.5rem;
}

.article-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
}

.meta-left {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  color: var(--text-secondary);
  font-size: 0.9rem;
}

.meta-item .icon {
  font-size: 0.9rem;
}

.meta-right {
  display: flex;
  gap: 0.5rem;
}

.btn-sm {
  padding: 0.5rem 1rem;
  font-size: 0.85rem;
}

.btn.liked {
  background: var(--danger-color);
  color: white;
}

.article-content {
  padding: 2rem;
}

.content-wrapper {
  font-size: 1.1rem;
  line-height: 1.8;
  color: var(--text-primary);
}

.content-wrapper :deep(h1),
.content-wrapper :deep(h2),
.content-wrapper :deep(h3),
.content-wrapper :deep(h4),
.content-wrapper :deep(h5),
.content-wrapper :deep(h6) {
  color: var(--text-primary);
  margin: 2rem 0 1rem;
  font-weight: 600;
}

.content-wrapper :deep(p) {
  margin-bottom: 1rem;
}

.content-wrapper :deep(pre) {
  background: var(--bg-secondary);
  border: 1px solid var(--border-color);
  border-radius: var(--border-radius);
  padding: 1rem;
  overflow-x: auto;
  margin: 1rem 0;
}

.content-wrapper :deep(code) {
  background: var(--bg-secondary);
  padding: 0.2rem 0.4rem;
  border-radius: var(--border-radius-sm);
  font-size: 0.9rem;
}

.article-footer {
  padding: 2rem;
  border-top: 1px solid var(--border-lighter);
}

.article-tags {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.article-tags .icon {
  font-size: 1.2rem;
}

.tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

/* 相关文章 */
.related-articles {
  margin-bottom: 3rem;
}

.section-title {
  font-size: 1.5rem;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 2rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.related-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}

/* 评论区 */
.comments-section {
  background: var(--bg-color);
  border-radius: var(--border-radius-lg);
  box-shadow: var(--shadow);
  border: 1px solid var(--border-light);
  padding: 2rem;
}

.comment-form {
  margin-bottom: 2rem;
  padding-bottom: 2rem;
  border-bottom: 1px solid var(--border-lighter);
}

.form-group {
  margin-bottom: 1rem;
}

.comment-input {
  width: 100%;
  padding: 1rem;
  border: 1px solid var(--border-color);
  border-radius: var(--border-radius);
  background: var(--bg-color);
  color: var(--text-primary);
  font-size: 1rem;
  resize: vertical;
  transition: var(--transition-fast);
}

.comment-input:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

.form-actions {
  display: flex;
  justify-content: flex-end;
}

.comments-list {
  margin-top: 2rem;
}

.comment-item {
  display: flex;
  gap: 1rem;
  margin-bottom: 1.5rem;
  padding: 1.5rem;
  background: var(--bg-secondary);
  border-radius: var(--border-radius);
  transition: var(--transition-fast);
}

.comment-item:hover {
  box-shadow: var(--shadow);
}

.comment-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  overflow: hidden;
  flex-shrink: 0;
}

.comment-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.comment-content {
  flex: 1;
}

.comment-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.5rem;
}

.comment-name {
  font-weight: 600;
  color: var(--text-primary);
}

.comment-time {
  font-size: 0.85rem;
  color: var(--text-tertiary);
}

.comment-text {
  color: var(--text-primary);
  line-height: 1.6;
  margin-bottom: 1rem;
}

.comment-actions {
  display: flex;
  gap: 1rem;
}

.comment-btn {
  background: none;
  border: none;
  color: var(--text-secondary);
  cursor: pointer;
  font-size: 0.85rem;
  display: flex;
  align-items: center;
  gap: 0.25rem;
  transition: var(--transition-fast);
}

.comment-btn:hover {
  color: var(--primary-color);
}

/* 响应式 */
@media (max-width: 768px) {
  .article-page {
    padding: 1rem 0;
  }
  
  .article-header,
  .article-content,
  .article-footer {
    padding: 1.5rem;
  }
  
  .article-title {
    font-size: 1.8rem;
  }
  
  .article-meta {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .meta-left {
    flex-direction: column;
    gap: 0.5rem;
  }
  
  .content-wrapper {
    font-size: 1rem;
  }
  
  .related-grid {
    grid-template-columns: 1fr;
  }
  
  .comments-section {
    padding: 1.5rem;
  }
  
  .comment-item {
    padding: 1rem;
  }
}

@media (max-width: 480px) {
  .article-header,
  .article-content,
  .article-footer {
    padding: 1rem;
  }
  
  .article-title {
    font-size: 1.5rem;
  }
  
  .comments-section {
    padding: 1rem;
  }
  
  .comment-avatar {
    width: 40px;
    height: 40px;
  }
}
</style>