<template>
  <transition name="loading-bar">
    <div v-if="isLoading" class="loading-bar">
      <div class="loading-bar-track">
        <div class="loading-bar-fill" :style="{ width: `${progress}%` }">
          <div class="loading-bar-shine"></div>
        </div>
      </div>
      <div class="loading-bar-text" v-if="text">
        {{ text }}
      </div>
    </div>
  </transition>
</template>

<script setup>
import { ref, onUnmounted } from 'vue'

const props = defineProps({
  isLoading: {
    type: Boolean,
    default: false
  },
  text: {
    type: String,
    default: ''
  },
  duration: {
    type: Number,
    default: 2000 // 动画持续时间(ms)
  }
})

const progress = ref(0)
let animationFrame = null
let startTime = null

const animate = (timestamp) => {
  if (!startTime) startTime = timestamp
  const elapsed = timestamp - startTime
  
  if (elapsed < props.duration) {
    // 使用缓动函数让动画更自然
    const easeProgress = easeInOutCubic(elapsed / props.duration)
    progress.value = Math.min(easeProgress * 95, 95) // 最多到95%，保持动画感
    animationFrame = requestAnimationFrame(animate)
  } else if (props.isLoading) {
    // 如果还在加载状态，保持在95%
    progress.value = 95
    animationFrame = requestAnimationFrame(animate)
  } else {
    // 加载完成，快速到100%
    progress.value = 100
    setTimeout(() => {
      if (!props.isLoading) {
        progress.value = 0
        startTime = null
      }
    }, 300)
  }
}

const easeInOutCubic = (t) => {
  return t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2
}

const startAnimation = () => {
  progress.value = 0
  startTime = null
  animationFrame = requestAnimationFrame(animate)
}

const stopAnimation = () => {
  progress.value = 100
  setTimeout(() => {
    progress.value = 0
    startTime = null
  }, 300)
}

// 监听加载状态变化
watch(() => props.isLoading, (isLoading) => {
  if (isLoading) {
    startAnimation()
  } else {
    stopAnimation()
  }
  
  // 清理之前的动画帧
  if (animationFrame) {
    cancelAnimationFrame(animationFrame)
  }
})

onUnmounted(() => {
  if (animationFrame) {
    cancelAnimationFrame(animationFrame)
  }
})
</script>

<style scoped>
.loading-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 10001;
}

.loading-bar-track {
  height: 3px;
  background: rgba(0, 0, 0, 0.1);
  position: relative;
}

.loading-bar-fill {
  height: 100%;
  background: linear-gradient(90deg, var(--primary-color) 0%, #66b1ff 100%);
  position: relative;
  transition: width 0.1s ease-out;
}

.loading-bar-shine {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(
    90deg,
    transparent 0%,
    rgba(255, 255, 255, 0.3) 50%,
    transparent 100%
  );
  animation: shine 2s infinite;
}

.loading-bar-text {
  text-align: center;
  padding: 0.5rem;
  background: rgba(0, 0, 0, 0.8);
  color: white;
  font-size: 0.8rem;
  position: relative;
  z-index: 10002;
}

@keyframes shine {
  0% {
    transform: translateX(-100%);
  }
  100% {
    transform: translateX(100%);
  }
}

/* 过渡动画 */
.loading-bar-enter-active,
.loading-bar-leave-active {
  transition: all 0.3s ease;
}

.loading-bar-enter-from {
  opacity: 0;
  transform: translateY(-10px);
}

.loading-bar-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

/* 颜色变体 */
.loading-bar.success .loading-bar-fill {
  background: linear-gradient(90deg, var(--success-color) 0%, #85ce61 100%);
}

.loading-bar.warning .loading-bar-fill {
  background: linear-gradient(90deg, var(--warning-color) 0%, #ebb563 100%);
}

.loading-bar.danger .loading-bar-fill {
  background: linear-gradient(90deg, var(--danger-color) 0%, #f78989 100%);
}

/* 暗黑主题适配 */
[data-theme="dark"] .loading-bar-track {
  background: rgba(255, 255, 255, 0.1);
}

[data-theme="dark"] .loading-bar-text {
  background: rgba(255, 255, 255, 0.9);
  color: var(--text-primary);
}

/* 厚度变体 */
.loading-bar.thick .loading-bar-track {
  height: 4px;
}

.loading-bar.thin .loading-bar-track {
  height: 2px;
}
</style>