<template>
  <div class='productInfo'>
    <div class="imgZone">
      <div class="imgContainer">
        <img v-lazy="product.image" :alt="product.title">
      </div>
    </div>
    <div class="textZone">
      <h1>{{ product.title }}</h1>
      <div class="rateStockDiv">
        <h3 class="rate">{{ Stars(product.rate) }}</h3>
        <h2>In stock {{ product.stock }}</h2>
      </div>
      <h2>Product info</h2>
      <h3>{{ product.description }}</h3>
      <h2>Brand: {{ product.brand }}</h2>
      <h2>Category: {{ product.category }}</h2>
      <h2>Color: {{ product.color }}</h2>
    </div>
    <div class="addZone">
      <div class="prices" v-if="product.discount > 0">
        <h1>{{ product.price * (1-product.discount/100) }}$</h1>
        <h3>was {{ product.price }}$</h3>
      </div>
      <div class="prices" v-else>
        <h2>Price is {{ product.price }}$</h2>
      </div>
      <div class="btns-div">
          <Button @click="toFav(product.id)" :class="[favProducts.favList.includes(product.id) ? 'fav' : 'unfav']"><svg id="favourite" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="2 2 20 20"><path fill="currentColor" d="m12.1 18.55l-.1.1l-.11-.1C7.14 14.24 4 11.39 4 8.5C4 6.5 5.5 5 7.5 5c1.54 0 3.04 1 3.57 2.36h1.86C13.46 6 14.96 5 16.5 5c2 0 3.5 1.5 3.5 3.5c0 2.89-3.14 5.74-7.9 10.05M16.5 3c-1.74 0-3.41.81-4.5 2.08C10.91 3.81 9.24 3 7.5 3C4.42 3 2 5.41 2 8.5c0 3.77 3.4 6.86 8.55 11.53L12 21.35l1.45-1.32C18.6 15.36 22 12.27 22 8.5C22 5.41 19.58 3 16.5 3"/></svg></Button>
          <Button @click="toCart(product.id)" :class="[favProducts.cartList.includes(product.id) ? 'incart' : 'uncart']"></Button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { Button } from '@/components/ui/button'
import { ref, onMounted } from 'vue'
import { supabase, useUserSessionStore } from '@/stores/userSession'
import { useFavProductsStore } from '@/stores/favProducts'
const favProducts = useFavProductsStore()
const userSession = useUserSessionStore()
const props = defineProps({
  productId: {
    type: String,
    default: null
  }
})

const product = ref([])
onMounted(async () => {
  try {
    const {data, error} = await supabase.from('products').select('*').eq('id', Number(props.productId))
    product.value = data[0]

    const {data: {user}} = await supabase.auth.getUser()
    if (user) {
      const {data:favs} = await supabase.from('favourites').select('product_id').eq('user_id', user.id)
      favProducts.favList = favs.map(item => item.product_id)
      const {data:carts} = await supabase.from('carts').select('cart_items (product_id)').eq('user_id', user.id)
      favProducts.cartList = carts[0].cart_items.map(item => item.product_id)
    } else {
      console.log('not logged')
    }
  } catch (e) {
    console.log(e)
  }
})

const Stars = (rate) => {
  if (0<rate && rate<2) return '★☆☆☆☆'
  if (2<rate && rate<3) return '★★☆☆☆'
  if (3<rate && rate<4) return '★★★☆☆'
  if (4<rate && rate<5) return '★★★★☆'
  return '★★★★★'
}

const toFav = async (product) => {
  const {data: {user}} = await supabase.auth.getUser()
  if (user) {
    if (!favProducts.favList.includes(product)) {
      await supabase.from('favourites').insert({user_id: user.id, product_id: product})
      favProducts.favList.push(product)
    } else {
      const {error} = await supabase.from('favourites').delete().eq('user_id', user.id).eq('product_id', product)
      favProducts.favList.splice(favProducts.favList.indexOf(product), 1)
    }
  } else {
    userSession.setOpenLogWindow(true)
  }
}

const toCart = async (product) => {
  const {data: {user}} = await supabase.auth.getUser()
  if (user) {
    const {data} = await supabase.from('carts').select('id').eq('user_id', user.id)
    let cart = data[0]
    if (!favProducts.cartList.includes(product)) {
      if (data.length < 1) {
        await supabase.from('carts').insert({user_id: user.id, created_at: new Date(Date.now()).toISOString()})
        const {data} = await supabase.from('carts').select('id').eq('user_id', user.id)
        cart = data[0]
      }
      await supabase.from('cart_items').insert({cart_id: cart.id, product_id: product, quantity: 1})
      favProducts.cartList.push(product)
    } else {
      await supabase.from('cart_items').delete().eq('cart_id', cart.id).eq('product_id', product)
      favProducts.cartList.splice(favProducts.cartList.indexOf(product), 1)
    }
  } else {
    userSession.setOpenLogWindow(true)
  }
}
</script>

<style lang="scss" scoped>
@use '@/extends.scss';
h1,h2,h3{
@extend %cursor;
}
h1{
  @extend %h1;
}
h2{
  @extend %h2;
}
h3{
  @extend %h3;
}
@media (width > 949px) {
  .productInfo{
    gap: 5%;
  }
  .imgZone{
    border: 1px solid black;
    align-self: center;
  }
  .addZone{
    min-width: 20%;
    height: 220px;
    border: 1px solid black;
    align-self: center;
    padding: 10px;
  }
}
@media (width < 950px) {
  .productInfo{
    flex-wrap: wrap;
    align-content: flex-start;
    .imgZone{
      order: 1;
      flex: 0 0 50%;
    }
    .addZone{
      order: 2;
      flex: 0 0 50%;
      max-width: 50%;
    }
    .textZone{
      order: 3;
      flex: 0 0 100%;
      max-width: 100%;
      margin-top: 20px; /* Отступ от верхнего ряда */
    }
  }
}
@media (width < 650px) {
  h1{
    font-size: 22px;
  }
  h2{
    font-size: 18px;
  }
  h3{
    font-size: 16px;
  }
}

.productInfo {
  display: flex;
  padding: 20px 0;

  position: relative;
}

.imgZone{
  min-width: 30%;
}
.textZone{
  display: flex;
  flex-direction: column;
  gap: 20px;
  .rateStockDiv{
    display: flex;
    gap: 10%;
    .rate{
      font-size: 1.4rem !important;
    }
  }
}
.addZone{


  display: flex;
  flex-direction: column;
  gap: 10%;
  justify-content: center;
  align-items: center;
  .prices{
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }
  .btns-div{
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    Button{
      min-width: 70px;
    }
  }
}
.btns-div{
  display: flex;
  width: 100%;
  gap: 10px;
  .unfav{
    background-color: rgb(235, 235, 235);
    color: rgb(179, 114, 114);
  }
  .fav{
    background-color: rgb(255, 222, 222);
    color: rgb(238, 31, 31);
  }
  .unfav:hover, .fav:hover{
    transition: 0.1s ease-out;
    background-color: rgb(228, 207, 207);
    color: rgb(236, 115, 115);
  }
  .incart, .uncart{
    flex-grow: 1;
  }
  .uncart{
    background-color: #3d3535;
  }
  .uncart::after{
    content: 'Add';
  }
  .incart{
    background-color: #beb3b3;
    color:#ffe8e8
  }
  .incart::after{
    content: 'Remove';
  }
  .incart:hover, .uncart:hover{
    transition: 0.1s ease-out;
    background-color: rgb(199, 185, 176);
    color: rgb(63, 50, 42);
  }
}
</style>
