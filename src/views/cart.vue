<template>
  <div class="cart">
    <h2>Cart</h2>
    <div class="information">
      <table>
        <thead>
          <tr>
            <th><input @change="masterCheckDoSum()" v-model="masterCheck" type="checkbox" /></th>
            <th>Name</th>
            <th>Category</th>
            <th>Price</th>
            <th>Amount</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in favProducts.cartItem" :key="item.id">
            <th>
              <input
                @change="checkboxDoSum(item)"
                :checked="masterCheck"
                value="{{item}}"
                type="checkbox"
              />
            </th>
            <th class="title">{{ item.product.title.slice(0, 50) }}</th>
            <th>{{ item.product.category }}</th>
            <th>{{ item.product.price * item.quantity }}</th>
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
        <Button @click="makeOrder()"><h2>Make an order</h2></Button>
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
    <div class="orderWindow" v-if="userSession.openOrderWindow">
      <div class="orderWindowContent">
        <div class="contentHeader">
          <div class="closeOrderWindow" @click="userSession.setOpenOrderWindow(false)">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
              <path
                fill="none"
                stroke="currentColor"
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="m18 18l-6-6m0 0L6 6m6 6l6-6m-6 6l-6 6"
              />
            </svg>
          </div>
        </div>

        <div class="contentBody">
          <div class="contentTitle">Order info</div>
          <form @submit.prevent="payForOrder()">
            <div class="cardInfo">
              <Input placeholder="CARD NUMBER" />
              <div class="subCardInfo">
                <Input placeholder="MM" />
                <Input placeholder="YY" />
                <Input placeholder="CVS" />
              </div>
            </div>
            <div class="subInfo">
              <h3>Final sum is {{ total }}</h3>
              <Button type="submit">Pay</Button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import Button from '@/components/ui/button/Button.vue'
import Input from '@/components/ui/input/Input.vue'
import { supabase } from '@/stores/userSession'
import { useUserSessionStore } from '@/stores/userSession'
import { useFavProductsStore } from '@/stores/favProducts'
import { ref, onMounted, computed } from 'vue'
const favProducts = useFavProductsStore()
const userSession = useUserSessionStore()
const masterCheck = ref(true)
const cart_id = ref('')
const items_to_buy = ref([])
const checkout = YooMoneyCheckout('1090142', { language: 'en' })

const payForOrder = async () => {
  const product_ids = []
  items_to_buy.value.forEach((item) => product_ids.push(item.id))

  const response = await checkout.tokenize({
    number: '2202474301322987',
    cvc: '999',
    month: '01',
    year: '30'
  })
  if (response.status === 'success') {
    const { paymentToken } = response.data.response
    const { data: paymentData, error } = await supabase.functions.invoke('payment', {
      body: { token: paymentToken, product_ids: product_ids }
    });
    if (paymentData.res.paid) {
      const {data: { user }} = await supabase.auth.getUser()
      const {data: order, error} = await supabase.from('orders').insert({user_id: user.id, status: 'paid', total: paymentData.res.amount.value, created_at: new Date().toISOString()}).select()
      if (order) {
        const {data: order_items, error} = await supabase.from('order_items').insert(items_to_buy.value.map(item => ({
          order_id: order[0].id,
          product_image: item.product.image,
          product_title: item.product.title,
          quantity: item.quantity,
          price: item.quantity * item.product.price * (1 - item.product.discount / 100)
        })))
        if (error === null) {
          userSession.setOpenOrderWindow(false)
        }
      }
    } else {
      alert('www')
    }
  }
}

onMounted(async () => {
  const {
    data: { user }
  } = await supabase.auth.getUser()
  if (user) {
    const { data } = await supabase.from('carts').select('id').eq('user_id', user.id)
    if (!data[0].id) {
      alert('add some to the cart')
    } else {
      cart_id.value = data[0].id
      const { data: cart_items } = await supabase
        .from('cart_items')
        .select('id, quantity, product_id')
        .eq('cart_id', data[0].id)
        .in('product_id', favProducts.cartList)
      const { data: products } = await supabase
        .from('products')
        .select('title, category, price, id, stock, discount, image')
        .in('id', favProducts.cartList)
      favProducts.cartItem = cart_items.map((item) => ({
        ...item,
        product: products.find((p) => p.id === item.product_id)
      }))
      items_to_buy.value = [...favProducts.cartItem]
    }
  } else {
    console.log('not logged')
  }
})

const makeOrder = () => {
  userSession.setOpenOrderWindow(true)
}

const masterCheckDoSum = () => {
  if (masterCheck.value) {
    items_to_buy.value = [...favProducts.cartItem]
  } else {
    items_to_buy.value = []
  }
}

const checkboxDoSum = (item) => {
  if (items_to_buy.value.includes(item)) {
    items_to_buy.value.splice(items_to_buy.value.indexOf(item), 1)
  } else {
    items_to_buy.value.push(item)
  }
}

const goods = computed(() => {
  return items_to_buy.value.reduce((sum, item) => sum + item.quantity, 0)
})

const cost = computed(() => {
  return items_to_buy.value.reduce((sum, item) => sum + item.product.price * item.quantity, 0)
})

