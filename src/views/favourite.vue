<template>
  <div class='content'>
    <aside class="sidebar">
      <form>
        <h2>Filters</h2>
        <h3>Cost</h3>
        <div class="cost-div">
          <Input type="text" placeholder="0"/>
          <Input type="text" placeholder="1000"/>
        </div>
        <h3>Color</h3>
        <div class="color-div">
          <div class="flex items-center space-x-2">
            <Checkbox id="red" name="red" />
            <label style="color:red;"
              for="red"
              class="cursor-pointer text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
              red
            </label>
          </div>
          <div class="flex items-center space-x-2">
            <Checkbox id="black" name="black" />
            <label
              for="black"
              class="cursor-pointer text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
              black
            </label>
          </div>
          <div class="flex items-center space-x-2" style="background-color: grey;">
            <Checkbox id="white" name="white" />
            <label style="color:white"
              for="white"
              class="cursor-pointer text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
              white
            </label>
          </div>
        </div>
      </form>
    </aside>
    <div class="main-side">
    <div class="top-main-side">
    <h2>Favourite</h2>
    <Select>
      <SelectTrigger class="w-[300px]">
        <SelectValue placeholder="Sort by" />
      </SelectTrigger>
      <SelectContent>
        <SelectLabel>Sort by</SelectLabel>
        <SelectItem value="default">
            default
          </SelectItem>
        <SelectGroup>
          <SelectItem value="cost-up">
            cost-up
          </SelectItem>
          <SelectItem value="rate-down">
            rate-down
          </SelectItem>
          <SelectItem value="cost-down">
            cost-down
          </SelectItem>
          <SelectItem value="rate-up">
            rate-up
          </SelectItem>
        </SelectGroup>
      </SelectContent>
    </Select>
  </div>
    <main class="cards">
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>

      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
      <div class="flex flex-col space-y-3">
        <Skeleton class="h-[200px] w-[300px] rounded-xl" />
        <div class="space-y-2">
          <Skeleton class="h-8 w-[300px]" />
          <Skeleton class="h-4 w-[300px]" />
          <Skeleton class="h-10 w-[300px]" />
        </div>
      </div>
    </main>
  </div>
</div>
</template>

<script setup>
import Input from '@/components/ui/input/Input.vue'
import Checkbox  from '@/components/ui/checkbox/Checkbox.vue'
import Skeleton from '@/components/ui/skeleton/Skeleton.vue'
import Select from '@/components/ui/select/Select.vue'
import SelectContent from '@/components/ui/select/SelectContent.vue'
import SelectGroup from '@/components/ui/select/SelectGroup.vue'
import SelectItem from '@/components/ui/select/SelectItem.vue'
import SelectValue from '@/components/ui/select/SelectValue.vue'
import SelectTrigger from '@/components/ui/select/SelectTrigger.vue'
import SelectLabel from '@/components/ui/select/SelectLabel.vue'
import { supabase } from '@/stores/userSession'
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
.sidebar{
  position: sticky;
  top: 15px;
  height: 100vh;
  form{
    display: flex;
    flex-direction: column;
    gap: 15px;
    .cost-div{
      display: flex;
      width: 90%;
      gap: 10px;
      Input{
        width: 100px;
      }
    }
    .color-div{
      display: flex;
      flex-direction: column;
      gap: 10px;
      >*{
        width: 80px;
      }
    }
  }
}
.main-side{
  display: flex;
  flex-direction: column;
  gap: 20px;
  .top-main-side{
    display: flex;
    align-items: center;
    gap: 5%;
    flex-wrap: wrap;
  }
}
.cards{
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 30px;
  >*{
    margin: 0 auto;
  }
}
}
</style>
