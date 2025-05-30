<template>
  <div class="content">
    <aside class="sidebar">
      <div class="sidebarContent">
        <Skeleton v-if="avatarIsLoading" class="h-[200px] w-[200px]"></Skeleton>
        <img
          v-show="!avatarIsLoading"
          @load="avatarLoaded()"
          class="h-[200px] w-[200px]"
          :src="avatar"
        />
        <div class="sidebarButtons">
          <Skeleton v-if="avatarIsLoading" class="h-[30px] w-full"></Skeleton>
          <h3 v-show="userName != ''">{{ userName }}</h3>
          <h3 v-show="!avatarIsLoading">{{ DisplayedEmail }}</h3>
          <Button @click="openChangeInfo()">change info</Button>
          <Button @click="logoutUser()">logout</Button>
        </div>
      </div>
    </aside>
    <div class="main-side">
      <h2>Orders history</h2>
      <div v-if="ordersAreLoading" class="skeletons orders">
        <div class="skeleton" v-for="i in Array(8)">
          <Skeleton class="h-[120px] w-full"></Skeleton>
        </div>
      </div>
      <main class="orders" v-show="!ordersAreLoading">
        <div class="order" v-for="order in reversedOrders" :key="order.id">
          <div class="date-number-div">
            <div class="date-div">
              <h4>Date</h4>
              <h4>{{ new Date(order.created_at).toLocaleDateString('es') }}</h4>
            </div>
            <div class="number-div">
              <h4>Order id</h4>
              <h4>{{ order.id }}</h4>
            </div>
          </div>
          <div class="goods-div">
            <h4>Goods</h4>
            <div class="images-div">
              <div class="imgDiv" v-for="item in order.order_items" :key="item.id">
                <img v-lazy="item.product_image" :alt="item.product_title" />
              </div>
            </div>
          </div>
          <div class="total-div">
            <h3>{{ order.total }}$</h3>
          </div>
        </div>
      </main>
    </div>
    <div class="changeWindow" v-if="userSession.openChangeWindow">
      <div class="changeWindowContent">
        <div class="contentHeader">
          <div class="closeChangeWindow" @click="userSession.setOpenChangeWindow(false)">
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
          <div class="contentTitle">Change info</div>

          <form @submit.prevent="changeInfo()">
            Mail
            <Input v-model="mail" type="text" />
            Password
            <Input v-model="pass" type="password" />
            Display name
            <Input v-model="name" type="text" />
            Avatar
            <Input type="file" accept="image/png" @change="displayImage($event)" />
            <Button type="submit">Submit</Button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import Skeleton from '@/components/ui/skeleton/Skeleton.vue'
import Button from '@/components/ui/button/Button.vue'
import { Input } from '@/components/ui/input'
import { supabase } from '@/stores/userSession'
import { onMounted, ref, computed, watch } from 'vue'
import { useUserSessionStore } from '@/stores/userSession'
import { useRouter, useRoute } from 'vue-router'
import { useFavProductsStore } from '@/stores/favProducts'
import { useGetProductsStore } from '@/stores/getProducts'
const route = useRoute()
const getProducts = useGetProductsStore()
const favProducts = useFavProductsStore()
const userSession = useUserSessionStore()
const userId = ref('')
const router = useRouter()
const pass = ref('')
const mail = ref('')
const name = ref('')
const DisplayedEmail = ref('')
const avatar = ref('')
const filePath = ref('')
const orders = ref([])
const avatarIsLoading = ref(true)
const ordersAreLoading = ref(true)
const rawPhoto = ref('')
const userName = ref('')
const reversedOrders = computed(() => {
  return [...orders.value].reverse()
})

onMounted(async () => {
  const {
    data: { user }
  } = await supabase.auth.getUser()
  if (user.id) {
    userId.value = user.id
    filePath.value = `${userId.value}/avatar`
    DisplayedEmail.value = user.email
    const { data } = await supabase
      .from('profiles')
      .select('full_name, avatar_url')
      .eq('id', userId.value)
    userName.value = data[0].full_name
    avatar.value = `${data[0].avatar_url}?t=${new Date().getTime()}` // supabase игнорирует query "t" из-за чего берет изображение по ссылке, а браузер не берет прошлое закешированное изображение из-за другого запроса к серверу
    const { data: myOrders, error } = await supabase
      .from('orders')
      .select('*, order_items (*)')
      .eq('user_id', userId.value)
    orders.value = myOrders
    if (orders.value.length > 0) {
      ordersAreLoading.value = false
    }
  }
})

