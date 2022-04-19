import axios from 'axios'

// 创建 axios 实例
const service = axios.create({
  baseURL: 'https://www.icpleague.com/api', // API 请求的默认前缀
  timeout: 6000 // 请求超时时间
})

const errorHandler = error => {
  return Promise.reject(error)
}

service.interceptors.request.use(config => {
  return config
}, errorHandler)

service.interceptors.response.use(response => {
  return response.data
}, errorHandler)

export default service
