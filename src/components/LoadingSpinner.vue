<template>
  <div class="loading-container" :class="{ overlay: overlay }">
    <div class="loading-spinner" :style="{ width: size, height: size }">
      <div class="spinner-circle" :style="spinnerStyle"></div>
      <div class="spinner-circle spinner-circle-2" :style="spinnerStyle2"></div>
    </div>
    <p v-if="text" class="loading-text">{{ text }}</p>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  size: {
    type: String,
    default: '40px'
  },
  color: {
    type: String,
    default: '#409EFF'
  },
  text: {
    type: String,
    default: ''
  },
  overlay: {
    type: Boolean,
    default: false
  },
  thickness: {
    type: Number,
    default: 4
  }
})

const spinnerStyle = computed(() => ({
  borderTopColor: props.color,
  borderWidth: `${props.thickness}px`
}))

const spinnerStyle2 = computed(() => ({
  borderBottomColor: props.color,
  borderWidth: `${props.thickness}px`
}))
</script>

<style scoped>
.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  color: var(--text-secondary);
}

.loading-container.overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(2px);
  z-index: 9999;
}

.loading-spinner {
  position: relative;
  display: inline-block;
  border-radius: 50%;
  border: 4px solid transparent;
  border-top-color: var(--primary-color);
  animation: spin 1s linear infinite;
}

.spinner-circle {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  border-radius: 50%;
  border: 4px solid transparent;
  animation: spin-reverse 0.8s linear infinite;
}

.spinner-circle-2 {
  animation-delay: 0.2s;
  border-color: transparent transparent var(--primary-color) transparent;
}

.loading-text {
  margin-top: 1rem;
  font-size: 0.9rem;
  text-align: center;
  animation: pulse 1.5s ease-in-out infinite;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

@keyframes spin-reverse {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(-360deg);
  }
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

/* 不同尺寸的变体 */
.loading-sm {
  width: 20px !important;
  height: 20px !important;
}

.loading-lg {
  width: 60px !important;
  height: 60px !important;
}

/* 不同颜色的变体 */
.loading-primary {
  --spinner-color: var(--primary-color);
}

.loading-success {
  --spinner-color: var(--success-color);
}

.loading-warning {
  --spinner-color: var(--warning-color);
}

.loading-danger {
  --spinner-color: var(--danger-color);
}

/* 特殊效果 */
.loading-dots {
  display: flex;
  gap: 0.5rem;
}

.loading-dots .dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: var(--primary-color);
  animation: bounce 1.4s ease-in-out infinite both;
}

.loading-dots .dot:nth-child(1) {
  animation-delay: -0.32s;
}

.loading-dots .dot:nth-child(2) {
  animation-delay: -0.16s;
}

@keyframes bounce {
  0%, 80%, 100% {
    transform: scale(0);
  }
  40% {
    transform: scale(1);
  }
}

/* 暗黑主题适配 */
[data-theme="dark"] .loading-container.overlay {
  background: rgba(0, 0, 0, 0.9);
}

/* 响应式 */
@media (max-width: 480px) {
  .loading-text {
    font-size: 0.8rem;
  }
}
</style>