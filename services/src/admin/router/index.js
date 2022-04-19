import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    component: () => import('a@/views/Roles/index.vue')
  },
  {
    path: '/role',
    name: 'Roles',
    component: () => import('a@/views/Roles/index.vue')
  },
  {
    path: '/dapp',
    name: 'Dapp',
    component: () => import('a@/views/Dapp/index.vue')
  },
  {
    path: '/submitDapp',
    name: 'SubmitDapp',
    component: () => import('a@/views/Dapp/modules/SubmitDapp.vue')
  },
  {
    path: '/log',
    name: 'Log',
    component: () => import('a@/views/Log/index.vue')
  },
  {
    path: '/hackathon',
    name: 'Hackathon',
    component: () => import('a@/views/Hackathon/index.vue'),
    children:[
      {
        path: 'sponsors',
        name: 'Sponsors',
        component: () => import('a@/views/Hackathon/modules/Sponsors.vue')
      },
      {
        path: 'awards',
        name: 'Awards',
        component: () => import('a@/views/Hackathon/modules/Awards.vue')
      },
      {
        path: 'bounty',
        name: 'Bounty',
        component: () => import('a@/views/Hackathon/modules/Bounty.vue')
      },
      {
        path: 'hackathon',
        name: 'Hackathon',
        component: () => import('a@/views/Hackathon/modules/Hackathon.vue')
      },
      {
        // path: '/hackathon/editHackathon',
        path: 'editHackathon',
        name: 'EditHackathon',
        component: () => import('a@/views/Hackathon/modules/editHackathon.vue')
      },
    ]
  },

  {
    path: '/banner',
    name: 'Banner',
    component: () => import('a@/views/Banner/index.vue')
  },
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
