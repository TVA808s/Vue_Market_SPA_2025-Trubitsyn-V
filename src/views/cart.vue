<template>
  <div class='cart'>
    <h2>Cart</h2>
    <div class="information">
      <table>
        <thead>
          <tr>
            <th><Checkbox></Checkbox></th>
            <th>Name</th>
            <th>Category</th>
            <th>Price</th>
            <th>Amount</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <th><Checkbox></Checkbox></th>
            <th>Name</th>
            <th>Category</th>
            <th>Price</th>
            <th>
              <div class="double-cell">
                ***
                <div class="count-buttons">
                  <Button>+</Button>
                  <Button>-</Button>
                </div>
              </div>
            </th>
            <th>
              <div class="double-cell">
                  <Button>Delete</Button>
                  <Button>Visit</Button>
              </div>
            </th>
          </tr>
          <tr>
            <th><Checkbox></Checkbox></th>
            <th>Name</th>
            <th>Category</th>
            <th>Price</th>
            <th>
              <div class="double-cell">
                ***
                <div class="count-buttons">
                  <Button>+</Button>
                  <Button>-</Button>
                </div>
              </div>
            </th>
            <th>
              <div class="double-cell">
                  <Button>Delete</Button>
                  <Button>Visit</Button>
              </div>
            </th>
          </tr>
          <tr>
            <th><Checkbox></Checkbox></th>
            <th>Name</th>
            <th>Category</th>
            <th>Price</th>
            <th>
              <div class="double-cell">
                ***
                <div class="count-buttons">
                  <Button>+</Button>
                  <Button>-</Button>
                </div>
              </div>
            </th>
            <th>
              <div class="double-cell">
                  <Button>Delete</Button>
                  <Button>Visit</Button>
              </div>
            </th>
          </tr>
        </tbody>
      </table>
      <div class="pay-div">
        <Button><h2>Make an order</h2></Button>
        <div class="count-div">
          <h4>Goods</h4>
          <h4>***</h4>
        </div>
        <div class="cost-div">
          <h4>Cost</h4>
          <h4>***</h4>
        </div>
        <div class="discount-div">
          <h4>Discount</h4>
          <h4>***</h4>
        </div>
        <div class="total-div">
          <h3>Total</h3>
          <h3>***</h3>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import Checkbox from '@/components/ui/checkbox/Checkbox.vue';
import Button from '@/components/ui/button/Button.vue';
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
th{
  @extend %h3;
  border: 1px solid black;
  padding: 5px 10px;
  min-width: 5%;
}
tr{
  border-collapse: collapse;
}
</style>
