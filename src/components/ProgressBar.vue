<template>
  <div class="progress-bar" v-if="showProgress">
    <div 
      class="progress-fill" 
      :style="{ width: `${scrollPercent}%` }"
      :title="`${scrollPercent}%`"
    ></div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const scrollPercent = ref(0)
const lastScrollTop = ref(0)
const ticking = ref(false)

const props = defineProps({
  showProgress: {
    type: Boolean,
    default: true
  },
  thickness: {
    type: Number,
    default: 3
  },
  color: {
    type: String,
    default: 'var(--primary-color)'
  }
})

const updateScrollProgress = () => {
  const scrollTop = window.pageYOffset || document.documentElement.scrollTop
  const scrollHeight = document.documentElement.scrollHeight - window.innerHeight
  
  if (scrollHeight > 0) {
    const percent = Math.round((scrollTop / scrollHeight) * 100)
    scrollPercent.value = Math.min(Math.max(percent, 0), 100)
  }
}

const requestTick = () => {
  if (!ticking.value) {
    requestAnimationFrame(updateScrollProgress)
    ticking.value = true
  }
}

const handleScroll = () => {
  lastScrollTop.value = window.pageYOffset || document.documentElement.scrollTop
  requestTick()
  ticking.value = false
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll, { passive: true })
  updateScrollProgress() // 初始化
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
.progress-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: rgba(0, 0, 0, 0.1);
  z-index: 10000;
  transition: height 0.2s ease;
}

.progress-fill {
  height: 100%;
  background: var(--primary-color);
  width: 0%;
  transition: width 0.1s ease-out;
  position: relative;
}

.progress-fill::after {
  content: '';
  position: absolute;
  top: 0;
  right: 0;
  width: 6px;
  height: 100%;
  background: white;
  border-radius: 3px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
}

/* 不同颜色主题 */
.progress-bar.success .progress-fill {
  background: var(--success-color);
}

.progress-bar.warning .progress-fill {
  background: var(--warning-color);
}

.progress-bar.danger .progress-fill {
  background: var(--danger-color);
}

/* 暗黑主题适配 */
[data-theme="dark"] .progress-bar {
  background: rgba(255, 255, 255, 0.1);
}

/* 厚度变体 */
.progress-bar.thick {
  height: 5px;
}

.progress-bar.thin {
  height: 2px;
}

/* 隐藏状态 */
.progress-bar.hidden {
  opacity: 0;
  transition: opacity 0.3s ease;
}

.progress-bar.show {
  opacity: 1;
}

/* 响应式 */
@media (max-width: 768px) {
  .progress-bar {
    height: 4px; /* 移动端稍微粗一点 */
  }
}
</style>