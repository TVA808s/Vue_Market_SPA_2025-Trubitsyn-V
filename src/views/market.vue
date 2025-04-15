<template>
  <div class='content'>
    <aside class="sidebar">
      <form @submit.prevent="asideApply">
        <div class="apply-div">
          <h2>Filters</h2>
          <Button id="apply-button" type="submit">Apply</Button>
        </div>
        <h3>Cost</h3>
        <div class="cost-div">
          <Input id="from-input" type="text" placeholder="0" name="from"/>
          <Input id="to-input" type="text" placeholder="1000" name="to"/>
        </div>
        <h3>Color</h3>
        <div class="color-div">
          <div class="flex gap-2">
            <Checkbox id="grey" name="color" value="grey" />
            <label
              for="grey"
              class="cursor-pointer text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
              grey
            </label>
          </div>
          <div class="flex gap-2">
            <Checkbox id="yellow" name="color" value="yellow"/>
            <label
              for="yellow"
              class="cursor-pointer text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
              yellow
            </label>
          </div>
          <div class="flex gap-2">
            <Checkbox id="pink" name="color" value="pink" />
            <label
              for="pink"
              class="cursor-pointer text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
              pink
            </label>
          </div>
          <div class="flex gap-2">
            <Checkbox id="blue" name="color" value="blue"/>
            <label
              for="blue"
              class="cursor-pointer text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
              blue
            </label>
          </div>
          <div class="flex gap-2">
            <Checkbox id="purple" name="color" value="purple"/>
            <label
              for="purple"
              class="cursor-pointer text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
              purple
            </label>
          </div>
          <div class="flex gap-2">
            <Checkbox id="beige" name="color" value="beige"/>
            <label
              for="beige"
              class="cursor-pointer text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
              beige
            </label>
          </div>
          <div class="flex gap-2">
            <Checkbox id="black" name="color" value="black"/>
            <label
              for="black"
              class="cursor-pointer text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
              black
            </label>
          </div>
          <div class="flex gap-2">
            <Checkbox id="white" name="color" value="white"/>
            <label
              for="white"
              class="cursor-pointer text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
              white
            </label>
          </div>
        </div>
        <h3>Discount</h3>
        <div class="discount-div">
          <div class="flex gap-2">
            <Checkbox id="discount" name="discount" />
            <label
              for="discount"
              class="cursor-pointer text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
              discount
            </label>
          </div>
        </div>
        <h3>Brand</h3>
        <div class="brand-div">
          <div class="flex gap-2">
            <Checkbox id="apple" name="brand" value="apple"/>
            <label
              for="apple"
              class="cursor-pointer text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
              apple
            </label>
          </div>
          <div class="flex gap-2">
            <Checkbox id="sony" name="brand" value="sony"/>
            <label
              for="sony"
              class="cursor-pointer text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
              sony
            </label>
          </div>
          <div class="flex gap-2">
            <Checkbox id="samsung" name="brand" value="samsung"/>
            <label
              for="samsung"
              class="cursor-pointer text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
              samsung
            </label>
          </div>
        </div>
      </form>
    </aside>
    <div class="main-side">
    <div class="top-main-side">
    <h2>Sell page</h2>
    <form @change="sortApply()">
    <Select v-model="filters.sorting">
      <SelectTrigger class="w-[300px]">
        <SelectValue placeholder="Sort by" />
      </SelectTrigger>
      <SelectContent>
        <SelectLabel>Sort by</SelectLabel>
        <SelectGroup>
          <SelectItem v-for="sortType in sortTypes" :value="sortType.value">
            {{ sortType.text }}
          </SelectItem>
        </SelectGroup>
      </SelectContent>
    </Select>
  </form>
    </div>
    <main class="cards">
      <!-- товары -->

      <div class="card" v-for="product in products" :key="product.id" >
        <div class="img-div" >
          <img :src="product.image" @error="loadImageError($event)" :alt="product.category">
        </div>
        <button id="card-button">
          <h4 id="title">{{ product.title }}</h4>
        </button>
        <div class="rate-price-div">
          <h4 id="rate">{{ Stars(product.rate) }}</h4>
          <h4 id="price">{{ product.price }}</h4>
        </div>

        <div class="btns-div">
          <Button class="fav"><svg id="favourite" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="2 2 20 20"><path fill="currentColor" d="m12.1 18.55l-.1.1l-.11-.1C7.14 14.24 4 11.39 4 8.5C4 6.5 5.5 5 7.5 5c1.54 0 3.04 1 3.57 2.36h1.86C13.46 6 14.96 5 16.5 5c2 0 3.5 1.5 3.5 3.5c0 2.89-3.14 5.74-7.9 10.05M16.5 3c-1.74 0-3.41.81-4.5 2.08C10.91 3.81 9.24 3 7.5 3C4.42 3 2 5.41 2 8.5c0 3.77 3.4 6.86 8.55 11.53L12 21.35l1.45-1.32C18.6 15.36 22 12.27 22 8.5C22 5.41 19.58 3 16.5 3"/></svg></Button>
          <Button id="add" class="to-cart">Add</Button>
        </div>
      </div>
    </main>
  </div>
