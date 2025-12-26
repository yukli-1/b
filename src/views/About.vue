<template>
  <div class="about-page">
    <div class="container">
      <header class="page-header">
        <h1 class="page-title">关于我</h1>
        <p class="page-subtitle">热爱编程学习，追求技术进步</p>
      </header>

      <div class="content-layout">
        <main class="main-content">
          <!-- 个人信息卡片 -->
          <section class="profile-section">
            <div class="profile-card">
              <div class="profile-avatar">
                <img src="/images/avatar.jpg" alt="头像">
              </div>
              <div class="profile-info">
                <h2 class="profile-name">计算机系学生</h2>
                <p class="profile-title">前端开发学习者</p>
                <div class="profile-bio">
                  <p>计算机系在读学生，专注学习前端开发技术。</p>
                  <p>热爱编程，喜欢在课余时间钻研新技术，致力于成为优秀的前端开发工程师。</p>
                </div>
                <div class="profile-skills">
                  <h3>技术栈</h3>
                  <div class="skills-grid">
                    <div class="skill-item">
                      <span class="skill-icon">⚛️</span>
                      <span class="skill-name">Vue.js</span>
                    </div>
                    <div class="skill-item">
                      <span class="skill-icon">⚛️</span>
                      <span class="skill-name">React</span>
                    </div>
                    <div class="skill-item">
                      <span class="skill-icon">📝</span>
                      <span class="skill-name">TypeScript</span>
                    </div>
                    <div class="skill-item">
                      <span class="skill-icon">🎨</span>
                      <span class="skill-name">CSS3</span>
                    </div>
                    <div class="skill-item">
                      <span class="skill-icon">🔧</span>
                      <span class="skill-name">Node.js</span>
                    </div>
                    <div class="skill-item">
                      <span class="skill-icon">📦</span>
                      <span class="skill-name">Webpack</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </section>

          <!-- 学习经历 -->
          <section class="experience-section">
            <h2 class="section-title">学习经历</h2>
            <div class="timeline">
              <div class="timeline-item">
                <div class="timeline-marker"></div>
                <div class="timeline-content">
                  <h3>计算机专业</h3>
                  <p class="timeline-company">某大学</p>
                  <p class="timeline-description">
                    系统学习编程基础和数据结构算法。
                    积极参与深入前端开发技术。
                  </p>
                </div>
              </div>
              
              <div class="timeline-item">
                <div class="timeline-marker"></div>
                <div class="timeline-content">
                  <h3>前端开发课程</h3>
                  <p class="timeline-company">在线学习平台</p>
                  <p class="timeline-description">
                    通过在线课程系统学习Vue、React等现代前端框架，
                    完成多个实战项目，积累了丰富的开发经验。
                  </p>
                </div>
              </div>
              
              <div class="timeline-item">
                <div class="timeline-marker"></div>
                <div class="timeline-content">
                  <h3>编程入门</h3>
                  <p class="timeline-company">高中</p>
                  <p class="timeline-description">
                    从HTML、CSS、JavaScript开始学习编程基础，
                    对网页开发产生浓厚兴趣，立志成为优秀的前端开发者。
                  </p>
                </div>
              </div>
            </div>
          </section>

          <!-- 联系方式 -->
          <section class="contact-section">
            <h2 class="section-title">联系我</h2>
            <div class="contact-grid">
              <a href="mailto:contact@myblog.com" class="contact-item">
                <span class="contact-icon">📧</span>
                <div class="contact-info">
                  <h3>邮箱</h3>
                  <p>contact@myblog.com</p>
                </div>
              </a>
              
              <a href="#" class="contact-item">
                <span class="contact-icon">🐙</span>
                <div class="contact-info">
                  <h3>GitHub</h3>
                  <p>github.com/username</p>
                </div>
              </a>
              
              <a href="#" class="contact-item">
                <span class="contact-icon">🐦</span>
                <div class="contact-info">
                  <h3>Twitter</h3>
                  <p>@username</p>
                </div>
              </a>
              
              <a href="#" class="contact-item">
                <span class="contact-icon">💼</span>
                <div class="contact-info">
                  <h3>LinkedIn</h3>
                  <p>linkedin.com/in/username</p>
                </div>
              </a>
            </div>
          </section>
        </main>

        <!-- 侧边栏 -->
        <aside class="sidebar">
          <div class="sidebar-card">
            <h3 class="sidebar-title">个人统计</h3>
            <div class="stats-list">
              <div class="stat-item">
                <span class="stat-label">博客文章</span>
                <span class="stat-value">{{ blogStore.articles.length }}</span>
              </div>
              <div class="stat-item">
                <span class="stat-label">总阅读量</span>
                <span class="stat-value">{{ totalViews }}</span>
              </div>
              <div class="stat-item">
                <span class="stat-label">获赞数</span>
                <span class="stat-value">{{ totalLikes }}</span>
              </div>

            </div>
          </div>

          <div class="sidebar-card">
            <h3 class="sidebar-title">兴趣爱好</h3>
            <ul class="interests-list">
              <li>💻 编程学习</li>
              <li>📚 技术文档</li>
              <li>🎮 代码练习</li>
              <li>🎵 音乐放松</li>
              <li>📷 设计灵感</li>
              <li>✈️ 技术爱好</li>
            </ul>
          </div>

          <div class="sidebar-card">
            <h3 class="sidebar-title">座右铭</h3>
            <blockquote class="motto">
              "学习是进步的阶梯，实践是成功的捷径。用代码创造未来，用知识改变世界。"
            </blockquote>
          </div>
        </aside>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useBlogStore } from '../stores/blog'

