import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useFavProductsStore = defineStore('favProducts', () => {
  const favList = ref([])

  const setFavList = (value) => {
    favList.value = value
  }

  const cartList = ref([])

  const setCartList = (value) => {
    cartList.value = value
  }

  return { favList, setFavList, cartList, setCartList }
});
