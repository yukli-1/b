<template>
  <div class="cool-loading" :class="size">
    <div class="loading-dots">
      <span></span>
      <span></span>
      <span></span>
    </div>
    <p v-if="text" class="loading-text">{{ text }}</p>
  </div>
</template>

<script setup>
defineProps({
  text: {
    type: String,
    default: '加载中...'
  },
  size: {
    type: String,
    default: 'medium',
    validator: (value) => ['small', 'medium', 'large'].includes(value)
  }
})
</script>

<style scoped>
.cool-loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}

.cool-loading.small {
  padding: 1rem;
}

.cool-loading.medium {
  padding: 2rem;
}

.cool-loading.large {
  padding: 3rem;
}

.loading-dots {
  display: flex;
  gap: 8px;
}

.loading-dots span {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: var(--gradient-1);
  background-size: 200% 200%;
  animation: bounce 1.4s ease-in-out infinite both, gradientShift 2s ease infinite;
  box-shadow: 0 0 10px rgba(37, 99, 235, 0.5);
}

.loading-dots span:nth-child(1) { animation-delay: -0.32s; }
.loading-dots span:nth-child(2) { animation-delay: -0.16s; }
.loading-dots span:nth-child(3) { animation-delay: 0s; }

.loading-text {
  color: var(--text-secondary);
  font-size: 0.9rem;
  animation: fadeInOut 1.4s ease-in-out infinite;
}

@keyframes bounce {
  0%, 20%, 53%, 80%, 100% {
    transform: translateY(0);
  }
  40%, 43% {
    transform: translateY(-10px);
  }
  70% {
    transform: translateY(-5px);
  }
  90% {
    transform: translateY(-2px);
  }
}

@keyframes fadeInOut {
  0%, 100% { opacity: 0.5; }
  50% { opacity: 1; }
}
</style>