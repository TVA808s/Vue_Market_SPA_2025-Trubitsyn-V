<template>
  <div class="basic">
    <header>
        <nav>
          <div class="header-market">
            <RouterLink to="/" @click="resetWindow()" data-hint="Sell page" aria-label="Sell page">Market</RouterLink>
          </div>
          <form @submit.prevent="searchFunc(search)">
            <div id="searchbar" class="relative w-full items-center">
              <Input v-model="search" id="search" type="text" placeholder="Search..." class="pl-10 w-full" />
              <span class="absolute start-0 inset-y-0 flex items-center justify-center px-2">
                <Search class="text-muted-foreground" />
              </span>
            </div>
            <Button type="submit">Find</Button>
          </form>
          <div class="header-pages">
            <RouterLink to="/favourite" data-hint="Favourite" aria-label="Favourite"><svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 24 24"><path fill="currentColor" d="m12.1 18.55l-.1.1l-.11-.1C7.14 14.24 4 11.39 4 8.5C4 6.5 5.5 5 7.5 5c1.54 0 3.04 1 3.57 2.36h1.86C13.46 6 14.96 5 16.5 5c2 0 3.5 1.5 3.5 3.5c0 2.89-3.14 5.74-7.9 10.05M16.5 3c-1.74 0-3.41.81-4.5 2.08C10.91 3.81 9.24 3 7.5 3C4.42 3 2 5.41 2 8.5c0 3.77 3.4 6.86 8.55 11.53L12 21.35l1.45-1.32C18.6 15.36 22 12.27 22 8.5C22 5.41 19.58 3 16.5 3"/></svg></RouterLink>
            <RouterLink to="/cart" data-hint="Cart" aria-label="Cart"><svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 24 24"><path fill="currentColor" d="M19 20c0 1.11-.89 2-2 2a2 2 0 0 1-2-2c0-1.11.89-2 2-2a2 2 0 0 1 2 2M7 18c-1.11 0-2 .89-2 2a2 2 0 0 0 2 2c1.11 0 2-.89 2-2s-.89-2-2-2m.2-3.37l-.03.12c0 .14.11.25.25.25H19v2H7a2 2 0 0 1-2-2c0-.35.09-.68.24-.96l1.36-2.45L3 4H1V2h3.27l.94 2H20c.55 0 1 .45 1 1c0 .17-.05.34-.12.5l-3.58 6.47c-.34.61-1 1.03-1.75 1.03H8.1zM8.5 11H10V9H7.56zM11 9v2h3V9zm3-1V6h-3v2zm3.11 1H15v2h1zm1.67-3H15v2h2.67zM6.14 6l.94 2H10V6z"/></svg></RouterLink>
            <RouterLink to="/profile" data-hint="Profile" aria-label="Profile"><svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 32 32"><path fill="currentColor" d="M12 4a5 5 0 1 1-5 5a5 5 0 0 1 5-5m0-2a7 7 0 1 0 7 7a7 7 0 0 0-7-7m10 28h-2v-5a5 5 0 0 0-5-5H9a5 5 0 0 0-5 5v5H2v-5a7 7 0 0 1 7-7h6a7 7 0 0 1 7 7zm0-26h10v2H22zm0 5h10v2H22zm0 5h7v2h-7z"/></svg></RouterLink>
          </div>
        </nav>
    </header>
    <div class="fast-categories">
      <router-link :to="`/${category}`" v-for="category in categories" :key="category"><Button>{{ category }}</Button></router-link>
    </div>
  </div>
  <div class="content">
    <RouterView :key="$route.fullPath"  />
  </div>
  <footer>
    <div class="marquee-container">
      <div class="marquee-content">
        <h2>SELF MADE - SELF MADE - SELF MADE --- TRUBITSYN VYACHESLAV --- SELF MADE - SELF MADE - SELF MADE</h2>
      </div>
    </div>
  </footer>
  <div class="logWindow" v-if="userSession.openLogWindow">
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
      <div class="contentBody" v-else>
        <div class="contentTitle">
          Registation
        </div>
        <div class="error" v-if="errorMessage !== ''">
          {{ errorMessage }}
        </div>
        <form @submit.prevent="registerUser()">
          Mail
          <Input v-model="mail" type="text" required/>
          Password
          <Input v-model="pass" type="password" required/>
          <Button type="submit">Submit</Button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { Input } from '@/components/ui/input'
import { Search } from 'lucide-vue-next'
import { Button } from '@/components/ui/button'
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useUserSessionStore, supabase } from '@/stores/userSession';
import { useGetProductsStore } from './stores/getProducts'
const route = useRoute()
const router = useRouter()
const errorMessage = ref('')
const getProducts = useGetProductsStore()
const userSession = useUserSessionStore();
const mail = ref('')
const pass = ref('')
const search = ref('')
const logOrReg = ref(true)
const categories = ref(['tv', 'audio', 'clothing', 'sports', 'electronics', 'gaming', 'mobile', 'books'])

