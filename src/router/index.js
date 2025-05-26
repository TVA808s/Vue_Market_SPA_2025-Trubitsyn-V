import { createRouter, createWebHistory } from 'vue-router'
import Market from '@/views/market.vue'
import { useUserSessionStore, supabase } from '../stores/userSession';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'market',
      component: Market,
    },
    {
      path: '/market/:productId',
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

router.beforeEach(async (to, from, next) => {
  const userSession = useUserSessionStore();
  // Если маршрут требует авторизации, а пользователь не авторизован
  if (to.meta.needsAuth) {
    if (userSession.loggedIn) {
      next()
    } else {
      userSession.setOpenLogWindow(true)
      next({query: {redirect: to.fullPath}}) // name: 'market',
    }
  }
  else {
    next()
  }
});

export default router
