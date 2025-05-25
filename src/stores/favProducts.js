import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useFavProductsStore = defineStore('favProducts', () => {
  const favList = ref(new Set())

  const setFavList = (value) => {
    favList.value = value
  }

  const cartList = ref(new Set())

  const setCartList = (value) => {
    cartList.value = value
  }

  const cartItem = ref(new Set())

  const setCartItem = (value) => {
    cartItem.value = value
  }

  const total = ref(0)

  const setTotal = (value) => {
    total.value = value
  }
  return { favList, setFavList, cartList, setCartList, cartItem, setCartItem, total, setTotal }
});
