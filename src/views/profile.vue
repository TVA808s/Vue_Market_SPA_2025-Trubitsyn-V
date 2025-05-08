<template>
  <div class='content'>
    <aside class="sidebar">
      <div class="sidebarContent">
        <Skeleton class="h-[150px] w-[150px]"></Skeleton>
        <!-- <img class="h-[150px] w-[150px]" :src="avatar"> -->
        <div class="sidebarButtons">
          <div class="info">
            {{ DisplayedEmail }}
          </div>
          <Button @click="openChangeInfo()">change info</Button>
          <Button @click="logoutUser()">logout</Button>
        </div>
      </div>
    </aside>
    <div class="main-side">
      <h2>Orders history</h2>
      <main class="orders">
        <div class="order">
          <div class="date-number-div">
            <div class="date-div">
              <h4>Date</h4>
              <h4>*********</h4>
            </div>
            <div class="number-div">
              <h4>Number</h4>
              <h4>*******</h4>
            </div>
          </div>
          <div class="goods-div">
            <h4>Goods</h4>
            <div class="images-div">
              <Skeleton class="h-[60px] w-[85px]" />
              <Skeleton class="h-[60px] w-[85px]" />
              <Skeleton class="h-[60px] w-[85px]" />
              <Skeleton class="h-[60px] w-[85px]" />
            </div>
          </div>
          <div class="total-div">
            <h3>600$</h3>
          </div>
        </div>
        <div class="order">
          <div class="date-number-div">
            <div class="date-div">
              <h4>Date</h4>
              <h4>*********</h4>
            </div>
            <div class="number-div">
              <h4>Number</h4>
              <h4>*******</h4>
            </div>
          </div>
          <div class="goods-div">
            <h4>Goods</h4>
            <div class="images-div">
              <Skeleton class="h-[60px] w-[85px]" />
              <Skeleton class="h-[60px] w-[85px]" />
              <Skeleton class="h-[60px] w-[85px]" />
              <Skeleton class="h-[60px] w-[85px]" />
            </div>
          </div>
          <div class="total-div">
            <h3>600$</h3>
          </div>
        </div>
        <div class="order">
          <div class="date-number-div">
            <div class="date-div">
              <h4>Date</h4>
              <h4>*********</h4>
            </div>
            <div class="number-div">
              <h4>Number</h4>
              <h4>*******</h4>
            </div>
          </div>
          <div class="goods-div">
            <h4>Goods</h4>
            <div class="images-div">
              <Skeleton class="h-[60px] w-[85px]" />
              <Skeleton class="h-[60px] w-[85px]" />
              <Skeleton class="h-[60px] w-[85px]" />
              <Skeleton class="h-[60px] w-[85px]" />
            </div>
          </div>
          <div class="total-div">
            <h3>600$</h3>
          </div>
        </div>
        <div class="order">
          <div class="date-number-div">
            <div class="date-div">
              <h4>Date</h4>
              <h4>*********</h4>
            </div>
            <div class="number-div">
              <h4>Number</h4>
              <h4>*******</h4>
            </div>
          </div>
          <div class="goods-div">
            <h4>Goods</h4>
            <div class="images-div">
              <Skeleton class="h-[60px] w-[85px]" />
              <Skeleton class="h-[60px] w-[85px]" />
              <Skeleton class="h-[60px] w-[85px]" />
              <Skeleton class="h-[60px] w-[85px]" />
            </div>
          </div>
          <div class="total-div">
            <h3>600$</h3>
          </div>
        </div>
        <div class="order">
          <div class="date-number-div">
            <div class="date-div">
              <h4>Date</h4>
              <h4>*********</h4>
            </div>
            <div class="number-div">
              <h4>Number</h4>
              <h4>*******</h4>
            </div>
          </div>
          <div class="goods-div">
            <h4>Goods</h4>
            <div class="images-div">
              <Skeleton class="h-[60px] w-[85px]" />
              <Skeleton class="h-[60px] w-[85px]" />
              <Skeleton class="h-[60px] w-[85px]" />
              <Skeleton class="h-[60px] w-[85px]" />
            </div>
          </div>
          <div class="total-div">
            <h3>600$</h3>
          </div>
        </div>
        <div class="order">
          <div class="date-number-div">
            <div class="date-div">
              <h4>Date</h4>
              <h4>*********</h4>
            </div>
            <div class="number-div">
              <h4>Number</h4>
              <h4>*******</h4>
            </div>
          </div>
          <div class="goods-div">
            <h4>Goods</h4>
            <div class="images-div">
              <Skeleton class="h-[60px] w-[85px]" />
              <Skeleton class="h-[60px] w-[85px]" />
              <Skeleton class="h-[60px] w-[85px]" />
              <Skeleton class="h-[60px] w-[85px]" />
            </div>
          </div>
          <div class="total-div">
            <h3>600$</h3>
          </div>
        </div>
      </main>
    </div>
    <div class="changeWindow" v-if="userSession.openChangeWindow">
      <div class="changeWindowContent">
        <div class="contentHeader">

          <div class="closeChangeWindow" @click="userSession.setOpenChangeWindow(false)">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m18 18l-6-6m0 0L6 6m6 6l6-6m-6 6l-6 6"/></svg>        </div>
        </div>
        <div class="contentBody">
          <div class="contentTitle">
            Change info
          </div>

          <form @submit.prevent="changeInfo()">
            Mail
            <Input v-model="mail" type="text"/>
            Password
            <Input v-model="pass" type="password"/>
            Display name
            <Input v-model="name" type="text"/>
            Avatar
            <Input type="file" accept="image/png" @change="displayImage($event)"/>
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
import { onMounted, ref } from 'vue'
import { useUserSessionStore } from '@/stores/userSession'
import { useRouter } from 'vue-router'