const discount = computed(() => {
  return Math.round((1 - total.value / cost.value) * 100) || 0
})

const total = computed(() => {
  return items_to_buy.value.reduce(
    (sum, item) => sum + item.product.price * (1 - item.product.discount / 100) * item.quantity,
    0
  )
})

const increase = async (item) => {
  if (item.quantity >= item.product.stock) {
    alert("we don't have this amount in stock")
  } else {
    item.quantity += 1
    await supabase
      .from('cart_items')
      .update({ quantity: item.quantity })
      .eq('cart_id', cart_id.value)
      .eq('product_id', item.product.id)
  }
}

const decrease = async (item) => {
  item.quantity -= 1
  if (item.quantity === 0) {
    remove(item)
  } else {
    await supabase
      .from('cart_items')
      .update({ quantity: item.quantity })
      .eq('cart_id', cart_id.value)
      .eq('product_id', item.product.id)
  }
}

const remove = async (item) => {
  await supabase
    .from('cart_items')
    .delete()
    .eq('cart_id', cart_id.value)
    .eq('product_id', item.product.id)
  const index = favProducts.cartItem.indexOf(item)
  favProducts.cartItem.splice(index, 1)
}
</script>

<style lang="scss" scoped>
@use '@/extends.scss';
h2 {
  @extend %h2;
}
h3 {
  @extend %h3;
}
h4 {
  @extend %h4;
}

@media (width < 850px) {
  tr {
    th {
      font-size: 16px;
    }
  }
  .orderWindow {
    h3 {
      font-size: 18px;
    }
    Input {
      font-size: 12px;
    }
  }
}
@media (width < 720px) {
  tr {
    th {
      font-size: 14px;
    }
  }
}

.cart {
  padding-top: 20px;
  display: flex;
  flex-direction: column;
  gap: 20px;
  width: 90%;
  margin: 0 auto;
  .information {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    align-items: center;
    gap: 50px;
    table {
      flex-grow: 1;
      min-width: 70%;

      .double-cell {
        display: flex;
        justify-content: space-around;
        align-items: center;
        > Button {
          width: 40%;
        }
      }
      .count-buttons {
        display: flex;
        flex-direction: column;
        gap: 5px;
        Button {
          padding: 10px;
          height: 30px;
          width: 30px;
        }
      }
      * > Button {
        color: black;
        background-color: whitesmoke;
      }
      * > Button:hover {
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
      Button {
        width: 70%;
        margin: 0 auto;
        border: none;
        border-radius: 5px;
        background-color: rgb(107, 85, 70);
      }
      Button:hover {
        background-color: rgb(194, 106, 47);
        box-shadow: 2px 2px 8px 1px rgb(80, 80, 80);
      }
      h2 {
        display: flex;
        justify-content: center;
      }
      .count-div,
      .cost-div,
      .discount-div,
      .total-div {
        display: flex;
        width: 60%;
        justify-content: space-between;
        margin: 0 auto;
      }
    }
  }
}
.orderWindow {
  width: 100%;
  height: 100vh;
  position: fixed;
  z-index: 1;
  top: 0;
  left: 0;
  background-color: #3f3f3f56;
  display: flex;
  justify-content: center;
  align-items: center;
  .orderWindowContent {
    display: flex;
    border: 1px solid black;
    border-radius: 15px;
    flex-direction: column;
    background-color: #ffffff;
    width: 80%;
    max-width: 650px;
    padding: 20px 35px;
    .error {
      display: flex;
      justify-content: center;
      font-size: 18px;
      border-radius: 15px;
      background-color: #ffc0c0;
      padding: 5px;
    }
    .contentHeader {
      display: flex;
      position: relative;
      justify-content: center;
      gap: 20px;
      .closeOrderWindow {
        border-radius: 5px;

        position: absolute;
        left: 101%;
        top: -15px;
      }
      .closeOrderWindow:hover {
        background-color: #ffc0c0;
        transition: 0.2s;
      }
      Button {
        height: 30px;
        color: #5a5a5a;
        background-color: white;
      }
      Button:hover {
        background-color: #e4e4e4;
        transition: 0.1s;
        color: rgb(68, 68, 68);
      }
    }
    .contentBody {
      display: flex;
      flex-direction: column;
      gap: 10px;

      .contentTitle {
        font-size: 20px;
        font-weight: 600;
      }
      form {
        padding: 0px 0px 10px 0px;
        display: flex;
        gap: 20px;
        .cardInfo {
          gap: 10px;
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
          Input {
            height: 40px;
            text-align: center;
          }
          .subCardInfo {
            display: flex;
            justify-content: center;
            gap: 15px;
          }
        }
        .subInfo {
          width: 40%;
          flex: 0 0 40%; // Фиксируем размер
          display: flex;
          flex-direction: column;
          gap: 10px;
        }
      }
    }
  }
}

tr {
  border-collapse: collapse;
  th {
    flex-grow: 1;
    @extend %h3;
    border: 1px solid black;
    min-width: 5%;
    padding: 3px;
  }
}
</style>
