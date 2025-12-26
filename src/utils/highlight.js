// 代码高亮工具函数
export function highlightCode(code, language) {
  // 简单的代码高亮实现
  // 实际项目中可以使用 highlight.js 或 prism.js
  const keywords = {
    javascript: [
      'function', 'const', 'let', 'var', 'if', 'else', 'for', 'while', 'return', 
      'class', 'import', 'export', 'default', 'async', 'await', 'try', 'catch'
    ],
    typescript: [
      'interface', 'type', 'as', 'enum', 'declare', 'namespace', 'module'
    ],
    html: [
      'div', 'span', 'p', 'a', 'img', 'script', 'style', 'link', 'meta'
    ],
    css: [
      'color', 'background', 'font', 'padding', 'margin', 'border', 'display'
    ]
  }

  const commonKeywords = keywords[language] || keywords.javascript
  
  let highlightedCode = code
  
  // 高亮关键字
  commonKeywords.forEach(keyword => {
    const regex = new RegExp(`\\b${keyword}\\b`, 'g')
    highlightedCode = highlightedCode.replace(regex, `<span class="keyword">${keyword}</span>`)
  })
  
  // 高亮字符串
  highlightedCode = highlightedCode.replace(
    /(["'`])((?:\\.|(?!\1)[^\\])*?)\1/g, 
    '<span class="string">$&</span>'
  )
  
  // 高亮数字
  highlightedCode = highlightedCode.replace(
    /\b\d+\.?\d*\b/g, 
    '<span class="number">$&</span>'
  )
  
  // 高亮注释
  if (language === 'javascript' || language === 'typescript') {
    highlightedCode = highlightedCode.replace(
      /\/\/.*$/gm, 
      '<span class="comment">$&</span>'
    )
    highlightedCode = highlightedCode.replace(
      /\/\*[\s\S]*?\*\//g, 
      '<span class="comment">$&</span>'
    )
  }
  
  return highlightedCode
}

// Markdown 转换函数
export function markdownToHtml(markdown) {
  let html = markdown
  
  // 转换标题
  html = html.replace(/^### (.*$)/gim, '<h3>$1</h3>')
  html = html.replace(/^## (.*$)/gim, '<h2>$1</h2>')
  html = html.replace(/^# (.*$)/gim, '<h1>$1</h1>')
  
  // 转换粗体和斜体
  html = html.replace(/\*\*\*([^*]+)\*\*\*/g, '<strong><em>$1</em></strong>')
  html = html.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>')
  html = html.replace(/\*([^*]+)\*/g, '<em>$1</em>')
  
  // 转换代码块
  html = html.replace(/```(\w+)?\n([\s\S]*?)```/g, (match, language, code) => {
    const highlighted = highlightCode(code, language || 'javascript')
    return `<pre class="code-block"><code class="language-${language || 'text'}">${highlighted}</code></pre>`
  })
  
  // 转换行内代码
  html = html.replace(/`([^`]+)`/g, '<code class="inline-code">$1</code>')
  
  // 转换链接
  html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2" target="_blank">$1</a>')
  
  // 转换图片
  html = html.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, '<img src="$2" alt="$1" />')
  
  // 转换列表
  html = html.replace(/^\* (.+)$/gim, '<li>$1</li>')
  html = html.replace(/(<li>.*<\/li>)/s, '<ul>$1</ul>')
  
  // 转换换行
  html = html.replace(/\n/g, '<br>')
  
  return html
}

// 复制到剪贴板
export async function copyToClipboard(text) {
  try {
    if (navigator.clipboard && window.isSecureContext) {
      await navigator.clipboard.writeText(text)
      return true
    } else {
      // 降级方案
      const textArea = document.createElement('textarea')
      textArea.value = text
      textArea.style.position = 'fixed'
      textArea.style.left = '-999999px'
      textArea.style.top = '-999999px'
      document.body.appendChild(textArea)
      textArea.focus()
      textArea.select()
      const result = document.execCommand('copy')
      textArea.remove()
      return result
    }
  } catch (error) {
    console.error('复制失败:', error)
    return false
  }
}

// 格式化文件大小
export function formatFileSize(bytes) {
  if (bytes === 0) return '0 Bytes'
  
  const k = 1024
  const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

// 防抖函数
export function debounce(func, wait) {
  let timeout
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout)
      func(...args)
    }
    clearTimeout(timeout)
    timeout = setTimeout(later, wait)
  }
}

// 节流函数
export function throttle(func, limit) {
  let inThrottle
  return function() {
    const args = arguments
    const context = this
    if (!inThrottle) {
      func.apply(context, args)
      inThrottle = true
      setTimeout(() => inThrottle = false, limit)
    }
  }
}

// 本地存储工具
export const storage = {
  get(key, defaultValue = null) {
    try {
      const item = window.localStorage.getItem(key)
      return item ? JSON.parse(item) : defaultValue
    } catch (error) {
      console.error('读取本地存储失败:', error)
      return defaultValue
    }
  },
  
  set(key, value) {
    try {
      window.localStorage.setItem(key, JSON.stringify(value))
      return true
    } catch (error) {
      console.error('写入本地存储失败:', error)
      return false
    }
  },
  
  remove(key) {
    try {
      window.localStorage.removeItem(key)
      return true
    } catch (error) {
      console.error('删除本地存储失败:', error)
      return false
    }
  },
  
  clear() {
    try {
      window.localStorage.clear()
      return true
    } catch (error) {
      console.error('清空本地存储失败:', error)
      return false
    }
  }
}