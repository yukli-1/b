<template>
  <transition name="back-to-top">
    <button
      v-show="visible"
      class="back-to-top"
      @click="scrollToTop"
      :title="scrollPercent > 0 ? `已滚动 ${scrollPercent}%` : '返回顶部'"
    >
      <i class="icon">⬆️</i>
      <div class="scroll-indicator" v-if="showPercent">
        {{ scrollPercent }}%
      </div>
    </button>
  </transition>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'

const visible = ref(false)
const scrollPercent = ref(0)
const showPercent = ref(true)

const props = defineProps({
  threshold: {
    type: Number,
    default: 300 // 滚动多少像素后显示按钮
  },
  showPercent: {
    type: Boolean,
    default: true
  }
})

const handleScroll = () => {
  const scrollTop = window.pageYOffset || document.documentElement.scrollTop
  const scrollHeight = document.documentElement.scrollHeight - window.innerHeight
  const percent = scrollHeight > 0 ? Math.round((scrollTop / scrollHeight) * 100) : 0
  
  visible.value = scrollTop > props.threshold
  scrollPercent.value = Math.min(percent, 100)
}

const scrollToTop = () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
}

// 监听滚动事件
onMounted(() => {
  window.addEventListener('scroll', handleScroll)
  handleScroll() // 初始化时调用一次
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})

// 计算滚动进度圆环的样式
const progressStyle = computed(() => {
  const circumference = 2 * Math.PI * 18 // 半径为18的圆
  const offset = circumference - (scrollPercent.value / 100) * circumference
  
  return {
    strokeDasharray: `${circumference} ${circumference}`,
    strokeDashoffset: offset
  }
})
</script>

<style scoped>
.back-to-top {
  position: fixed;
  right: 2rem;
  bottom: 2rem;
  width: 50px;
  height: 50px;
  border-radius: 50%;
  background: var(--primary-color);
  color: white;
  border: none;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  box-shadow: var(--shadow-lg);
  transition: var(--transition-fast);
  z-index: 1000;
  font-size: 1.2rem;
}

.back-to-top:hover {
  background: #66b1ff;
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(64, 158, 255, 0.3);
}

.back-to-top:active {
  transform: translateY(0);
}

.scroll-indicator {
  font-size: 0.7rem;
  font-weight: 600;
  margin-top: -2px;
}

.back-to-top-enter-active,
.back-to-top-leave-active {
  transition: all 0.3s ease;
}

.back-to-top-enter-from {
  opacity: 0;
  transform: translateY(20px);
}

.back-to-top-leave-to {
  opacity: 0;
  transform: translateY(20px);
}

/* 添加一个带进度条的版本 */
.back-to-top.progress {
  background: transparent;
  border: 2px solid var(--border-color);
  color: var(--text-primary);
}

.back-to-top.progress:hover {
  background: var(--primary-color);
  border-color: var(--primary-color);
  color: white;
}

.progress-ring {
  position: absolute;
  top: 0;
  left: 0;
  transform: rotate(-90deg);
}

.progress-ring-circle {
  transition: stroke-dashoffset 0.3s ease;
}

/* 响应式调整 */
@media (max-width: 768px) {
  .back-to-top {
    right: 1rem;
    bottom: 1rem;
    width: 45px;
    height: 45px;
    font-size: 1rem;
  }
}

@media (max-width: 480px) {
  .back-to-top {
    width: 40px;
    height: 40px;
    font-size: 0.9rem;
  }
  
  .scroll-indicator {
    font-size: 0.6rem;
  }
}
</style>