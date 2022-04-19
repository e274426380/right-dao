import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import i18n from './locales'
import axios from 'axios'
import ElementUI from 'element-ui'
import Clipboard from 'v-clipboard'

Vue.use(ElementUI)
Vue.use(Clipboard)

// import './registerServiceWorker' // pwa应用
import './plugins/element.js' // 引入element-ui组件

// 引入样式
import 'element-ui/lib/theme-chalk/index.css'
import 'bootstrap/dist/css/bootstrap.min.css'
import '@/assets/css/style.css'
import '@/assets/css/default.css'
import '@/assets/css/global.css'
import '@/assets/fonts/stylesheet.css'

Vue.config.productionTip = false
Vue.prototype.axios = axios

new Vue({
    router,
    store,
    i18n,
    render: h => h(App)
}).$mount('#app')
