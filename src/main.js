import { createApp } from 'vue'
import { createPinia } from 'pinia'
import VueLazyload from 'vue-lazyload';

import App from './App.vue'
import router from './router'

const app = createApp(App)

app.use(createPinia())
app.use(router)
app.use(VueLazyload, {
  preLoad: 1.2,
  error: '/not-found.webp',
  attempt: 1,
  loading: '/no-photo.avif',
  ssr: true
})

app.mount('#app')
