<template>
  <div class="pagination">
    <div class="pagination-info">
      <span>显示 {{ startItem }}-{{ endItem }} 条，共 {{ total }} 条</span>
    </div>
    
    <div class="pagination-controls">
      <button 
        class="pagination-btn"
        :disabled="currentPage <= 1"
        @click="goToPage(currentPage - 1)"
      >
        <i class="icon">⬅️</i>
        上一页
      </button>
      
      <div class="pagination-numbers">
        <button 
          v-for="page in visiblePages" 
          :key="page"
          class="page-number"
          :class="{ 
            'active': page === currentPage,
            'ellipsis': page === '...' 
          }"
          :disabled="page === '...'"
          @click="page !== '...' && goToPage(page)"
        >
          {{ page }}
        </button>
      </div>
      
      <button 
        class="pagination-btn"
        :disabled="currentPage >= totalPages"
        @click="goToPage(currentPage + 1)"
      >
        下一页
        <i class="icon">➡️</i>
      </button>
    </div>
    
    <div class="pagination-size">
      <label>每页显示：</label>
      <select v-model="pageSize" @change="handlePageSizeChange">
        <option :value="6">6条</option>
        <option :value="9">9条</option>
        <option :value="12">12条</option>
        <option :value="20">20条</option>
      </select>
    </div>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'

const props = defineProps({
  current: {
    type: Number,
    default: 1
  },
  total: {
    type: Number,
    required: true
  },
  pageSize: {
    type: Number,
    default: 6
  }
})

const emit = defineEmits(['page-change', 'page-size-change'])

const currentPage = ref(props.current)
const pageSize = ref(props.pageSize)

const totalPages = computed(() => Math.ceil(props.total / pageSize.value))

const startItem = computed(() => {
  return props.total === 0 ? 0 : (currentPage.value - 1) * pageSize.value + 1
})

const endItem = computed(() => {
  const end = currentPage.value * pageSize.value
  return Math.min(end, props.total)
})

const visiblePages = computed(() => {
  const pages = []
  const total = totalPages.value
  const current = currentPage.value
  const delta = 2 // 显示当前页前后2页
  
  if (total <= 7) {
    // 总页数少于等于7页，显示所有页码
    for (let i = 1; i <= total; i++) {
      pages.push(i)
    }
  } else {
    // 显示第一页
    pages.push(1)
    
    // 计算显示范围的开始和结束
    let start = Math.max(2, current - delta)
    let end = Math.min(total - 1, current + delta)
    
    // 如果开始页大于2，添加省略号
    if (start > 2) {
      pages.push('...')
    }
    
    // 添加中间页码
    for (let i = start; i <= end; i++) {
      pages.push(i)
    }
    
    // 如果结束页小于总页数-1，添加省略号
    if (end < total - 1) {
      pages.push('...')
    }
    
    // 显示最后一页
    if (total > 1) {
      pages.push(total)
    }
  }
  
  return pages
})

const goToPage = (page) => {
  if (page < 1 || page > totalPages.value || page === currentPage.value) {
    return
  }
  
  currentPage.value = page
  emit('page-change', page)
}

const handlePageSizeChange = () => {
  currentPage.value = 1 // 切换每页大小时回到第一页
  emit('page-size-change', pageSize.value)
}

// 监听props变化
watch([() => props.current, () => props.total], ([newCurrent, newTotal]) => {
  currentPage.value = newCurrent
  // 确保当前页不超出总页数
  if (currentPage.value > totalPages.value) {
    currentPage.value = totalPages.value || 1
  }
})
</script>

<style scoped>
.pagination {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
  margin: 2rem 0;
  padding: 1rem;
  background: var(--bg-color);
  border: 1px solid var(--border-light);
  border-radius: var(--border-radius);
}

.pagination-info {
  color: var(--text-secondary);
  font-size: 0.9rem;
}

.pagination-controls {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.pagination-btn {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  padding: 0.5rem 1rem;
  background: var(--bg-color);
  border: 1px solid var(--border-color);
  border-radius: var(--border-radius-sm);
  color: var(--text-primary);
  cursor: pointer;
  transition: var(--transition-fast);
  font-size: 0.9rem;
}

.pagination-btn:hover:not(:disabled) {
  background: var(--primary-light);
  border-color: var(--primary-color);
  color: var(--primary-color);
}

.pagination-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.pagination-numbers {
  display: flex;
  gap: 0.25rem;
}

.page-number {
  width: 36px;
  height: 36px;
  border: 1px solid var(--border-color);
  background: var(--bg-color);
  color: var(--text-primary);
  border-radius: var(--border-radius-sm);
  cursor: pointer;
  transition: var(--transition-fast);
  font-weight: 500;
  font-size: 0.9rem;
}

.page-number:hover:not(:disabled) {
  background: var(--primary-light);
  border-color: var(--primary-color);
  color: var(--primary-color);
}

.page-number.active {
  background: var(--primary-color);
  border-color: var(--primary-color);
  color: white;
}

.page-number.ellipsis {
  border: none;
  background: transparent;
  color: var(--text-tertiary);
  cursor: default;
  font-size: 0.8rem;
}

.pagination-size {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--text-secondary);
  font-size: 0.9rem;
}

.pagination-size select {
  padding: 0.375rem 0.5rem;
  border: 1px solid var(--border-color);
  border-radius: var(--border-radius-sm);
  background: var(--bg-color);
  color: var(--text-primary);
  cursor: pointer;
}

.pagination-size select:focus {
  outline: none;
  border-color: var(--primary-color);
}

/* 响应式 */
@media (max-width: 768px) {
  .pagination {
    flex-direction: column;
    align-items: center;
    text-align: center;
    gap: 1.5rem;
  }
  
  .pagination-controls {
    flex-wrap: wrap;
    justify-content: center;
  }
  
  .pagination-numbers {
    order: 1;
  }
  
  .pagination-btn {
    padding: 0.5rem 0.75rem;
    font-size: 0.85rem;
  }
  
  .page-number {
    width: 32px;
    height: 32px;
    font-size: 0.85rem;
  }
}

@media (max-width: 480px) {
  .page-number {
    width: 28px;
    height: 28px;
    font-size: 0.8rem;
  }
  
  .pagination-btn {
    padding: 0.375rem 0.625rem;
    font-size: 0.8rem;
  }
}
</style>