</div>
</template>

<script setup>
import Input from '@/components/ui/input/Input.vue'
import Checkbox  from '@/components/ui/checkbox/Checkbox.vue'
// import Skeleton from '@/components/ui/skeleton/Skeleton.vue'
import Select from '@/components/ui/select/Select.vue'
import SelectContent from '@/components/ui/select/SelectContent.vue'
import SelectGroup from '@/components/ui/select/SelectGroup.vue'
import SelectItem from '@/components/ui/select/SelectItem.vue'
import SelectValue from '@/components/ui/select/SelectValue.vue'
import SelectTrigger from '@/components/ui/select/SelectTrigger.vue'
import SelectLabel from '@/components/ui/select/SelectLabel.vue'
import Button from '@/components/ui/button/Button.vue'
import {reactive, ref, onMounted, defineProps, watch} from 'vue'
import no_image from '@/images/no-photo.avif'
import { createClient } from '@supabase/supabase-js'
const supabase = createClient(import.meta.env.VITE_SUPABASE_URL, import.meta.env.VITE_SUPABASE_KEY)

// работа категорий
const props = defineProps({
  categoryName: {
    type: String,
    default: null
  }
})


// вывод карточек
const products = ref([])
const loading = ref(true)
const moreGoods = ref(true)

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
  sorting: ['id', {ascending: true}]
})

const fetchProducts = async () => {
  try {
    loading.value = true
    let fetch = supabase
      .from('market')
      .select('*')
      .order(filters.sorting[0], filters.sorting[1])
      .range(filters.start, filters.end - 1)
      .gte('price', filters.from)
      .lte('price', filters.to)
      .in('color', filters.colors)
      .not('discount', 'eq', filters.discount)
      .in('brand', filters.brand)

    if (props.categoryName) fetch = fetch.eq('category', props.categoryName)

    const {data, error} = await fetch

    moreGoods.value = data.length >= 12
    products.value = [...products.value, ...data]

  } catch (e) {
    console.log(e.message)
  } finally {
    loading.value = false
  }
}

// сброс товаров
const productsReset = () => {
  filters.start = 0
  filters.end = 12
  products.value = []
  moreGoods.value = true
}

// функционал скролинга
const handleScroll = () => {
  const { scrollTop, clientHeight, scrollHeight } = document.documentElement
  const isBottom = scrollTop + clientHeight >= scrollHeight - 300
  if (isBottom && !loading.value && moreGoods.value) {
    filters.start = filters.start + 12
    filters.end = filters.end + 12
    fetchProducts()
  }
}
onMounted(() => {
  fetchProducts()
  window.addEventListener('scroll', handleScroll)
})

// обработка карточек
  // скелетоны можно добавить
const Stars = (rate) => {
  if (0<rate && rate<2) return '★☆☆☆☆'
  if (2<rate && rate<3) return '★★☆☆☆'
  if (3<rate && rate<4) return '★★★☆☆'
  if (4<rate && rate<5) return '★★★★☆'
  return '★★★★★'
}
const loadImageError = (event) => {
event.target.src = no_image
event.target.onerror = null
}

// функционал сортировки
const sortTypes = ref([
  {text: "default", value: ["id", {ascending: true}]},
  {text: "cost-up", value: ["price", {ascending: true}]},
  {text: "rate-down", value: ["rate", {ascending: false}]},
  {text: "cost-down", value: ["price", {ascending: false}]},
  {text: "rate-up", value: ["rate", {ascending: true}]}
])