const blogStore = useBlogStore()

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
</script>

<style scoped>
.about-page {
  padding: 2rem 0;
}

.page-header {
  text-align: center;
  margin-bottom: 3rem;
}

.page-title {
  font-size: 3rem;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 0.5rem;
  background: linear-gradient(135deg, var(--primary-color), #66b1ff);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.page-subtitle {
  font-size: 1.2rem;
  color: var(--text-secondary);
}

.content-layout {
  display: grid;
  grid-template-columns: 1fr 320px;
  gap: 3rem;
}

.profile-section {
  margin-bottom: 3rem;
}

.profile-card {
  display: flex;
  gap: 2rem;
  background: var(--bg-color);
  border: 1px solid var(--border-light);
  border-radius: var(--border-radius-lg);
  padding: 2rem;
  box-shadow: var(--shadow);
}

.profile-avatar {
  flex-shrink: 0;
}

.profile-avatar img {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  border: 3px solid var(--primary-color);
}

.profile-info {
  flex: 1;
}

.profile-name {
  font-size: 2rem;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 0.5rem;
}

.profile-title {
  font-size: 1.1rem;
  color: var(--primary-color);
  margin-bottom: 1rem;
  font-weight: 500;
}

.profile-bio {
  margin-bottom: 2rem;
}

.profile-bio p {
  color: var(--text-secondary);
  line-height: 1.6;
  margin-bottom: 0.5rem;
}

.profile-skills h3 {
  font-size: 1.2rem;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 1rem;
}

.skills-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 1rem;
}

.skill-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem;
  background: var(--bg-secondary);
  border-radius: var(--border-radius);
  transition: var(--transition-fast);
}

.skill-item:hover {
  background: var(--primary-light);
  transform: translateY(-2px);
}

.skill-icon {
  font-size: 1.2rem;
}

.skill-name {
  font-weight: 500;
  color: var(--text-primary);
}

.experience-section,
.contact-section {
  margin-bottom: 3rem;
}

.section-title {
  font-size: 1.8rem;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 2rem;
  position: relative;
  padding-left: 1rem;
}

.section-title::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 4px;
  height: 24px;
  background: var(--primary-color);
  border-radius: 2px;
}

.timeline {
  position: relative;
  padding-left: 2rem;
}

.timeline::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 2px;
  background: var(--border-color);
}

.timeline-item {
  position: relative;
  margin-bottom: 2rem;
}

.timeline-marker {
  position: absolute;
  left: -2rem;
  top: 0.5rem;
  width: 12px;
  height: 12px;
  background: var(--primary-color);
  border: 3px solid var(--bg-color);
  border-radius: 50%;
  z-index: 1;
}

.timeline-content {
  background: var(--bg-color);
  border: 1px solid var(--border-light);
  border-radius: var(--border-radius);
  padding: 1.5rem;
  box-shadow: var(--shadow-sm);
}

.timeline-content h3 {
  font-size: 1.2rem;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 0.25rem;
}

.timeline-company {
  color: var(--primary-color);
  font-weight: 500;
  margin-bottom: 0.25rem;
}

.timeline-date {
  color: var(--text-tertiary);
  font-size: 0.9rem;
  margin-bottom: 0.75rem;
}

.timeline-description {
  color: var(--text-secondary);
  line-height: 1.6;
}

.contact-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
}

.contact-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1.5rem;
  background: var(--bg-color);
  border: 1px solid var(--border-light);
  border-radius: var(--border-radius);
  text-decoration: none;
  color: var(--text-primary);
  transition: var(--transition);
}

.contact-item:hover {
  box-shadow: var(--shadow);
  border-color: var(--primary-color);
  transform: translateY(-2px);
}

.contact-icon {
  font-size: 2rem;
  width: 48px;
  text-align: center;
}

.contact-info h3 {
  font-size: 1.1rem;
  font-weight: 600;
  margin-bottom: 0.25rem;
}

.contact-info p {
  color: var(--text-secondary);
  font-size: 0.9rem;
}

/* 侧边栏样式 */
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
  font-size: 1.2rem;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 1rem;
}

.stats-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.stat-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.75rem;
  background: var(--bg-secondary);
  border-radius: var(--border-radius-sm);
}

.stat-label {
  color: var(--text-secondary);
  font-size: 0.9rem;
}

.stat-value {
  font-weight: 600;
  color: var(--primary-color);
}

.interests-list {
  list-style: none;
  padding: 0;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 0.75rem;
}

.interests-list li {
  padding: 0.5rem;
  background: var(--bg-secondary);
  border-radius: var(--border-radius-sm);
  font-size: 0.9rem;
  text-align: center;
}

.motto {
  margin: 0;
  padding: 1rem;
  background: var(--bg-secondary);
  border-left: 4px solid var(--primary-color);
  border-radius: var(--border-radius-sm);
  font-style: italic;
  color: var(--text-secondary);
  line-height: 1.6;
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
  .profile-card {
    flex-direction: column;
    text-align: center;
  }
  
  .skills-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .contact-grid {
    grid-template-columns: 1fr;
  }
  
  .page-title {
    font-size: 2rem;
  }
  
  .interests-list {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 480px) {
  .page-header {
    margin-bottom: 2rem;
  }
  
  .profile-card {
    padding: 1.5rem;
  }
  
  .timeline {
    padding-left: 1.5rem;
  }
  
  .timeline-marker {
    left: -1.5rem;
  }
  
  .timeline-content {
    padding: 1rem;
  }
  
  .contact-item {
    padding: 1rem;
  }
}
</style>