onMounted(async () => {
  const {data} = await supabase.auth.getUser()
  if (data.user != null && data.user.role === "authenticated") {
    userSession.setLoggedIn(true)
  }
})


const closeLogWindow = () => {
  userSession.openLogWindow = false
  logOrReg.value = true
  errorMessage.value = ''
}

// сброс страницы по нажатию названия (из-аккаунта не выкидывает)
const resetWindow = () => {
  getProducts.setCategoryName('')
  if(route.path.length === 1) {
    router.go()
  } else {
    router.push('/')
  }
}

const searchFunc = (value) => {
  router.push('/')
  getProducts.setSearch(value)
  getProducts.productsReset()
  getProducts.fetchProducts()
  search.value = ''
}

const loginUser = async () => {
  const { data, error } = await supabase.auth.signInWithPassword({
    email: mail.value,
    password: pass.value
  })
  if (error) {
    errorMessage.value = error.message
    return
  }
  userSession.setLoggedIn(true)
  closeLogWindow()
  router.push(router.currentRoute.value.query.redirect)
  mail.value = ''
  pass.value = ''
}

const registerUser = async () => {
  const { data, error } = await supabase.auth.signUp({
    email: mail.value,
    password: pass.value
  })
  if (error) {
    errorMessage.value = error.message
  }
  if (!data.user.identities.length) {
    errorMessage.value = 'User already signed up'
  }
  else{
    logOrReg.value = !logOrReg.value
    mail.value = ''
    pass.value = ''
  }
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
[data-hint] { position: relative; cursor: hint; }
[data-hint]::after { opacity: 0; width: max-content; color: #FFFFFF; background-color: rgba(0,0,0,.6); border-radius: 6px; padding: 5px; content: attr(data-hint); font-size: 12px; font-weight: 400; line-height: 1em; position: absolute; top: 70px; left: 50%; transform: translate(-50%, -100%); pointer-events: none; transition: opacity 0.3s; }
[data-hint]:hover::after { opacity: 1; }
@media (width < 720px) {
  [data-hint]::after { display: none; }
  nav {
    flex-wrap: wrap;

  }
  .header-market{
    order:1;
    flex: 0 0 20%;
  }
  .header-pages{
    order: 2;
    flex: 0 0 40%;
  }
  form{
    order: 3;
    flex: 0 0 80%;
  }
}
  nav{
    padding: 10px 0px;
    display: flex;
    justify-content: space-around;
    gap: 20px;
    .header-market{
      @extend %h1;
      min-width: 20%;
      text-align: center;
    }
    .header-pages{
      display: flex;
      min-width: 20%;
      justify-content: space-around;
    }
    form{
      display: flex;
      align-items: center;
      min-width: 50%;
      gap:20px;
      Input{
        @extend %h4;
        width: 100%;
      }
      Button{
        width: 15%;
        background-color: #3d3535;
      }
      Button:hover{
        transition: 0.1s ease-out;
        background-color: rgb(199, 185, 176);
        color: rgb(63, 50, 42);
      }
    }
    svg:hover{
    color: rgb(87 83 78);
  }
  }
  .fast-categories{
    justify-self: center;
    padding: 10px 5px;
    width: 90%;
    display: flex;
    justify-content: space-around;
    flex-wrap: wrap;
    gap: 10px;
    Button{
      height: 35px;
      color: black;
      background-color: white;
      width: 8%;
      min-width: 80px;
      overflow:hidden;
    }
    Button:hover{
      background-color: rgb(231 229 228);
    }
  }
  .content{
    width: 95%;
    margin: 0 auto;
    min-height: 100vh;
  }


  footer{
    width: 100%;
  }
  .marquee-container {
  overflow: hidden;
  white-space: nowrap;
  background: #ffc0c0;
  color: #fff;
  position: relative;
  }
  .marquee-container::before {
    background: linear-gradient(to right, #ffc0c0, #ffc0c0);
    left: 0;
  }
  .marquee-container::after {
    background: linear-gradient(to left, #ffc0c0, #ffc0c0);
    right: 0;
  }
  .marquee-content {
    display: inline-block;
    animation: marquee 15s linear infinite;
    padding-left: 100%;
  }
  .marquee-content:hover {
    animation-play-state: paused;
  }
  @keyframes marquee {
    0% {
      transform: translateX(0);
    }
    100% {
      transform: translateX(-100%);
    }
  }
  .marquee-content h2 {
    display: inline-block;
    padding-right: 2em;
  }

  .logWindow{
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
    .logWindowContent{
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
        .closeLogWindow{
          border-radius: 5px;

          position: absolute;
          left: 101%;
          top: -15px;
        }
        .closeLogWindow:hover{
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
            background-color: #3d3535;
          }
          Button:hover{
            transition: 0.1s ease-out;
            background-color: rgb(199, 185, 176);
            color: rgb(63, 50, 42);
          }
        }
      }
    }
  }
</style>
