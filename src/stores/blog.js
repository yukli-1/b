import { defineStore } from 'pinia'

export const useBlogStore = defineStore('blog', {
  state: () => ({
    articles: [
      {
        id: 1,
        title: 'Vue3 组合式 API 深入理解',
        summary: '深入探讨Vue3组合式API的优势和使用技巧，包括ref、reactive、computed等核心概念。',
        content: '# Vue3 组合式 API 深入理解\n\nVue3的组合式API为我们提供了更灵活的代码组织方式...',
        category: 'Vue.js',
        tags: ['Vue3', 'JavaScript', '前端'],
        date: '2025-12-25',
        views: 1234,
        likes: 56,
        cover: '/images/1.jpg'
      },
      {
        id: 2,
        title: 'JavaScript 异步编程完全指南',
        summary: '从回调函数到Promise，再到async/await，全面掌握JavaScript异步编程。',
        content: '# JavaScript 异步编程完全指南\n\n异步编程是JavaScript的核心特性之一...',
        category: 'JavaScript',
        tags: ['JavaScript', '异步编程', 'Promise'],
        date: '2025-12-23',
        views: 987,
        likes: 45,
        cover: '/images/1.jpg'
      },
      {
        id: 3,
        title: 'CSS Grid 布局实战技巧',
        summary: '通过实际案例学习CSS Grid布局的高级用法，打造复杂网格系统。',
        content: '# CSS Grid 布局实战技巧\n\nCSS Grid是现代CSS布局的强大工具...',
        category: 'CSS',
        tags: ['CSS', 'Grid', '布局'],
        date: '2025-12-20',
        views: 756,
        likes: 32,
        cover: '/images/1.jpg'
      },
      {
        id: 4,
        title: 'React Hooks 最佳实践',
        summary: '掌握React Hooks的核心概念和最佳实践，编写更优雅的函数组件。',
        content: '# React Hooks 最佳实践\n\nReact Hooks彻底改变了我们编写React组件的方式...',
        category: 'React',
        tags: ['React', 'Hooks', 'JavaScript'],
        date: '2025-12-18',
        views: 890,
        likes: 48,
        cover: '/images/1.jpg'
      },
      {
        id: 5,
        title: 'Node.js 微服务架构设计',
        summary: '探讨如何在Node.js中设计和实现高性能的微服务架构。',
        content: '# Node.js 微服务架构设计\n\n微服务架构已经成为现代应用开发的主流选择...',
        category: 'Node.js',
        tags: ['Node.js', '微服务', '架构'],
        date: '2025-12-15',
        views: 654,
        likes: 28,
        cover: '/images/1.jpg'
      },
      {
        id: 6,
        title: 'Webpack 5 配置优化技巧',
        summary: '学习Webpack 5的新特性和优化技巧，提升项目构建性能。',
        content: '# Webpack 5 配置优化技巧\n\nWebpack 5带来了许多新特性和性能改进...',
        category: '前端工具',
        tags: ['Webpack', '构建工具', '优化'],
        date: '2025-12-12',
        views: 543,
        likes: 25,
        cover: '/images/1.jpg'
      },
      {
        id: 7,
        title: 'Vue 3 性能优化实战',
        summary: '深入分析Vue 3的性能瓶颈，并提供实用的优化策略。',
        content: '# Vue 3 性能优化实战\n\n性能优化是前端开发中的重要课题...',
        category: 'Vue.js',
        tags: ['Vue3', '性能优化', '前端'],
        date: '2025-12-10',
        views: 1123,
        likes: 67,
        cover: '/images/1.jpg'
      },
      {
        id: 8,
        title: 'TypeScript 高级类型编程',
        summary: '掌握TypeScript的高级类型系统，编写类型安全的代码。',
        content: '# TypeScript 高级类型编程\n\nTypeScript的类型系统非常强大...',
        category: 'JavaScript',
        tags: ['TypeScript', '类型系统', 'JavaScript'],
        date: '2025-12-08',
        views: 789,
        likes: 41,
        cover: '/images/1.jpg'
      }
    ],
    categories: [
      { name: 'Vue.js', count: 2 },
      { name: 'JavaScript', count: 2 },
      { name: 'CSS', count: 1 },
      { name: 'React', count: 1 },
      { name: 'Node.js', count: 1 },
      { name: '前端工具', count: 1 }
    ],
    tags: [
      { name: 'Vue3', count: 2 },
      { name: 'JavaScript', count: 3 },
      { name: '前端', count: 2 },
      { name: '异步编程', count: 1 },
      { name: 'Promise', count: 1 },
      { name: 'CSS', count: 1 },
      { name: 'Grid', count: 1 },
      { name: '布局', count: 1 },
      { name: 'React', count: 1 },
      { name: 'Hooks', count: 1 },
      { name: 'Node.js', count: 1 },
      { name: '微服务', count: 1 },
      { name: '架构', count: 1 },
      { name: 'Webpack', count: 1 },
      { name: '构建工具', count: 1 },
      { name: '优化', count: 2 },
      { name: '性能优化', count: 1 },
      { name: 'TypeScript', count: 1 },
      { name: '类型系统', count: 1 }
    ],
    isLoading: false,
    searchQuery: '',
    currentCategory: '',
    isDarkMode: false
  }),

  getters: {
    getArticleById: (state) => (id) => {
      return state.articles.find(article => article.id === parseInt(id))
    },
    
    getArticlesByCategory: (state) => (category) => {
      return state.articles.filter(article => article.category === category)
    },
    
    searchArticles: (state) => (query) => {
      if (!query) return state.articles
      const lowerQuery = query.toLowerCase()
      return state.articles.filter(article => 
        article.title.toLowerCase().includes(lowerQuery) ||
        article.summary.toLowerCase().includes(lowerQuery) ||
        article.category.toLowerCase().includes(lowerQuery) ||
        article.tags.some(tag => tag.toLowerCase().includes(lowerQuery))
      )
    },

    searchByTag: (state) => (tag) => {
      return state.articles.filter(article => 
        article.tags.some(articleTag => 
          articleTag.toLowerCase() === tag.toLowerCase()
        )
      )
    },
    
    getArchiveDates: (state) => {
      const dates = {}
      state.articles.forEach(article => {
        const year = new Date(article.date).getFullYear()
        const month = new Date(article.date).getMonth() + 1
        const key = `${year}-${month.toString().padStart(2, '0')}`
        if (!dates[key]) {
          dates[key] = { year, month, articles: [] }
        }
        dates[key].articles.push(article)
      })
      return dates
    },

    getPopularCategories: (state) => {
      return [...state.categories].sort((a, b) => b.count - a.count).slice(0, 6)
    },

    getCategoryStats: (state) => {
      const total = state.categories.reduce((sum, cat) => sum + cat.count, 0)
      const avg = total / state.categories.length
      return {
        total,
        average: Math.round(avg),
        max: Math.max(...state.categories.map(c => c.count)),
        min: Math.min(...state.categories.map(c => c.count))
      }
    }
  },

  actions: {
    setLoading(loading) {
      this.isLoading = loading
    },
    
    setSearchQuery(query) {
      this.searchQuery = query
    },
    
    setCurrentCategory(category) {
      this.currentCategory = category
    },
    
    toggleDarkMode() {
      this.isDarkMode = !this.isDarkMode
      document.documentElement.setAttribute('data-theme', this.isDarkMode ? 'dark' : 'light')
      localStorage.setItem('darkMode', this.isDarkMode)
    },
    
    initDarkMode() {
      const savedMode = localStorage.getItem('darkMode')
      if (savedMode === 'true') {
        this.isDarkMode = true
        document.documentElement.setAttribute('data-theme', 'dark')
      }
    },
    
    async loadArticles() {
      this.setLoading(true)
      try {
        // 模拟API调用
        await new Promise(resolve => setTimeout(resolve, 1000))
        // 这里可以替换为实际的API调用
      } catch (error) {
        console.error('加载文章失败:', error)
      } finally {
        this.setLoading(false)
      }
    }
  }
})