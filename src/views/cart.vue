<template>
  <div class="cart">
    <h2>Cart</h2>
    <div v-if="cartIsLoading" class="skeletonCart" v-for="i in Array(8)">
      <Skeleton class="h-[100px] w-full"></Skeleton>
    </div>
    <div class="information" v-show="!cartIsLoading">
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
                <Button @click="visit(item.product.id)">Visit</Button>
              </div>
            </th>
          </tr>
        </tbody>
      </table>
      <div class="pay-div">
        <Button @click="makeOrder()"><h2>Make an order</h2></Button>
        <div class="count-div">
          <h4>Goods</h4>
          <h4>{{ payBlock.goods }}</h4>
        </div>
        <div class="cost-div">
          <h4>Cost</h4>
          <h4>{{ payBlock.cost }}</h4>
        </div>
        <div class="discount-div">
          <h4>Discount</h4>
          <h4>{{ discount }}</h4>
        </div>
        <div class="total-div">
          <h3>Total</h3>
          <h3>{{ payBlock.total.toFixed(2) }}</h3>
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
              <h3>Final sum is {{ payBlock.total }}</h3>
              <Button type="submit">Pay</Button>
            </div>
          </form>
          <i>site in development state, payments are scripted, do not enter your card info</i>
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
import { useRouter } from 'vue-router'
import Skeleton from '@/components/ui/skeleton/Skeleton.vue'

// оптимизация 1 - вмест массивов использовать сеты
// оптимизация 2 - батчинг запросов к супабэйс

const router = useRouter()
const favProducts = useFavProductsStore()
const userSession = useUserSessionStore()
const masterCheck = ref(true)
const cart_id = ref('')
const items_to_buy = ref(new Set())
const checkout = YooMoneyCheckout('1090142', { language: 'en' })
const cartIsLoading = ref(true)
const userId = ref('')

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
    })
    if (paymentData.res.paid) {
      const { data: order, error } = await supabase
        .from('orders')
        .insert({
          user_id: userId.value,
          status: 'paid',
          total: paymentData.res.amount.value,
          created_at: new Date().toISOString()
        })
        .select()
      if (order) {
        const { data: order_items, error } = await supabase.from('order_items').insert(
          Array.from(items_to_buy.value).map((item) => ({
            order_id: order[0].id,
            product_image: item.product.image,
            product_title: item.product.title,
            quantity: item.quantity,
            price: item.quantity * item.product.price * (1 - item.product.discount / 100)
          }))
        )
        if (error === null) {
          await supabase.from('cart_items').delete().eq('cart_id', cart_id.value)
          userSession.setOpenOrderWindow(false)
          router.push('/profile')
        }
      }
    } else {
      alert('error')
    }
  }
}

const visit = (id) => {
  router.push(`/market/${id}`)
}

onMounted(async () => {
  const {
    data: { user }
  } = await supabase.auth.getUser()
  if (user) {
    userId.value = user.id
    const { data } = await supabase.from('carts').select('id').eq('user_id', userId.value)
    if (!data[0].id) {
      alert('add some to the cart')
    } else {
      cart_id.value = data[0].id
      const { data: cart_items } = await supabase
        .from('cart_items')
        .select('id, quantity, product_id')
        .eq('cart_id', data[0].id)
        .in('product_id', Array.from(favProducts.cartList))
      const { data: products } = await supabase
        .from('products')
        .select('title, category, price, id, stock, discount, image')
        .in('id', Array.from(favProducts.cartList))
      favProducts.cartItem = new Set(
        cart_items.map((item) => ({
          ...item,
          product: products.find((p) => p.id === item.product_id)
        }))
      )
      items_to_buy.value = new Set(favProducts.cartItem)
      cartIsLoading.value = false
    }
  } else {
    console.log('not logged')
  }
})

const makeOrder = () => {
  if (payBlock.value.total < 1) {
    alert('Get sum goods first')
  } else {
    userSession.setOpenOrderWindow(true)
  }
}

const masterCheckDoSum = () => {
  if (masterCheck.value) {
    items_to_buy.value = new Set(favProducts.cartItem)
  } else {
    items_to_buy.value.clear()
  }
}

const checkboxDoSum = (item) => {
  if (items_to_buy.value.has(item)) {
    items_to_buy.value.delete(item)
  } else {
    items_to_buy.value.add(item)
  }
}

const payBlock = computed(() => {
  return Array.from(items_to_buy.value).reduce(
    (block, item) => {
      const price = item.product.price
      const discount = item.product.discount
      const quantity = item.quantity

      block.goods += quantity
      block.cost += price * quantity
      block.total += price * (1 - discount / 100) * quantity
      return block
    },
    { goods: 0, cost: 0, total: 0, sum: 0 }
  )
})

const discount = computed(() => {
  const { cost, total } = payBlock.value
  return cost > 0 ? Math.round((1 - total / cost) * 100) : 0
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
  if (item.quantity - 1 === 0) {
    remove(item)
  } else {
    item.quantity -= 1
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
  favProducts.cartItem.delete(item)
  items_to_buy.value.delete(item)
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
