import enLocale from 'element-ui/lib/locale/lang/en'

import navbar from './en-US/navbar'
import home from './en-US/home'

const components = {
  elementLocale: enLocale
}

export default {
  ...components,
  ...navbar,
  ...home
}
