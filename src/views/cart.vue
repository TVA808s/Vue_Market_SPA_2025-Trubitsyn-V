<template>
  <div class='cart'>
    <h2>Cart</h2>
    <div class="information">
      <table>
        <thead>
          <tr>
            <th><input v-model="masterCheck" type="checkbox"></th>
            <th>Name</th>
            <th>Category</th>
            <th>Price</th>
            <th>Amount</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in favProducts.cartItem" :key="item.id">
            <th><input @click="checkboxDoSum(item)" :checked="masterCheck" value="{{item}}" type="checkbox"></th>
            <th class="title">{{ item.product.title.slice(0, 50)}}</th>
            <th>{{ item.product.category }}</th>
            <th>{{ item.product.price * item.quantity}}</th>
            <th>
              <div class="double-cell">
                {{ item.quantity }}
                <div class="count-buttons">
                  <Button @click="increase(item)">+</Button>
                  <Button @click="decrease(item)">-</Button>
                </div>
              </div>
            </th>
            <th>
              <div class="double-cell">
                  <Button @click="remove(item)">Delete</Button>
                  <Button @clicl="visit()">Visit</Button>
              </div>
            </th>
          </tr>

        </tbody>
      </table>
      <div class="pay-div">
        <Button><h2>Make an order</h2></Button>
        <div class="count-div">
          <h4>Goods</h4>
          <h4>{{ goods }}</h4>
        </div>
        <div class="cost-div">
          <h4>Cost</h4>
          <h4>{{ cost }}</h4>
        </div>
        <div class="discount-div">
          <h4>Discount</h4>
          <h4>{{ discount }}</h4>
        </div>
        <div class="total-div">
          <h3>Total</h3>
          <h3>{{ total }}</h3>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import Checkbox from '@/components/ui/checkbox/Checkbox.vue';
import Button from '@/components/ui/button/Button.vue';
import { supabase } from '@/stores/userSession';
import { useFavProductsStore } from '@/stores/favProducts';
import {ref, onMounted} from 'vue'
const favProducts = useFavProductsStore()
const goods = ref(0)
const cost = ref(0)
const total = ref(0)
const discount = ref(0)
const masterCheck = ref(true)
const cart_id = ref('')
const selectedItems = ref(new Set())
onMounted(async () => {
  const {data: {user}} = await supabase.auth.getUser()
  if (user) {
      const {data} = await supabase.from('carts').select('id').eq('user_id', user.id)
      if (!data[0].id) {
        alert('add some to the cart')
      } else {
        cart_id.value = data[0].id
        const {data: cart_items} = await supabase.from('cart_items').select('id, quantity, product_id').eq('cart_id', data[0].id).in('product_id', favProducts.cartList)
        const {data: products} = await supabase.from('products').select('title, category, price, id, stock, discount').in('id', favProducts.cartList)
        favProducts.cartItem = cart_items.map(item => ({
          ...item,
          product: products.find(p => p.id === item.product_id)
        }))
      }
  } else {
    console.log('not logged')
  }
})

const checkboxDoSum = (item) => {
  
}

const increase = async (item) => {
  if (item.quantity >= item.product.stock) {
    alert("we don't have this amount in stock")
  } else {
    item.quantity += 1
    await supabase.from('cart_items').update({quantity: item.quantity}).eq('cart_id', cart_id.value).eq('product_id', item.product.id)
  }
}

const decrease = async (item) => {
  item.quantity -= 1
  if (item.quantity === 0) {
    remove(item)
  } else {
    await supabase.from('cart_items').update({quantity: item.quantity}).eq('cart_id', cart_id.value).eq('product_id', item.product.id)
  }
}

const remove = async (item) => {
  await supabase.from('cart_items').delete().eq('cart_id', cart_id.value).eq('product_id', item.product.id)
  const index = favProducts.cartItem.indexOf(item)
  favProducts.cartItem.splice(index, 1)
}
</script>

<style lang="scss" scoped>
@use '@/extends.scss';
h2{
  @extend %h2;
}
h3{
  @extend %h3;
}
h4{
  @extend %h4;
}

@media (width < 850px) {
  tr{
    th{
      font-size: 16px;
    }
  }
}
@media (width < 720px) {
  tr{
    th{
      font-size: 14px;
    }
  }
}

.cart{
  padding-top: 20px;
  display: flex;
  flex-direction: column;
  gap: 20px;
  width: 90%;
  margin: 0 auto;
  .information{
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    align-items: center;
    gap: 50px;
    table{
      flex-grow: 1;
      min-width: 70%;

      .double-cell{
        display: flex;
        justify-content: space-around;
        align-items: center;
        >Button{
          width: 40%;
        }
      }
      .count-buttons{
        display: flex;
        flex-direction: column;
        gap: 5px;
        Button{
          padding: 10px;
          height: 30px;
          width: 30px;
        }
      }
      *>Button{
        color: black;
        background-color: whitesmoke;
      }
      *>Button:hover{
        transition: 0.1s;
        background-color: rgb(202, 202, 202);
      }
    }
    .pay-div {
    padding: 25px 0px;
    width: 280px;
    border: 1px solid black;
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: 15px;
    height: 100%;
    Button{
      width: 70%;
      margin: 0 auto;
      border: none;
      border-radius: 5px;
      background-color: rgb(107, 85, 70);
    }
    Button:hover{
      background-color: rgb(194, 106, 47);
      box-shadow: 2px 2px 8px 1px rgb(80, 80, 80);
    }
    h2{
      display: flex;
      justify-content: center;
    }
    .count-div, .cost-div, .discount-div, .total-div{
      display: flex;
      width: 60%;
      justify-content: space-between;
      margin: 0 auto;
    }
    }
  }
}

tr{
  border-collapse: collapse;
  th{
    flex-grow: 1;
    @extend %h3;
    border: 1px solid black;
    min-width: 5%;
    padding: 3px;
  }
}
</style>
