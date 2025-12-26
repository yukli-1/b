<template>
  <header class="header">
    <div class="container">
      <nav class="navbar">
        <div class="navbar-brand">
          <router-link to="/" class="brand-link">
            <h1 class="brand-title">我的技术博客</h1>
          </router-link>
        </div>
        
        <div class="navbar-menu" :class="{ 'is-active': isMobileMenuOpen }">
          <router-link to="/" class="nav-link" @click="closeMobileMenu">首页</router-link>
          <router-link to="/archive" class="nav-link" @click="closeMobileMenu">文章</router-link>
          <router-link to="/category" class="nav-link" @click="closeMobileMenu">分类</router-link>
          <router-link to="/about" class="nav-link" @click="closeMobileMenu">关于</router-link>
          
          <div class="navbar-actions">
            <div class="search-box">
              <input 
                v-model="searchQuery" 
                type="text" 
                placeholder="搜索文章..." 
                @keyup.enter="handleSearch"
                @input="handleSearchInput"
              >
              <button class="search-btn" @click="handleSearch">
                <i class="icon">🔍</i>
              </button>
            </div>
            
            <button class="theme-toggle" @click="toggleTheme" title="切换主题">
              <i class="icon">{{ isDarkMode ? '☀️' : '🌙' }}</i>
            </button>
          </div>
        </div>
        
        <button class="mobile-menu-toggle" @click="toggleMobileMenu">
          <span class="hamburger" :class="{ 'is-active': isMobileMenuOpen }"></span>
        </button>
      </nav>
    </div>
  </header>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useBlogStore } from '../stores/blog'

const router = useRouter()
const blogStore = useBlogStore()

const isMobileMenuOpen = ref(false)
const searchQuery = ref('')

const isDarkMode = computed(() => blogStore.isDarkMode)

const toggleMobileMenu = () => {
  isMobileMenuOpen.value = !isMobileMenuOpen.value
}

const closeMobileMenu = () => {
  isMobileMenuOpen.value = false
}

const toggleTheme = () => {
  blogStore.toggleDarkMode()
}

const handleSearch = () => {
  if (searchQuery.value.trim()) {
    router.push({ name: 'Search', query: { q: searchQuery.value } })
    closeMobileMenu()
  }
}

const handleSearchInput = () => {
  blogStore.setSearchQuery(searchQuery.value)
}

onMounted(() => {
  blogStore.initDarkMode()
  
  // 响应式处理
  const handleResize = () => {
    if (window.innerWidth > 768) {
      isMobileMenuOpen.value = false
    }
  }
  
  window.addEventListener('resize', handleResize)
  
  // 键盘事件处理
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && isMobileMenuOpen.value) {
      closeMobileMenu()
    }
    if (e.ctrlKey && e.key === 'k') {
      e.preventDefault()
      document.querySelector('.search-box input')?.focus()
    }
  })
})
</script>

<style scoped>
.header {
  background: var(--bg-glass);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  position: sticky;
  top: 0;
  z-index: 1000;
  transition: var(--transition);
}

.header.scrolled {
  box-shadow: var(--shadow-lg);
}

.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 70px;
}

.brand-link {
  text-decoration: none;
  color: var(--text-primary);
}

.brand-title {
  font-size: 1.8rem;
  font-weight: 800;
  background: var(--gradient-1);
  background-size: 200% 200%;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin: 0;
  animation: gradientShift 6s ease infinite;
  letter-spacing: -0.5px;
}

.navbar-menu {
  display: flex;
  align-items: center;
  gap: 2rem;
}

.nav-link {
  color: var(--text-secondary);
  text-decoration: none;
  font-weight: 600;
  padding: 0.75rem 1.25rem;
  border-radius: var(--border-radius-lg);
  transition: var(--transition);
  position: relative;
  overflow: hidden;
}

.nav-link::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: var(--gradient-1);
  opacity: 0.1;
  transition: var(--transition);
}

.nav-link:hover::before {
  left: 0;
}

.nav-link.router-link-active {
  color: var(--primary-color);
  background: var(--primary-light);
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.2);
  border-radius: var(--border-radius-lg);
  transition: var(--transition-fast);
  position: relative;
}

.nav-link.router-link-active::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 50%;
  transform: translateX(-50%);
  width: 30px;
  height: 3px;
  background: var(--primary-color);
  border-radius: 2px;
}

.navbar-actions {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-left: 2rem;
}

.search-box {
  display: flex;
  align-items: center;
  background: var(--bg-glass);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: var(--border-radius-xl);
  padding: 0.75rem;
  transition: var(--transition);
  overflow: hidden;
}

.search-box:focus-within {
  border-color: var(--primary-color);
  box-shadow: var(--shadow-glow);
  transform: translateY(-2px);
}

.search-box input {
  background: transparent;
  border: none;
  outline: none;
  padding: 0.25rem 0.5rem;
  color: var(--text-primary);
  font-size: 0.9rem;
  width: 200px;
}

.search-box input::placeholder {
  color: var(--text-placeholder);
}

.search-btn {
  background: none;
  border: none;
  color: var(--text-secondary);
  cursor: pointer;
  padding: 0.25rem;
  border-radius: var(--border-radius-sm);
  transition: var(--transition-fast);
}

.search-btn:hover {
  color: var(--primary-color);
  background: var(--primary-light);
}

.theme-toggle {
  background: var(--bg-secondary);
  border: 1px solid var(--border-color);
  border-radius: var(--border-radius);
  padding: 0.5rem;
  cursor: pointer;
  transition: var(--transition-fast);
  font-size: 1.2rem;
}

.theme-toggle:hover {
  background: var(--primary-light);
  border-color: var(--primary-color);
}

.mobile-menu-toggle {
  display: none;
  background: none;
  border: none;
  cursor: pointer;
  padding: 0.5rem;
}

.hamburger {
  display: block;
  width: 24px;
  height: 2px;
  background: var(--text-primary);
  position: relative;
  transition: var(--transition-fast);
}

.hamburger::before,
.hamburger::after {
  content: '';
  position: absolute;
  width: 24px;
  height: 2px;
  background: var(--text-primary);
  transition: var(--transition-fast);
}

.hamburger::before {
  top: -8px;
}

.hamburger::after {
  top: 8px;
}

.hamburger.is-active {
  background: transparent;
}

.hamburger.is-active::before {
  top: 0;
  transform: rotate(45deg);
}

.hamburger.is-active::after {
  top: 0;
  transform: rotate(-45deg);
}

/* 响应式 */
@media (max-width: 768px) {
  .mobile-menu-toggle {
    display: block;
  }
  
  .navbar-menu {
    position: fixed;
    top: 70px;
    left: 0;
    right: 0;
    background: var(--bg-color);
    border-bottom: 1px solid var(--border-light);
    flex-direction: column;
    padding: 2rem;
    gap: 1rem;
    transform: translateY(-100%);
    opacity: 0;
    visibility: hidden;
    transition: var(--transition);
    box-shadow: var(--shadow-lg);
  }
  
  .navbar-menu.is-active {
    transform: translateY(0);
    opacity: 1;
    visibility: visible;
  }
  
  .navbar-actions {
    width: 100%;
    margin-left: 0;
    flex-direction: column;
    gap: 1rem;
  }
  
  .search-box {
    width: 100%;
  }
  
  .search-box input {
    width: 100%;
  }
  
  .theme-toggle {
    width: 100%;
    justify-content: center;
  }
}
</style>