import { createRouter, createWebHistory } from 'vue-router'
import Market from '@/views/market.vue'
import { useUserSessionStore } from '../stores/userSession';
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'market',
      component: Market,
    },
    {
      path: '/:productId',
      component: () => import('@/views/product.vue'),
      name: 'product',
      props: true
    },
    {
      path: '/favourite',
      name: 'favourite',
      component: () => import('@/views/favourite.vue'),
      meta: {
        needsAuth: true
      }
    },
    {
      path: '/cart',
      name: 'cart',
      component: () => import('@/views/cart.vue'),
      meta: {
        needsAuth: true
      }
    },
    {
      path: '/profile',
      name: 'profile',
      component: () => import('@/views/profile.vue'),
      meta: {
        needsAuth: true
      }
    },
    {
      path: '/:categoryName',
      component: Market,
      props: true
    }
  ],
})

router.beforeEach((to, from, next) => {
  const userSession = useUserSessionStore();
  // Если маршрут требует авторизации, а пользователь не авторизован
  if (to.meta.needsAuth && !userSession.loggedIn) {
    userSession.setOpenLogWindow(true)
    next({ name: 'market', query: {redirect: to.fullPath}})
  }
  else {
    next()
  }
});

export default router