const sortApply = () => {
  productsReset()
  fetchProducts()
}


// функционал aside
const asideApply = (event) => {
  const formData = new FormData(event.target)
  filters.from = formData.get('from') || 0
  filters.to = formData.get('to') || 32000
  filters.colors = formData.getAll('color').length != 0 ? formData.getAll('color') : ['grey','yellow','pink','blue','purple','beige','black','white']
  filters.discount = formData.get('discount') ? 0 : 101
  filters.brand = formData.getAll('brand').length != 0 ? formData.getAll('brand') : [
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
  ]

  productsReset()
  fetchProducts()
}
</script>

<style lang="scss" scoped>
@use '@/extends.scss';
h1,h2,h3{
@extend %cursor;
}
h2{
  @extend %h2;
}
h3{
  @extend %h3;
}

@media (width < 720px) {
  .sidebar{
    display: none;
  }

}
@media (width < 850px) {
  .content{
    .cards{
      .card{
        #title{
          font-size: 0.9rem !important;
        }
        #rate{
          font-size: 0.9rem !important;
        }
        #price{
          font-size: 1.1rem !important;
        }
        .btns-div{
          display: flex;
          flex-direction: row;
          .to-cart{
            display: none;
          }
          Button{
            height: 25px;
            width: 100%;
          }
        }
      }
    }
  }
}
.content{
display: flex;
padding: 20px 0px;
.sidebar{
  padding-right: 20px;
  position: sticky;
  top: 15px;
  height: 100vh;
  .apply-div{
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 20px;
    Button{
      background-color: rgb(235, 235, 235);
      color: black;
      width: 80px;
    }
    Button:hover{
      background-color: rgb(168 162 158);
    }
  }
  form{
    display: flex;
    flex-direction: column;
    gap: 15px;
    .cost-div{
      display: flex;
      width: 90%;
      gap: 10px;
      Input{
        width: 80px;
      }
    }
    .color-div, .discount-div, .brand-div{
      display: flex;
      flex-direction: column;
      gap: 10px;
      *{
        font-size: 16px;
        font-weight: 400;
      }
    }
  }
}
.main-side{
  display: flex;
  width: 100%;
  flex-direction: column;
  gap: 20px;
  .top-main-side{
    display: flex;
    align-items: center;
    gap: 5%;
    flex-wrap: wrap;
  }
}
.cards{
  display: flex;
  flex-wrap: wrap;
  gap: 30px;
  .card{
    display: flex;
    flex-direction: column;
    justify-content: center;
    width: 20%;
    gap: 5px;
    #card-button{
      cursor: pointer;
    }
    #card-button:hover{
      transition: 0.1s;
      color:rgb(134, 134, 219);
    }
    .img-div{
      flex-grow: 1;
      text-align: center;
      min-width: 50px;
      min-height: 50px;
      // .skeleton{
      //   width: 100%;
      //   height: 100%;
      //   object-fit: cover;
      // }
    }

    // вебкит для обрезки текста построчно
    #title {
      font-size: 1rem;
      font-weight: 600;
      line-height: 1.3;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
      text-align: center;
    }
    .rate-price-div {
      display: flex;
      justify-content: space-around;
      align-items: center;
      margin-top: auto;
      flex-wrap: wrap;
      width: 100%;
      #rate {
        color: #b69e73;
        font-size: 1.2rem;
      }
      #price {
        font-size: 1.25rem;
        color: #2d2d2d;
        font-weight: 700;
        &::before {
          content: '$';
          font-size: 0.9em;
          margin-right: 2px;
        }
      }
    }
    .btns-div{
      display: flex;
      width: 100%;
      gap: 10px;
      .fav{
        background-color: rgb(235, 235, 235);
        color: rgb(179, 114, 114);
      }
      .fav:hover{
        transition: 0.1s ease-out;
        background-color: rgb(228, 207, 207);
        color: rgb(236, 115, 115);
      }
      .to-cart{
        flex-grow: 1;
      }
      .to-cart:hover{
        transition: 0.1s ease-out;
        background-color: rgb(168 162 158);
        color: rgb(12 10 9);
      }
    }
  }
  >*{
    margin: 0 auto;
  }
}
}
</style>
