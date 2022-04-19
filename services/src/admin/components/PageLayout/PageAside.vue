<template>
  <el-row class="tac">
    <el-col :span="24">
      <el-menu
        default-active="1"
        class="left-menu"
        @open="handleOpen"
        @close="handleClose"
        background-color="#545c64"
        text-color="#fff"
        active-text-color="#ffd04b">
        <router-link to="/role">
          <el-menu-item index="1">
            <i class="el-icon-s-custom"></i>
            <span slot="title">角色管理</span>
          </el-menu-item>
        </router-link>
        <router-link to="/dapp">
          <el-menu-item index="2">
            <i class="el-icon-cpu"></i>
            <span slot="title">dapp审核</span>
          </el-menu-item>
        </router-link>
        <router-link to="/log">
          <el-menu-item index="3">
            <i class="el-icon-document"></i>
            <span slot="title">日志管理</span>
          </el-menu-item>
        </router-link>
        <router-link to="/hackathon">
          <el-menu-item index="4">
            <i class="el-icon-s-opportunity"></i>
            <span slot="title">黑客松管理</span>
          </el-menu-item>
        </router-link>
        <router-link to="/banner">
          <el-menu-item index="9">
            <i class="el-icon-setting"></i>
            <span slot="title">轮播图设置</span>
          </el-menu-item>
        </router-link>
      </el-menu>
    </el-col>
  </el-row>

</template>
<script>
  /**
   * Aside component
   */
  export default {
    name: 'PageAside',
    data() {
      return {
      }
    },
    methods: {}
  }
</script>

<style lang="scss" scoped>
  //使侧边栏高度和页面一致
  .left-menu{
    height: 100vh;
  }
</style>
