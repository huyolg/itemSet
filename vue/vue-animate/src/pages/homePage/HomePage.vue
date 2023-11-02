<template>
  <div>
    <text class="item" v-for="item in tableData" :key="item.name">
      <!-- <RouterLink to="/five-chess">{{ item.name }}</RouterLink> -->
      <el-link href="/five-chess" target="_blank">{{ item.name }}</el-link>
    </text>
  </div>
</template>

<script lang="ts" setup>
interface model {
  name: string
}
const tableData: model[] = [
  {
    name: '五子棋'
  }
]

const handlerSelectTabl = (item: model) => {
  console.log(item)
}
</script>

<style scoped>
.item {
  cursor: pointer;
}
</style>
