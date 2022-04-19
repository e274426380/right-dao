import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import i18n from './locales'
import ElementUI from 'element-ui';
Vue.use(ElementUI);

import './plugins/element.js';

import 'element-ui/lib/theme-chalk/index.css';
import 'bootstrap/dist/css/bootstrap.min.css'
import 'a@/assets/css/style.css'
import 'a@/assets/css/default.css'
import 'a@/assets/css/global.css'
import 'a@/assets/css/iconfont.css'

Vue.config.productionTip = false

Vue.prototype.startLoading=function(area,text){
  const loading = this.$loading({
      lock: true,
      text: text,
      target: document.querySelector(area)//设置加载动画区域
    });
  // console.log("loading:");
  // console.log(area+":"+text);
  return loading;
  }

new Vue({
  router,
  store,
  i18n,
  render: h => h(App)
}).$mount('#app')
