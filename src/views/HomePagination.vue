// 分页相关逻辑
export const usePagination = (filteredArticles, pageSize = 6) => {
  const currentPage = ref(1)
  const currentPageSize = ref(pageSize)
  
  const totalPages = computed(() => 
    Math.ceil(filteredArticles.value.length / currentPageSize.value)
  )
  
  const displayArticles = computed(() => {
    const start = (currentPage.value - 1) * currentPageSize.value
    const end = start + currentPageSize.value
    return filteredArticles.value.slice(start, end)
  })
  
  const handlePageChange = (page) => {
    currentPage.value = page
  }
  
  const handlePageSizeChange = (newPageSize) => {
    currentPageSize.value = newPageSize
    currentPage.value = 1 // 切换页大小时回到第一页
  }
  
  return {
    currentPage,
    currentPageSize,
    totalPages,
    displayArticles,
    handlePageChange,
    handlePageSizeChange
  }
}