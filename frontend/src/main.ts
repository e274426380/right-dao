import 'element-plus/dist/index.css'; // element plus 生效的样式

import '@purge-icons/generated'; // 导入 icons
import { createApp } from 'vue';
import i18n from './locale';
import router from './router';
import store from './store';
import App from './App.vue';

import { VueClipboard } from '@soerenmartius/vue3-clipboard'; //复制到粘贴板

const app = createApp(App);
app.use(i18n).use(router).use(store).use(VueClipboard);
app.mount('#app');
