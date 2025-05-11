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

  const cartItem = ref([])

  const setCartItem = (value) => {
    cartItem.value = value
  }

  const total = ref(0)

  const setTotal = (value) => {
    total.value = value
  }
  return { favList, setFavList, cartList, setCartList, cartItem, setCartItem, total, setTotal }
});
