<template>
  <div class='content'>
    <aside class="sidebar">
      <div class="sidebarContent">
        <Skeleton class="h-[150px] w-[150px]"></Skeleton>
        <div class="sidebarButtons">
          <div class="info">
            {{ user.email }}
          </div>
          <Button @click="changeInfo()">change info</Button>
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
    <div class="logWindow" >
      <div class="logWindowContent">
        <div class="contentHeader">
          <Button @click="logOrReg=true; errorMessage=''">login</Button>
          <Button @click="logOrReg=false; errorMessage=''">regisration</Button>
          <div class="closeLogWindow" @click="closeLogWindow()">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m18 18l-6-6m0 0L6 6m6 6l6-6m-6 6l-6 6"/></svg>        </div>
        </div>
        <div class="contentBody" v-if="logOrReg">
          <div class="contentTitle">
            Login
          </div>
          <div class="error" v-if="errorMessage !== ''">
            {{ errorMessage }}
          </div>
          <form @submit.prevent="loginUser()">
            Mail
            <Input v-model="mail" type="text" required/>
            Password
            <Input v-model="pass" type="password" required/>
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
import { supabase } from '@/stores/userSession'
import { onMounted, ref } from 'vue'
import { useUserSessionStore } from '@/stores/userSession'
import { useRouter } from 'vue-router'
const userSession = useUserSessionStore()
const user = ref('')
const router = useRouter()
onMounted(async()=>{
  const { data: {user: authUser} } = await supabase.auth.getUser()
  user.value = authUser

})
const changeInfo = (async () => {

  const {data, error} = await supabase.auth.updateUser({password: '123456', email: ''})

})
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
}
</style>