const avatarLoaded = () => {
  avatarIsLoading.value = false
}

const openChangeInfo = async () => {
  userSession.setOpenChangeWindow(true)
  //
}
const changeInfo = async () => {
  try {
    if (pass.value || mail.value) {
      const updates = {}
      if (pass.value) updates.password = pass.value
      if (mail.value) updates.email = mail.value
      const { error } = await supabase.auth.updateUser(updates)
      if (error) throw error
    }

    if (name.value || rawPhoto.value) {
      const profileUpdate = {}
      if (name.value) profileUpdate.full_name = name.value
      if (rawPhoto.value) profileUpdate.avatar_url = rawPhoto.value

      const { error } = await supabase.from('profiles').upsert(
        {
          id: userId.value,
          ...profileUpdate
        },
        { onConflict: 'id' }
      )
      if (error) throw error
      avatar.value = rawPhoto.value
      userName.value = name.value
    }

    userSession.setOpenChangeWindow(false)
  } catch (error) {
    console.log(error)
  }
}

async function displayImage(event) {
  const file = event.target.files[0]
  if (file.size > 10 * 1024 * 1024) {
    alert('Max file size 10 MB')
    return
  }
  try {
    const { data } = await supabase.storage.from('avatars').exists(filePath.value)
    if (data) {
      await supabase.storage.from('avatars').remove([filePath.value])
    }
    await supabase.storage.from('avatars').upload(filePath.value, file, { upsert: true })
    const { data: urlData } = await supabase.storage.from('avatars').getPublicUrl(filePath.value)
    rawPhoto.value = `${urlData.publicUrl}?t=${new Date().getTime()}`
  } catch (e) {
    console.log(e)
  }
}

const logoutUser = async () => {
  const { error } = await supabase.auth.signOut()
  userSession.setLoggedIn(false)
  favProducts.favList.clear()
  favProducts.cartList.clear()
  getProducts.setCategoryName('')
  router.push('/')
}
</script>

<style lang="scss" scoped>
@use '@/extends.scss';
h1,
h2,
h3 {
  @extend %cursor;
}
h2 {
  @extend %h2;
}
h3 {
  @extend %h3;
}
@media (width <= 720px) {
  .content {
    flex-direction: column;
    .sidebar {
      .sidebarContent {
        display: flex;
        gap: 20px;
        .sidebarButtons {
          display: flex;
          flex-direction: column;
          gap: 20px;
          flex-grow: 1;
          Button {
            width: 100%;
          }
        }
      }
    }
  }
}
@media (width > 720px) {
  .sidebar {
    position: sticky;
    top: 15px;
    height: 100vh;
    .sidebarButtons {
      display: flex;
      flex-direction: column;
      gap: 20px;
    }
    .sidebarContent {
      display: flex;
      flex-direction: column;
      gap: 20px;
    }
  }
}
.content {
  display: flex;
  padding: 20px 0px;
  gap: 50px;
  .main-side {
    display: flex;
    flex-direction: column;
    gap: 20px;
    flex-grow: 1;
  }

  .orders {
    display: flex;
    flex-direction: column;
    gap: 20px;

    .order {
      display: flex;
      border: 1px solid black;
      border-radius: 2px;
      align-items: center;
      justify-content: space-evenly;
      padding: 5px;
      gap: 10px;
      .date-number-div {
        flex: 1 1 30%;
        display: flex;
        flex-direction: column;
        gap: 15px;
        .number-div,
        .date-div {
          display: flex;
          justify-content: space-evenly;
          flex-wrap: wrap;
        }
      }
      .total-div {
        display: flex;
        flex: 1 1 20%;
      }
      .goods-div {
        flex: 1 1 50%;
        display: flex;
        flex-direction: column;
        .images-div {
          display: flex;
          gap: 10px;
          flex-wrap: wrap;
          justify-content: space-evenly;
          .imgDiv {
            display: flex;
            width: 80px;
          }
        }
      }
    }
  }
  .changeWindow {
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
    .changeWindowContent {
      display: flex;
      border: 1px solid black;
      border-radius: 15px;
      flex-direction: column;
      background-color: #ffffff;
      width: 80%;
      max-width: 550px;
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
        .closeChangeWindow {
          border-radius: 5px;

          position: absolute;
          left: 101%;
          top: -15px;
        }
        .closeChangeWindow:hover {
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
          display: flex;
          flex-direction: column;
          gap: 5px;
          Input {
            height: 35px;
          }
          Button {
            margin-top: 10px;
          }
        }
      }
    }
  }
}
</style>