const userSession = useUserSessionStore()
const user = ref('')
const router = useRouter()
const pass = ref('')
const mail = ref('')
const name = ref('')
const rawPhoto = ref(new Uint8Array())
const avatar = ref('')
const DisplayedEmail = ref('')
function hexStringToUint8Array(hexString) {
  // Удаляем префикс "\x" (если есть)
  const cleanHex = hexString.startsWith('\\x')
    ? hexString.slice(2)
    : hexString;

  // Создаем массив байтов
  const bytes = new Uint8Array(cleanHex.length / 2);
  for (let i = 0; i < cleanHex.length; i += 2) {
    bytes[i / 2] = parseInt(cleanHex.substr(i, 2), 16);
  }
  return bytes;
}

onMounted(async()=>{
  const { data: {user: authUser} } = await supabase.auth.getUser()
  if (authUser.id) {
    user.value = authUser.id
    DisplayedEmail.value = authUser.email
    // const {data, error} = await supabase.from('profiles').select('*').eq('id', user.value)
    // if (data) {
    //   const byteArray = hexStringToUint8Array(data[0].avatar);
    //   const blob = new Blob([byteArray], { type: 'image/png' });
    //   avatar.value = URL.createObjectURL(blob);
    //   console.log("Первые 4 байта:", byteArray.subarray(0, 4));

    // }
  }
})
const openChangeInfo = (async () => {
  userSession.setOpenChangeWindow(true)
  //
})
const changeInfo = async () => {
  if (pass.value && mail.value) {
    console.log('auth changed')
    const {data, error} = await supabase.auth.updateUser({password: pass.value, email: mail.value})
  }
  if (name.value || rawPhoto.value) {
    const {data: profiles, error} = await supabase.from('profiles').select("*").eq('id', user.value)
    if (profiles.length === 0) {
      const {data, error} = await supabase.from('profiles').insert([
        {id: user.value, avatar: '1313', full_name: name.value}
      ])
    } else if (profiles.length === 1) {
      const {data, error} = await supabase.from('profiles').update(
        {avatar: rawPhoto.value, full_name: name.value}
      ).eq('id', user.value)
    } else {
      console.log(error)
    }
  }
  userSession.setOpenChangeWindow(false)
}
async function displayImage(event) {
    const file = event.target.files[0]
    const arrayBuffer = await file.arrayBuffer()
    const uint8array = new Uint8Array(arrayBuffer)
    rawPhoto.value = uint8array
}

const logoutUser = (async () => {
  const {error} = await supabase.auth.signOut()
  userSession.setLoggedIn(false)
  router.push({name: 'market'})
})
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
@media (width <= 720px) {
  .content{
    flex-direction: column;
    .sidebar{
      .sidebarContent{
        display: flex;
        gap: 20px;
        .sidebarButtons{
          display: flex;
          flex-direction: column;
          gap: 20px;
          flex-grow: 1;
          Button{
            width: 100%;
          }
        }
      }
    }
  }
}
@media (width > 720px) {
.sidebar{
  position: sticky;
  top: 15px;
  height: 100vh;
  .sidebarButtons{
    display: flex;
    flex-direction: column;
    gap: 20px;
  }
  .sidebarContent{
    display: flex;
    flex-direction: column;
    gap: 20px;
  }
}
}
.content{
display: flex;
padding: 20px 0px;
gap:50px;
.main-side{
  display: flex;
  flex-direction: column;
  gap: 20px;
  flex-grow: 1;
}

.orders{
  display: flex;
  flex-direction: column;
  gap: 20px;

  .order{
    display: flex;
    border: 1px solid black;
    border-radius: 2px;
    align-items: center;
    justify-content: space-evenly;
    padding: 5px;
    gap: 10px;
    .date-number-div{
      flex: 1 1 30%;
      display: flex;
      flex-direction: column;
      gap: 15px;
      .number-div,.date-div{
        display: flex;
        justify-content: space-around;
        flex-wrap: wrap;
      }
    }
    .total-div{
      display: flex;
      flex: 1 1 20%;
    }
    .goods-div{
      flex: 1 1 50%;
      display: flex;
      flex-direction: column;
      .images-div{
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
      }
    }
  }
}
.changeWindow{
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
    .changeWindowContent{
      display: flex;
      border: 1px solid black;
      border-radius: 15px;
      flex-direction: column;
      background-color: #ffffff;
      width: 80%;
      max-width: 550px;
      padding: 20px 35px;
      .error{
        display: flex;
        justify-content: center;
        font-size: 18px;
        border-radius: 15px;
        background-color: #ffc0c0;
        padding: 5px;
      }
      .contentHeader{
        display: flex;
        position: relative;
        justify-content: center;
        gap: 20px;
        .closeChangeWindow{
          border-radius: 5px;

          position: absolute;
          left: 101%;
          top: -15px;
        }
        .closeChangeWindow:hover{
          background-color: #ffc0c0;
          transition: 0.2s;
        }
        Button{
          height: 30px;
          color: #5a5a5a;
          background-color: white;
        }
        Button:hover{
          background-color: #e4e4e4;
          transition: 0.1s;
          color: rgb(68, 68, 68);
        }
      }
      .contentBody{
        display: flex;
        flex-direction: column;
        gap: 10px;
        .contentTitle{
          font-size: 20px;
          font-weight: 600;
        }
        form{
          display: flex;
          flex-direction: column;
          gap: 5px;
          Input{
            height: 35px;
          }
          Button{
            margin-top: 10px;
          }
        }
      }
    }
  }
}
</style>
