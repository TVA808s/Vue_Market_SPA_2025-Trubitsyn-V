import { createRouter, createWebHistory } from 'vue-router'
import Market from '@/views/market.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'market',
      component: Market,
    },
    {
      path: '/favourite',
      name: 'favourite',
      component: () => import('@/views/favourite.vue')
    },
    {
      path: '/cart',
      name: 'cart',
      component: () => import('@/views/cart.vue')
    },
    {
      path: '/profile',
      name: 'profile',
      component: () => import('@/views/profile.vue'),
    },
    {
      path: '/:categoryName',
      component: Market,
      props: true
    }
  ],
})

export default router
