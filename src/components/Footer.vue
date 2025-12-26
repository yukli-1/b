<template>
  <footer class="footer">
    <div class="container">
      <div class="footer-content">
        <div class="footer-section">
          <h3 class="footer-title">关于博客</h3>
          <p class="footer-description">
            分享前端开发经验，记录学习心得，探讨技术前沿。
            专注于Vue.js、React、JavaScript等前端技术。
          </p>
          <div class="social-links">
            <a href="#" class="social-link" title="GitHub">
              <i class="icon">🐙</i>
            </a>
            <a href="#" class="social-link" title="Twitter">
              <i class="icon">🐦</i>
            </a>
            <a href="#" class="social-link" title="Email">
              <i class="icon">📧</i>
            </a>
            <a href="#" class="social-link" title="RSS">
              <i class="icon">📡</i>
            </a>
          </div>
        </div>
        
        <div class="footer-section">
          <h3 class="footer-title">快速链接</h3>
          <ul class="footer-links">
            <li><router-link to="/">首页</router-link></li>
            <li><router-link to="/archive">文章</router-link></li>
            <li><router-link to="/category">分类目录</router-link></li>
            <li><router-link to="/about">关于我</router-link></li>
          </ul>
        </div>
        
        <div class="footer-section">
          <h3 class="footer-title">技术栈</h3>
          <ul class="tech-stack">
            <li>Vue.js</li>
            <li>JavaScript</li>
            <li>TypeScript</li>
            <li>CSS3</li>
            <li>Node.js</li>
          </ul>
        </div>
        
        <div class="footer-section">
          <h3 class="footer-title">联系信息</h3>
          <div class="contact-info">
            <p><i class="icon">📧</i> contact@myblog.com</p>
            <p><i class="icon">🌍</i> www.myblog.com</p>
            <p><i class="icon">📍</i> 中国·北京</p>
          </div>
        </div>
      </div>
      
      <div class="footer-bottom">
        <div class="footer-copyright">
          <p>&copy; 2025 我的技术博客. All rights reserved.</p>
        </div>
        <div class="footer-stats">
          <span>📊 <span id="visitor-count">1,234</span> 访客</span>
          <span>📝 <span id="article-count">{{ articleCount }}</span> 文章</span>
          <span>💬 <span id="comment-count">456</span> 评论</span>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup>
import { computed } from 'vue'
import { useBlogStore } from '../stores/blog'

const blogStore = useBlogStore()

const articleCount = computed(() => blogStore.articles.length)
</script>

<style scoped>
.footer {
  background: var(--bg-secondary);
  border-top: 1px solid var(--border-light);
  margin-top: auto;
  padding: 3rem 0 1.5rem;
}

.footer-content {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
  margin-bottom: 2rem;
}

.footer-section {
  text-align: left;
}

.footer-title {
  color: var(--text-primary);
  font-size: 1.1rem;
  font-weight: 600;
  margin-bottom: 1rem;
  position: relative;
  padding-bottom: 0.5rem;
}

.footer-title::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 40px;
  height: 2px;
  background: var(--primary-color);
  border-radius: 1px;
}

.footer-description {
  color: var(--text-secondary);
  line-height: 1.6;
  margin-bottom: 1rem;
  font-size: 0.9rem;
}

.social-links {
  display: flex;
  gap: 0.5rem;
}

.social-link {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  background: var(--bg-color);
  border: 1px solid var(--border-color);
  border-radius: var(--border-radius);
  color: var(--text-secondary);
  text-decoration: none;
  transition: var(--transition-fast);
  font-size: 1.1rem;
}

.social-link:hover {
  background: var(--primary-color);
  color: white;
  border-color: var(--primary-color);
  transform: translateY(-2px);
}

.footer-links {
  list-style: none;
  padding: 0;
}

.footer-links li {
  margin-bottom: 0.5rem;
}

.footer-links a {
  color: var(--text-secondary);
  text-decoration: none;
  transition: var(--transition-fast);
  font-size: 0.9rem;
}

.footer-links a:hover {
  color: var(--primary-color);
  padding-left: 4px;
}

.tech-stack {
  list-style: none;
  padding: 0;
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.tech-stack li {
  background: var(--primary-light);
  color: var(--primary-color);
  padding: 0.25rem 0.75rem;
  border-radius: var(--border-radius-sm);
  font-size: 0.85rem;
  font-weight: 500;
}

.contact-info p {
  color: var(--text-secondary);
  margin-bottom: 0.5rem;
  font-size: 0.9rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.contact-info .icon {
  font-size: 0.9rem;
  width: 16px;
}

.footer-bottom {
  border-top: 1px solid var(--border-color);
  padding-top: 1.5rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
}

.footer-copyright {
  color: var(--text-tertiary);
  font-size: 0.85rem;
}

.footer-stats {
  display: flex;
  gap: 1.5rem;
  color: var(--text-tertiary);
  font-size: 0.85rem;
}

.footer-stats span {
  display: flex;
  align-items: center;
  gap: 0.25rem;
}

/* 响应式 */
@media (max-width: 768px) {
  .footer-content {
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.5rem;
  }
  
  .footer-bottom {
    flex-direction: column;
    text-align: center;
  }
  
  .footer-stats {
    justify-content: center;
    gap: 1rem;
  }
  
  .social-links {
    justify-content: center;
  }
}

@media (max-width: 480px) {
  .footer {
    padding: 2rem 0 1rem;
  }
  
  .footer-content {
    grid-template-columns: 1fr;
    text-align: center;
  }
  
  .footer-title::after {
    left: 50%;
    transform: translateX(-50%);
  }
  
  .tech-stack {
    justify-content: center;
  }
  
  .contact-info {
    text-align: left;
    display: inline-block;
  }
}
</style>