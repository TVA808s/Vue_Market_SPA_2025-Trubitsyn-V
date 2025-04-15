<template>
  <div class='content'>
    <aside class="sidebar">
      <form>
        <Skeleton class="h-[150px] w-[150px]"></Skeleton>
        <h2>Username</h2>
        <h3>+79006008020</h3>
        <Button>Change info</Button>
      </form>
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
  </div>
</template>

<script setup>
import Skeleton from '@/components/ui/skeleton/Skeleton.vue'
import Button from '@/components/ui/button/Button.vue';
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
.content{
display: flex;
padding: 20px 0px;
gap:50px;
.sidebar{
  position: sticky;
  top: 15px;
  height: 100vh;
  form{
    display: flex;
    flex-direction: column;
    gap: 20px;
  }
}
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
