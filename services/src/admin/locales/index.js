import Vue from 'vue'
import VueI18n from 'vue-i18n'

import enUS from './lang/en-US'
import zhCN from './lang/zh-CN'

Vue.use(VueI18n)

export const defaultLang = 'zh-CN'

const messages = {
  'en-US': {
    ...enUS
  },
  'zh-CN': {
    ...zhCN
  }
}

const i18n = new VueI18n({
  locale: defaultLang,
  messages
})

export default i18n
