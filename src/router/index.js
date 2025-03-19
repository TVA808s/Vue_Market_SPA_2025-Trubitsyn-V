import { createRouter, createWebHistory } from 'vue-router'
import Base from '@/views/base.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: Base,
    },
    {
      path: '/user',
      name: 'user',
      component: () => import('@/views/user.vue'),
    },
  ],
})

export default router
