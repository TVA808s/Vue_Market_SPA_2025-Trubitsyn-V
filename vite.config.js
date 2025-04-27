import { fileURLToPath, URL } from 'node:url'
import path from 'node:path'
import tailwindcss from '@tailwindcss/vite'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { ViteImageOptimizer } from 'vite-plugin-image-optimizer'
// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    tailwindcss(),
    ViteImageOptimizer({
      include: /\.(jpe?g|png|gif|tiff|webp|svg|avif)$/i,
      webp: {quality: 10},
      avif: {quality: 10},
      svg: {quality: 80}
    })
  ],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
})
