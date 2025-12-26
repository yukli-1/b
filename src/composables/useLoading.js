import { ref } from 'vue'

export function useLoading() {
  const isLoading = ref(false)
  const loadingText = ref('')
  const error = ref(null)

  const startLoading = (text = '加载中...') => {
    isLoading.value = true
    loadingText.value = text
    error.value = null
  }

  const stopLoading = () => {
    isLoading.value = false
    loadingText.value = ''
  }

  const setError = (errorMessage) => {
    error.value = errorMessage
    stopLoading()
  }

  const clearError = () => {
    error.value = null
  }

  // 创建一个包装异步操作的函数
  const withLoading = async (asyncFn, loadingText) => {
    try {
      startLoading(loadingText)
      const result = await asyncFn()
      return result
    } catch (err) {
      setError(err.message || '操作失败')
      throw err
    } finally {
      stopLoading()
    }
  }

  return {
    isLoading,
    loadingText,
    error,
    startLoading,
    stopLoading,
    setError,
    clearError,
    withLoading
  }
}

// 全局加载状态管理
export const globalLoading = useLoading()

// 创建多个加载状态
export function useMultipleLoading() {
  const loadingStates = ref({})
  const errors = ref({})

  const setLoading = (key, value, text = '') => {
    loadingStates.value[key] = { value, text }
    if (value) {
      delete errors.value[key]
    }
  }

  const setError = (key, errorMessage) => {
    errors.value[key] = errorMessage
    loadingStates.value[key] = { value: false, text: '' }
  }

  const isLoading = (key) => {
    return loadingStates.value[key]?.value || false
  }

  const getLoadingText = (key) => {
    return loadingStates.value[key]?.text || ''
  }

  const getError = (key) => {
    return errors.value[key] || null
  }

  const clear = (key) => {
    if (key) {
      delete loadingStates.value[key]
      delete errors.value[key]
    } else {
      loadingStates.value = {}
      errors.value = {}
    }
  }

  return {
    loadingStates,
    errors,
    setLoading,
    setError,
    isLoading,
    getLoadingText,
    getError,
    clear
  }
}