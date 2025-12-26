import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import Article from '../views/Article.vue'
import Category from '../views/Category.vue'
import Archive from '../views/Archive.vue'
import About from '../views/About.vue'
import Search from '../views/Search.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home,
    meta: { title: '首页' }
  },
  {
    path: '/article/:id',
    name: 'Article',
    component: Article,
    meta: { title: '文章详情' }
  },
  {
    path: '/category',
    name: 'Categories',
    component: Category,
    meta: { title: '所有分类' }
  },
  {
    path: '/category/:name',
    name: 'Category',
    component: Category,
    meta: { title: '分类' }
  },
  {
    path: '/archive',
    name: 'Archive',
    component: Archive,
    meta: { title: '文章' }
  },
  {
    path: '/about',
    name: 'About',
    component: About,
    meta: { title: '关于' }
  },
  {
    path: '/search',
    name: 'Search',
    component: Search,
    meta: { title: '搜索' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, _from, next) => {
  document.title = `${to.meta.title} - 我的技术博客`
  next()
})

export default router