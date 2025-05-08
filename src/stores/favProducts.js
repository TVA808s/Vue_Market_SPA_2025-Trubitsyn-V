import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useFavProductsStore = defineStore('favProducts', () => {
  const favList = ref([])

  const setFavList = (value) => {
    favList.value = value
  }

  
  return { favList, setFavList }
});
