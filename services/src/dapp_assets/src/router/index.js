import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/Home/Home.vue')
  },

  {
    path: '/library',
    name: 'Library',
    component: () => import('@/views/Library/Library.vue')
  },
  {
    path: '/dapp',
    name: 'Dapp',
    component: () => import('@/views/Dapp/Dapp.vue')
  },

  {
    path: '/submitDapp',
    name: 'submitDapp',
    component: () => import('@/views/SubmitDapp/SubmitDapp.vue')
  },
  {
    path: '/detail/:id',
    name: 'Detail',
    component: () => import('@/views/Detail/Detail.vue')
  },
  {
    path: '/hackathon',
    name: 'Hackathon',
    component: () => import('@/views/Hackathon/Hackathon.vue')
  },
  {
    path: '/sponsor',
    name: 'Sponsor',
    component: () => import('@/views/Sponsor/Sponsor.vue')
  }
]

const router = new VueRouter({
  mode: 'hash',
  // mode: 'history',
  base: process.env.BASE_URL,
  routes,
  scrollBehavior() {
    return { x: 0, y: 0 }
  }
})

export default router
