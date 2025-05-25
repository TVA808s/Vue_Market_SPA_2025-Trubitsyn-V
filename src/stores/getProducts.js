import { defineStore } from 'pinia'
import { ref, reactive } from 'vue'
import { supabase } from './userSession'

export const useGetProductsStore = defineStore('getProducts', () => {
  const search = ref('')
  const loading = ref(false)
  const products = ref(new Set())
  const moreGoods = ref(true)
  const categoryName = ref('')
  const filters = reactive({
    start: 0,
    end: 12,
    from: 0,
    to: 32000,
    colors: ['grey','yellow','pink','blue','purple','beige','black','white'],
    discount: 0,
    brand: [
      "sony",          "microsoft",      "logitech G",
      "urbanista",     "xiaomi",         "boat",
      "samsung",       "Amkette",        "apple",
      "ant esports",   "logitech",       "Sony",
      "H&M",           "Philips",        "Nike",
      "Apple",         "Penguin",        "IKEA",
      "Adidas",        "Logitech",       "Levi's",
      "panasonic",     "mivi",           "JBL",
      "Mivi",          "soundcore",      "Marshall",
      "Bang & Olufsen","jbl",            "Denon",
      "redmi",         "mi",             "acer",
      "LG"
    ],
    sorting: ['id', {ascending: true}],
  })

  const setSearch = (value) => {
    search.value = value
  }
  const setCategoryName = (value) => {
    categoryName.value = value
  }
  const returnValue = (some) => {
    return some.value
  }
  const fetchProducts = async (favs) => {
    try {
      loading.value = true
      let fetch = supabase
        .from('products')
        .select('*')
        .order(filters.sorting[0], filters.sorting[1])
        .range(filters.start, filters.end - 1)
        .gte('price', filters.from)
        .lte('price', filters.to)
        .in('color', filters.colors)
        .not('discount', 'eq', filters.discount)
        .in('brand', filters.brand)
      if (categoryName.value) fetch = fetch.eq('category', categoryName.value)
      if (search.value) {
        fetch = fetch.or(
          `title.ilike.%${search.value}%, description.ilike.%${search.value}%, brand.ilike.%${search.value}%, category.ilike.%${search.value}%`,
        )
      }

      if (favs) {
        fetch = fetch.in('id', Array.from(favs))
      }
      const {data, error} = await fetch

      moreGoods.value = data.length >= 1
      products.value = new Set([...products.value, ...data])

    } catch (e) {
      console.log(e.message)
    } finally {
      loading.value = false
    }
  }
  const productsReset = () => {
    filters.start = 0
    filters.end = 12
    filters.favs = []
    products.value.clear()
    moreGoods.value = true
  }

  return {search, setSearch, setCategoryName, fetchProducts, productsReset, filters, products, categoryName, loading, moreGoods, returnValue}
})



