import zhLocale from 'element-ui/lib/locale/lang/zh-CN'

import navbar from './zh-CN/navbar'
import home from './zh-CN/home'

const components = {
  elementLocale: zhLocale
}

export default {
  ...components,
  ...navbar,
  ...home
}
