<template>
  <div id="app">
    <el-container>
      <el-header class="header" style="background-color: black;">
        <PageNavbar @ok='parentEvent'></PageNavbar>
      </el-header>
      <el-container>
        <el-aside width="200px">
          <PageAside></PageAside>
        </el-aside>
        <el-main class="main">
          <router-view v-if="ok===true"></router-view>
          <div v-else>请登录II</div>
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script>
  import { PageAside } from 'a@/components'
  import { PageNavbar } from 'a@/components'
  export default {
    name: 'App',
    components: { PageAside,PageNavbar },
    data() {
      return {
        //导航条登录才能显示管理系统的内容
        ok:false,
      }
    },
    methods:{
      parentEvent(){
        this.ok=true;
        console.log(this.ok);
      }
    }
  }
</script>

<style lang="scss" scoped>
.el-header{
  padding: 0;
}
.header{
  /*background-color: gray;*/
}
  .main{
    background-color: #f0f2f5;
  }
</style>
